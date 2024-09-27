import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:titan_app/config/appConfig.dart';
import 'package:toml/toml.dart';

import '../utils/utility.dart';
import '/ffi/nativel2.dart';
import 'bridge_mgr.dart';
import 'daemon_cfgs.dart';

typedef BridgeCallback = void Function();

class DaemonBridge extends ListenAble {
  DaemonBridge();

  // final String daemonPath =await executableDir();

  static const String configFileName = "config.toml";
  static const String titanL2RepoName = ".titanedge";
  static const String daemonLogFile = "edge.log";

  late DaemonCfgs _cfgs;

  bool _isDaemonRunning = false;
  bool _isDaemonOnline = false;
  String? _ipError = "";

  String get ipErrorMsg => _ipError ?? "";

  // bool get isDaemonRunning => _isDaemonRunning;
  bool get isDaemonOnline => _isDaemonOnline;

  final logger = Logger('DaemonBridge');

  void setIpErrorMsg(String? msg) {
    _ipError = msg;
  }

  bool isEdgeExeRunning() {
    return _isDaemonRunning;
  }

  bool isEdgeOnline() {
    return _isDaemonOnline;
  }

  void updateEdgeExeState(bool running, bool online) {
    _isDaemonRunning = running;
    _isDaemonOnline = online;
    // notify("edgeState");
  }

  String titanL2ExecutablePath() {
    var fileName = 'titan-edge';
    return path.join(BridgeMgr().appDocPath, fileName);
  }

  String titanL2ConfigPath() {
    return path.join(BridgeMgr().appDocPath, configFileName);
  }

  Future<void> init(VoidCallback onComplete) async {
    await writeDaemonCfgs();
    await loadDaemonConfig();
    await _initDaemonState();
    onComplete();
  }

  Future<void> loadDaemonConfig() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");

    Map<String, dynamic> readConfigReqArgs = {
      'repoPath': repoPath,
    };

    var readConfigReqArgsJSON = json.encode(readConfigReqArgs);

    Map<String, dynamic> jsonCallArgs = {
      'method': 'readConfig',
      'JSONParams': readConfigReqArgsJSON,
    };

    var args = json.encode(jsonCallArgs);

    var result = await NativeL2().jsonCall(args);
    var kvMap1 = json.decode(result);
    var kvmap2 = json.decode(kvMap1['data']);
    // return result;
    _cfgs = DaemonCfgs(kvMap: kvmap2);
    debugPrint(result);
  }

  DaemonCfgs get daemonCfgs => _cfgs;

  Future<String> writeDaemonCfgs() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");
    var repoDirectory = Directory(repoPath);
    if (!await repoDirectory.exists()) {
      await repoDirectory.create();
    }
    Map<String, dynamic> configs = {
      'Storage': {"StorageGB": 5, "Path": repoPath},
    };
    var configFile = TomlDocument.fromMap(configs).toString();
    Map<String, dynamic> mergeConfigReqArgs = {
      'repoPath': repoPath,
      "config": configFile
    };
    var mergeConfigReqArgsJSON = json.encode(mergeConfigReqArgs);
    Map<String, dynamic> jsonCallArgs = {
      'method': 'mergeConfig',
      'JSONParams': mergeConfigReqArgsJSON,
    };

    var args = json.encode(jsonCallArgs);

    var result = await NativeL2().jsonCall(args);
    return result;
  }

  //绑定身份
  Future<String> sign(String hash) async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");

    Map<String, dynamic> signReqArgs = {'repoPath': repoPath, 'hash': hash};

    var signReqArgsJSON = json.encode(signReqArgs);

    Map<String, dynamic> jsonCallArgs = {
      'method': 'sign',
      'JSONParams': signReqArgsJSON,
    };
    var args = json.encode(jsonCallArgs);
    var result = await NativeL2().jsonCall(args);
    return result;
  }

  Future<Map<String, dynamic>> startDaemon() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");
    var repoDirectory = Directory(repoPath);
    if (!await repoDirectory.exists()) {
      await repoDirectory.create();
    }
    Map<String, dynamic> startDaemonArgs = {
      'repoPath': repoPath,
      'logPath': path.join(directory.path, "edge.log"),
      'locatorURL': AppConfig.locatorURL
    };
    String startDaemonArgsJSON = json.encode(startDaemonArgs);
    Map<String, dynamic> jsonCallArgs = {
      'method': 'startDaemon',
      'JSONParams': startDaemonArgsJSON,
    };
    var args = json.encode(jsonCallArgs);
    String jsonResult = "";
    int tryCall = 0;
    bool isOK = false;

    while (tryCall < 10) {
      jsonResult = await NativeL2().jsonCall(args);
      if (!_isJsonResultOK(jsonResult)) {
        // delay 1 seconds
        await Future.delayed(const Duration(seconds: 1));
        tryCall++;
        continue;
      }
      isOK = true;
      break;
    }

    if (!isOK) {
      return {"bool": false, "r": jsonResult};
    }
    // query y times
    tryCall = 0;
    isOK = false;
    while (tryCall < 10) {
      // delay 1 seconds
      await Future.delayed(const Duration(seconds: 1));
      jsonResult = await daemonState();

      var jsonData = jsonDecode(jsonResult);
      if (jsonData["code"] == 0) {
        final data = jsonDecode(jsonData["data"]);
        String errMsg = data["errMsg"] ?? "";
        debugPrint("errMsg=$errMsg");
        if (errMsg.isNotEmpty) {
          _ipError = errMsg;
          tryCall = 5;
          break;
        }
      }
      if (!_waitDaemonState(jsonResult, true)) {
        tryCall++;
        continue;
      }
      isOK = true;
      break;
    }

    if (isOK) {
      await NativeL2().setServiceStartupCmd(args);
    }

    return {"bool": isOK, "r": jsonResult};
  }

  Future<Map<String, dynamic>> stopDaemon() async {
    Map<String, dynamic> stopDaemonArgs = {
      'method': 'stopDaemon',
      'JSONParams': "",
    };

    var args = json.encode(stopDaemonArgs);

    String jsonResult = "";
    int tryCall = 0;
    bool isOK = false;

    while (tryCall < 5) {
      jsonResult = await NativeL2().jsonCall(args);
      if (!_isJsonResultOK(jsonResult)) {
        // delay 1 seconds
        await Future.delayed(const Duration(seconds: 1));
        tryCall++;
        continue;
      }

      isOK = true;
      break;
    }

    if (!isOK) {
      return {"bool": false, "r": jsonResult};
    }

    // query y times
    tryCall = 0;
    isOK = false;
    while (tryCall < 5) {
      // delay 1 seconds
      await Future.delayed(const Duration(seconds: 1));
      jsonResult = await daemonState();

      if (!_waitDaemonState(jsonResult, false)) {
        tryCall++;
        continue;
      }

      isOK = true;
      break;
    }

    if (isOK) {
      await NativeL2().setServiceStartupCmd("");
    }

    return {"bool": isOK, "r": jsonResult};
  }

  Future<String> daemonState() async {
    Map<String, dynamic> jsonCallArgs = {
      'method': 'state',
      'JSONParams': "",
    };

    var args = json.encode(jsonCallArgs);
    var result = await NativeL2().jsonCall(args);
    var jsonResult = jsonDecode(result);
    if (jsonResult["code"] == 0) {
      final data = jsonDecode(jsonResult["data"]);
      bool online = data["online"];
      bool running = data["running"];
      updateEdgeExeState(running, online);
    }
    return result;
  }

  bool _isJsonResultOK(String jsonString) {
    Map<String, dynamic> j = jsonDecode(jsonString);
    return j['code'] == 0;
  }

  bool _waitDaemonState(String jsonString, bool target) {
    Map<String, dynamic> j = jsonDecode(jsonString);
    if (j['code'] != 0) {
      return false;
    }

    Map<String, dynamic> d = jsonDecode(j['data']);
    return d['online'] == target;
  }

  Future<void> _initDaemonState() async {
    String result = await BridgeMgr().daemonBridge.daemonState();
    var jsonResult = jsonDecode(result);
    if (jsonResult["code"] == 0) {
      // _isDaemonRunning = true;
      final data = jsonDecode(jsonResult["data"]);
      bool online = data["online"];
      _isDaemonOnline = online;
    } else {
      _isDaemonOnline = false;
    }
  }

  Future<String> downloadFile(String cid, String version) async {
    var directory = await getApplicationDocumentsDirectory();
    var downloadDirectory = Directory('${directory.path}/downloadFile');
    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create();
    }
    String savePath = '${downloadDirectory.path}/$version' '_titan.apk';
    Map<String, dynamic> map = {
      'cid': cid,
      'download_path': savePath,
      'locator_url': AppConfig.locatorURL
    };
    Map<String, dynamic> jsonCallArgs = {
      'method': 'downloadFile',
      'JSONParams': json.encode(map),
    };
    var args = json.encode(jsonCallArgs);
    var result = await NativeL2().jsonCall(args);
    return savePath;
  }

  Future<Map<String, dynamic>> downloadProgress(String savePath) async {
    Map<String, dynamic> map = {
      'file_path': savePath,
    };
    Map<String, dynamic> jsonCallArgs = {
      'method': 'downloadProgress',
      'JSONParams': json.encode(map),
    };
    var args = json.encode(jsonCallArgs);
    var result = await NativeL2().jsonCall(args);
    return jsonDecode(result);
  }

  Future<bool> downloadCancel(String savePath) async {
    Map<String, dynamic> map = {
      'file_path': savePath,
    };
    Map<String, dynamic> jsonCallArgs = {
      'method': 'downloadCancel',
      'JSONParams': json.encode(map),
    };
    var args = json.encode(jsonCallArgs);
    var result = await NativeL2().jsonCall(args);
    return true;
  }
}
