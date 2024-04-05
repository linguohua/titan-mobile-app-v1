import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:toml/toml.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '/ffi/titanedge_jcall.dart' as nativel2;

import '../http_repository/daemon_cfgs.dart';
import '../utils/utility.dart';
import 'bridge_mgr.dart';

typedef BridgeCallback = void Function();

class DaemonBridge extends ListenAble {
  DaemonBridge();

  // final String daemonPath =await executableDir();

  static const String configFileName = "config.toml";
  static const String titanL2RepoName = ".titanedge";
  static const String daemonLogFile = "edge.log";

  late DaemonCfgs _cfgs;
  bool _isEdgeExeRunning = false;
  bool _isEdgeOnline = false;
  Timer? _timer; // peridic invoke
  bool _isChecking = false;

  int _systemMemorySize = 0;
  int? _systemDiskSize = 0;
  int _systemCpuCores = 0;

  final logger = Logger('DaemonBridge');

  String titanL2ExecutablePath() {
    var fileName = 'titan-edge';
    return path.join(BridgeMgr().appDocPath, fileName);
  }

  String titanL2ConfigPath() {
    return path.join(BridgeMgr().appDocPath, configFileName);
  }

  Future<void> loadDaemonConfig() async {
    // String tomlString =
    //     await rootBundle.loadString('assets/configs/$configFileName');
    // var document = TomlDocument.parse(tomlString);
    // var defaultConfigFilePathName = path.join(daemonPath, configFileName);

    /*var document = await TomlDocument.load(titanL2ConfigPath());
    var kvmap = document.toMap();

    var homeDir = _getEdgeHomeDir();
    var targetConfigFilePath = path.join(homeDir, configFileName);
    File file = File(targetConfigFilePath);
    if (file.existsSync()) {
      document = await TomlDocument.load(targetConfigFilePath);
      kvmap = DaemonCfgs.mergeToml(kvmap, document.toMap());
    }

    _cfgs = DaemonCfgs(kvMap: kvmap);*/

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
    var kvMap1 = json.decode(result);
    var kvmap2 = json.decode(kvMap1['data']);
    // return result;
    _cfgs = DaemonCfgs(kvMap: kvmap2);
    debugPrint(result);
  }

  Future<void> init(VoidCallback onComplete) async {
    if (_timer != null) {
      throw Exception("daemon bridge already been activated");
    }

    await stopDaemon();

    await copyAssetToFileSystem(
        'assets/configs/config.toml', titanL2ConfigPath(), true);
    // await copyAssetToFileSystem(
    //     'assets/data/titan-edge', titanL2ExecutablePath(), true);

    await loadDaemonConfig();

    // await downloadEdge();

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!_isChecking) {
        _checkEdgeExeState();
      }
    });

    _checkEdgeExeState();

    _systemDiskSize = _cfgs.maxStorage();
    _systemMemorySize = _cfgs.maxMem();
    _systemCpuCores = _cfgs.maxCpuCores();

    // print('_cfgs.id() ${_cfgs.id()}');
    // if (_cfgs.id() == "") {
    //   _initDaemon(onComplete);
    // } else {
    // }
    onComplete();
  }

  // void _initDaemon(VoidCallback onComplete) {
  //   print('_initDaemon ');
  //   writeDaemonCfgs().whenComplete(() {}).then((value) async {
  //     Map<String, dynamic> json = jsonDecode(value);

  //     print('_initDaemon json $json');
  //     if (json['code'] != 0) {
  //       logger.warning("init daemon failed");
  //     } else {
  //       await loadDaemonConfig();
  //       onComplete();
  //     }
  //   }, onError: (e) {
  //     logger.warning(e);
  //   });
  // }

  void _checkEdgeExeState() {
    _isChecking = true;
    try {
      // check
      daemonState()
          .whenComplete(() => _isChecking = false)
          .then((value) {}, onError: (e) {});
    } finally {
      _isChecking = false;
    }
  }

  String _getEdgeHomeDir() {
    return path.join(BridgeMgr().appDocPath, titanL2RepoName);
  }

  Map<String, String> _edgeHomeEnv() {
    var homeDir = _getEdgeHomeDir();
    var env = {"EDGE_PATH": homeDir};
    return env;
  }

  DaemonCfgs get daemonCfgs => _cfgs;

  Future<String> stopDaemon() async {
    // return stopped;
    Map<String, dynamic> stopDaemonArgs = {
      'method': 'stopDaemon',
      'JSONParams': "",
    };

    var args = json.encode(stopDaemonArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  Future<String> startDaemon() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");
    var repoDirectory = Directory(repoPath);
    if (!await repoDirectory.exists()) {
      await repoDirectory.create();
    }

    debugPrint("path $repoDirectory");

    Map<String, dynamic> startDaemonArgs = {
      'repoPath': repoPath,
      'logPath': path.join(directory.path, "edge.log"),
      'locatorURL': "https://test-locator.titannet.io:5000/rpc/v0"
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

  // Future<int> restartDaemon() async {
  // var existCode = await stopDaemon();
  // if (existCode != 0) {
  //   return existCode;
  // }
  //
  // var process = await startDaemon();
  // if (process.pid != 0) {
  //   // failed
  //   return 1;
  // }
  //
  // return 0;

  // }

  Future<String> writeDaemonCfgs() async {
    // debugPrint('configsJSON: $configFile');
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");
    var repoDirectory = Directory(repoPath);
    if (!await repoDirectory.exists()) {
      await repoDirectory.create();
    }

    Map<String, dynamic> configs = {
      'Storage': {"StorageGB": 32, "Path": repoPath},
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

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  Future<int> daemonState() async {
    var process = await Process.start(titanL2ExecutablePath(), ['state'],
        environment: _edgeHomeEnv(), mode: ProcessStartMode.normal);

    process.stderr.transform(utf8.decoder).listen((String data) {
      logger.info('daemonState error: $data');
    });

    var exitCode = await process.exitCode;
    if (exitCode == 0) {
      process.stdout.transform(utf8.decoder).listen((String data) {
        Map<String, dynamic> parsedJson = json.decode(data);
        var running = parsedJson['running'];
        var online = parsedJson['online'];
        updateEdgeExeState(running, online);
      });
    } else {
      updateEdgeExeState(false, false);
    }

    return await process.exitCode;
  }

  //not use
  bool isEdgeExeRunning() {
    return _isEdgeExeRunning;
  }

  bool isEdgeOnline() {
    return _isEdgeOnline;
  }

  void updateEdgeExeState(bool running, bool online) {
    _isEdgeExeRunning = running;
    _isEdgeOnline = online;
    // notify("edgeState");
  }

  Future<String> daemonVersion() async {
    final process = await Process.start(titanL2ExecutablePath(), ['-v'],
        environment: _edgeHomeEnv(), mode: ProcessStartMode.normal);

    process.stderr.transform(utf8.decoder).listen((String data) {
      logger.info('stderr: $data');
    });

    var exitCode = await process.exitCode;
    if (exitCode == 0) {
      var stdout = process.stdout.toString();
      List<String> parts = stdout.split(' ');
      if (parts.isNotEmpty) {
        return parts[parts.length - 1];
      }
    }

    return "unknow";
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

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  int systemMemorySize() {
    return _systemMemorySize;
  }

  int systemCpuCores() {
    return _systemCpuCores;
  }

  int systemDiskSize() {
    return _systemDiskSize ?? 0;
  }

  Future<void> getSystemMemorySize() async {
    String command;
    List<String> arguments;

    if (Platform.isWindows) {
      command = 'wmic';
      arguments = ['ComputerSystem', 'get', 'TotalPhysicalMemory'];
    } else {
      command = 'grep';
      arguments = ['MemTotal', '/proc/meminfo'];
    }

    var result = await Process.run(command, arguments);
    if (result.exitCode == 0) {
      var output = result.stdout.toString().trim();
      if (Platform.isWindows) {
        output = output.split('\n').skip(1).first.trim();
        _systemMemorySize = (int.tryParse(output) ?? 0) ~/ (1024 * 1024 * 1024);
      } else {
        var match = RegExp(r'\d+').firstMatch(output);
        _systemMemorySize = (int.tryParse(match?.group(0) ?? '0') ?? 0) ~/ 1024;
      }
    }

    logger.info('MemorySize $_systemMemorySize');
  }

  Future<void> getDiskAvailableSpace() async {
    String command;
    List<String> arguments;

    if (Platform.isWindows) {
      command = 'wmic';
      arguments = ['LogicalDisk', 'Where', 'DriveType="3"', 'Get', 'FreeSpace'];
    } else {
      command = 'df';
      arguments = ['-k', '--total'];
    }

    var result = await Process.run(command, arguments);
    if (result.exitCode == 0) {
      var output = result.stdout.toString().trim();
      if (Platform.isWindows) {
        output = output.split('\n').skip(1).first.trim();
        _systemDiskSize = (int.tryParse(output) ?? 0) ~/ (1024 * 1024 * 1024);
      } else {
        var lines = output.split('\n');
        var totalLine = lines.firstWhere(
          (line) => line.startsWith('total'),
          orElse: () => '',
        );
        if (totalLine.isNotEmpty) {
          var available = totalLine.split(RegExp(r'\s+'))[3];
          _systemDiskSize = (int.tryParse(available) ?? 0) ~/ (1024 * 1024);
        }
      }
    }

    logger.info('DiskSize $_systemDiskSize');
  }

  Future<void> getSystemCpuCores() async {
    String command;
    List<String> arguments;

    if (Platform.isWindows) {
      command = 'WMIC';
      arguments = ['CPU', 'Get', 'NumberOfCores'];
    } else {
      command = 'nproc';
      arguments = [];
    }

    var result = await Process.run(command, arguments);
    if (result.exitCode == 0) {
      var output = result.stdout.toString().trim();
      if (Platform.isWindows) {
        output = output.split('\n').skip(1).first.trim();
      }
      _systemCpuCores = int.tryParse(output) ?? daemonCfgs.maxCpuCores();
    }

    logger.info('CPU $_systemCpuCores');
  }

  Future<void> getSystemDiskSize() async {
    _systemDiskSize = daemonCfgs.maxStorage();

    String command;
    List<String> arguments;

    if (Platform.isWindows) {
      command = 'wmic';
      arguments = ['LogicalDisk', 'Where', 'DriveType="3"', 'Get', 'Size'];
    } else {
      command = 'df';
      arguments = ['-k', '--total'];
    }

    var result = await Process.run(command, arguments);
    if (result.exitCode == 0) {
      var output = result.stdout.toString().trim();
      if (Platform.isWindows) {
        output = output.split('\n').skip(1).first.trim();
        _systemDiskSize = (int.tryParse(output) ?? 0) ~/ (1024 * 1024 * 1024);
      } else {
        var lines = output.split('\n');
        var totalLine = lines.firstWhere(
          (line) => line.startsWith('total'),
          orElse: () => '',
        );
        if (totalLine.isNotEmpty) {
          var size = totalLine.split(RegExp(r'\s+'))[1];
          _systemDiskSize = (int.tryParse(size) ?? 0) ~/ (1024 * 1024);
        }
      }
    }

    logger.info('DiskSize $_systemDiskSize');
  }

  Future<void> copyAssetToFileSystem(
      String assetPath, String targetPath, bool forceUpdate) async {
    File file = File(targetPath);
    if (!forceUpdate) {
      if (await file.exists()) {
        return;
      }
    }

    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await file.writeAsBytes(bytes);

    if (Platform.isMacOS || Platform.isLinux) {
      ProcessResult result = await Process.run('chmod', ['755', targetPath]);
      if (result.exitCode != 0) {
        logger.info('Failed to change file permissions: ${result.stderr}');
      } else {
        logger.info('File permissions changed successfully.');
      }
    }
  }

  Future<void> downloadEdge() async {
    String url;

    if (Platform.isWindows) {
      url =
          'https://gitee.com/linmufan/titan-l2/releases/download/v1.0.0/titan-edge.exe';
    } else if (Platform.isMacOS) {
      url =
          'https://gitee.com/linmufan/titan-l2/releases/download/v1.0.0/titan-edge';
    } else {
      logger.severe(
          'downloadFile unsupported platform: ${Platform.operatingSystem}');
      throw Exception('Unsupported platform');
    }
    File file = File(titanL2ExecutablePath());

    logger.info('file ${file.path}');
    if (await file.exists()) {
      return;
    }

    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);

        return;
      } else {
        logger.severe(
            'downloadFile Failed to download file: ${response.statusCode}');
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      logger.warning('get data err $e');
    } finally {
      client.close();
    }
  }
}
