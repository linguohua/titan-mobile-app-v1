import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'nativel2_bindings_generated.dart';

class _JSONCallRsp {
  _JSONCallRsp(this.requestID, this.rsp);

  final int requestID;
  final String rsp;
}

class _JSONCallContext {
  _JSONCallContext(this.requestID, this.args);

  final int requestID;
  final String args;
}

class _JSONCallExecutor {
  _JSONCallExecutor(this._context);

  final _JSONCallContext _context;

  _JSONCallRsp doNativeCall() {
    String strResult;
    strResult = _ffiDirectInvoke(_context.args);
    return _JSONCallRsp(_context.requestID, strResult);
  }

  String _ffiDirectInvoke(String args) {
    final Nativel2Bindings bindings = NativeBinder()._bindings;

    var argsPtr = _context.args.toNativeUtf8().cast<Char>();
    Pointer<Char> ptrChar = bindings.JSONCall(argsPtr);
    String strResult = ptrChar.cast<Utf8>().toDartString();

    malloc.free(argsPtr);
    bindings.FreeCString(ptrChar);

    return strResult;
  }
}

class NativeBinder {
  // singleton pattern
  static final NativeBinder _instance = NativeBinder._internal();
  late Nativel2Bindings _bindings;
  static const String _libName = 'gol2';

  NativeBinder._internal() {
    _bindings = Nativel2Bindings(_loadDynamicLib());
  }

  factory NativeBinder() {
    return _instance;
  }

  DynamicLibrary _loadDynamicLib() {
    if (Platform.isMacOS || Platform.isIOS) {
      // return DynamicLibrary.process();
      return DynamicLibrary.open('$_libName.framework/$_libName');
    }
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('lib$_libName.so');
    }
    if (Platform.isWindows) {
      var currentDir = path.dirname(Platform.script.toFilePath());
      var libraryPath =
          path.join(currentDir, 'windows', 'libs', '$_libName.dll');
      return DynamicLibrary.open(libraryPath);
    }
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }
}

class IsolateCallAgent {
  static final IsolateCallAgent _instance = IsolateCallAgent._internal();

  IsolateCallAgent._internal() {
    _helperIsolateSendPortFuture = _isolateNew();
  }

  factory IsolateCallAgent() {
    return _instance;
  }

  int _nextJSONCallRequestId = 0;
  final Map<int, Completer<String>> _jsonCallRequests =
      <int, Completer<String>>{};
  late Future<SendPort> _helperIsolateSendPortFuture;

  Future<SendPort> _isolateNew() async {
    // The helper isolate is going to send us back a SendPort, which we want to
    // wait for.
    final Completer<SendPort> completer = Completer<SendPort>();

    // Receive port on the main isolate to receive messages from the helper.
    // We receive two types of messages:
    // 1. A port to send messages on.
    // 2. Responses to requests we sent.
    final ReceivePort receivePort = ReceivePort()
      ..listen((dynamic data) {
        if (data is SendPort) {
          // The helper isolate sent us the port on which we can sent it requests.
          completer.complete(data);
          return;
        }
        if (data is _JSONCallRsp) {
          // The helper isolate sent us a response to a request we sent.
          final Completer<String> completer2 =
              _jsonCallRequests[data.requestID]!;
          _jsonCallRequests.remove(data.requestID);

          completer2.complete(data.rsp);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Start the helper isolate.
    await Isolate.spawn((SendPort sendPort) async {
      final ReceivePort helperReceivePort = ReceivePort()
        ..listen((dynamic data) {
          // On the helper isolate listen to requests and respond to them.
          if (data is _JSONCallContext) {
            final _JSONCallExecutor exe = _JSONCallExecutor(data);
            final _JSONCallRsp result = exe.doNativeCall();
            sendPort.send(result);
            return;
          }
          throw UnsupportedError(
              'Unsupported message type: ${data.runtimeType}');
        });

      // Send the port to the main isolate on which we can receive requests.
      sendPort.send(helperReceivePort.sendPort);
    }, receivePort.sendPort);

    // Wait until the helper isolate has sent us back the SendPort on which we
    // can start sending requests.
    return completer.future;
  }

  Future<String> _isolateJsonCall(String args) async {
    var helperIsolateSendPort = await _helperIsolateSendPortFuture;
    final int requestId = _nextJSONCallRequestId++;
    final _JSONCallContext request = _JSONCallContext(requestId, args);

    final Completer<String> completer = Completer<String>();
    _jsonCallRequests[requestId] = completer;
    helperIsolateSendPort.send(request);

    return completer.future;
  }
}

class NativeL2 {
  // singleton pattern
  static final NativeL2 _instance = NativeL2._internal();
  static const platform = MethodChannel('titan/nativel2');

  NativeL2._internal();

  factory NativeL2() {
    return _instance;
  }

  Future<String> jsonCall(String args) async {
    if (Platform.isAndroid) {
      return await _androidJSonCall(args);
    }

    return IsolateCallAgent()._isolateJsonCall(args);
  }

  Future<String?> isEmulator() async {
    var result =
        await platform.invokeMethod<String>('isEmulator', {"args": {}});
    return result;
  }

  Future<String> setServiceStartupCmd(String cmd) async {
    if (Platform.isAndroid) {
      String? result;
      try {
        result = await platform
            .invokeMethod<String>('setServiceStartupCmd', {"args": cmd});
      } on PlatformException catch (e) {
        return jsonEncode({"code": -1, "msg": "${e.message}"});
      }

      return result!;
    } else {
      // return code 0, indicate it is just ok on non-android platform
      return jsonEncode({"code": 0, "msg": "only support android"});
    }
  }

  Future<String> setServiceLocale(String cmd) async {
    if (Platform.isAndroid) {
      String? result;
      try {
        result = await platform
            .invokeMethod<String>('setServiceLocale', {"args": cmd});
      } on PlatformException catch (e) {
        return jsonEncode({"code": -1, "msg": "${e.message}"});
      }

      return result!;
    } else {
      // return code 0, indicate it is just ok on non-android platform
      return jsonEncode({"code": 0, "msg": "only support android"});
    }
  }

  Future<String> _androidJSonCall(String args) async {
    String? result;
    try {
      result = await platform.invokeMethod<String>('jsonCall', {"args": args});
    } on PlatformException catch (e) {
      return jsonEncode({"code": -1, "msg": "${e.message}"});
    }

    return result!;
  }
}
