
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:toml/toml.dart';
import '/ffi/titanedge_jcall.dart' as nativel2;

///调动态库的函数集合
class BridgeDaemon {
  late Timer timer;
  bool isDaemonRunning = false;
  int daemonCounter = 0;
  bool isQuerying = false;

  //启动服务
  Future<String> startDaemon() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");
    var repoDirectory = Directory(repoPath);
    if (!await repoDirectory.exists()) {
      await repoDirectory.create();
    }

    print("path ${repoDirectory}");

    Map<String, dynamic> startDaemonArgs = {
      'repoPath': repoPath,
      'logPath': path.join(directory.path, "edge.log"),
      'locatorURL':"https://test-locator.titannet.io:5000/rpc/v0"
    };

    String startDaemonArgsJSON = json.encode(startDaemonArgs);

    Map<String, dynamic> jsonCallArgs = {
      'method': 'startDaemon',
      'JSONParams': startDaemonArgsJSON,
    };

    var args = json.encode(jsonCallArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  //停止服务
  Future<String> stopDaemon() async{
    Map<String, dynamic> stopDaemonArgs = {
      'method': 'stopDaemon',
      'JSONParams': "",
    };

    var args = json.encode(stopDaemonArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  //服务状态
  Future<String> daemonState() async {
    Map<String, dynamic> jsonCallArgs = {
      'method': 'state',
      'JSONParams': "",
    };

    var args = json.encode(jsonCallArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  //用户绑定
  Future<String> daemonSign() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");

    Map<String, dynamic> signReqArgs = {
      'repoPath': repoPath,
      'hash':"abc"
    };

    var signReqArgsJSON = json.encode(signReqArgs);

    Map<String, dynamic> jsonCallArgs = {
      'method': 'sign',
      'JSONParams': signReqArgsJSON,
    };

    var args = json.encode(jsonCallArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  //读取设置参数
  Future<String> readConfig() async {
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

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  //重写设置参数
  Future<String> mergeConfig() async {

    Map<String, dynamic> configs = {
      'Storage': {"StorageGB": 32, "Path":"D:/filecoin-titan/test2"},
    };

    var configFile = TomlDocument.fromMap(configs).toString();

    // debugPrint('configsJSON: $configFile');
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");

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

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  //轮询状态
  loopState() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      queryDaemonState();
    });
  }

  void queryDaemonState() async {
    if (isQuerying) {
      return;
    }

    if (!isDaemonRunning) {
      return;
    }

    isQuerying = true;
    String result;

    result = await daemonState();

    debugPrint('state call: $result');
    final Map<String, dynamic> jsonResult = jsonDecode(result);

    if (jsonResult["Code"] == 0) {
      if (jsonResult["Counter"] != daemonCounter) {
        daemonCounter = jsonResult["Counter"];
        debugPrint('daemonCounter:$daemonCounter');
      }
    }

    isQuerying = false;
  }

  //释放
  release() {
    timer.cancel();
  }


}

class Demo {
  //_getEdgeHomeDir

  //restartDaemon

  //updateEdgeExeState

  //daemonVersion

  //systemMemorySize

  //systemCpuCores

  //systemDiskSize

  //getDiskAvailableSpace
}