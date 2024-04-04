import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'nativel2_bindings_generated.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;


class JSONCallRsp {
  JSONCallRsp(this.requestID, this.rsp);
  final int requestID;
  final String rsp;
}

class JSONCallContext {
  JSONCallContext(this.requestID, this.args);

  final int requestID;
  final String? args;
}

class JSONCallExecutor {
  JSONCallExecutor(this._context);

  final JSONCallContext _context;

  JSONCallRsp doNativeCall() {
    final Nativel2Bindings bindings = L2APIs()._bindings;

    var argsPtr = _context.args!.toNativeUtf8().cast<Char>();
    Pointer<Char> ptrChar = bindings.JSONCall(argsPtr);
    String strResult = ptrChar.cast<Utf8>().toDartString();

    malloc.free(argsPtr);
    bindings.FreeCString(ptrChar);

    return JSONCallRsp(_context.requestID, strResult);
  }
}

class L2APIs {
  // singleton pattern
  static final L2APIs _instance = L2APIs._internal();

  static const String _libName = 'gol2';

  final DynamicLibrary _dylib = () {
    if (Platform.isMacOS || Platform.isIOS) {
      return DynamicLibrary.open('$_libName.framework/$_libName');
    }
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('lib$_libName.so');
    }
    if (Platform.isWindows) {
      var currentDir = path.dirname(Platform.script.toFilePath());
      var libraryPath = path.join(currentDir, 'windows', 'libs', '$_libName.dll');
      return DynamicLibrary.open(libraryPath);
    }
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }();

  late Nativel2Bindings _bindings;
  int _nextJSONCallRequestId = 0;
  final Map<int, Completer<String>> _jsonCallRequests =
      <int, Completer<String>>{};
  late Future<SendPort> _helperIsolateSendPortFuture;

  L2APIs._internal() {
    _bindings = Nativel2Bindings(_dylib);
    _helperIsolateSendPortFuture = _isolateNew();
  }

  factory L2APIs() {
    return _instance;
  }

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
        if (data is JSONCallRsp) {
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
          if (data is JSONCallContext) {
            final JSONCallExecutor exe = JSONCallExecutor(data);
            final JSONCallRsp result = exe.doNativeCall();
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

  Future<String> jsonCall(String args) async {
    var helperIsolateSendPort = await _helperIsolateSendPortFuture;
    final int requestId = _nextJSONCallRequestId++;
    final JSONCallContext request = JSONCallContext(requestId, args);

    final Completer<String> completer = Completer<String>();
    _jsonCallRequests[requestId] = completer;
    helperIsolateSendPort.send(request);

    return completer.future;
  }

}
