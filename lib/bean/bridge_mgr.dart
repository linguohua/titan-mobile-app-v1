import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../http_repository/bridge_miner.dart';
import 'bridge_daemon.dart';
import 'log.dart';

class BridgeMgr {
  // singleton pattern
  static final BridgeMgr _instance = BridgeMgr._internal();

  BridgeMgr._internal();

  static final DaemonBridge _dBridge = DaemonBridge();
  static final MinerBridge _mBridge = MinerBridge();
  static final _lManager = LogManager();
  static late String _appDocPath;
  static late String _appVersion;

  DaemonBridge get daemonBridge => _dBridge;
  MinerBridge get minerBridge => _mBridge;
  String get appDocPath => _appDocPath;

  static Future<void> init() async {
    // init app dir path
    _appDocPath = await initAppDocDir();

    await initVersionInfo();

    // init logger
    bool isSave = true;
    await _lManager.init(isSave);
    _lManager.activate();

    await _dBridge.init(() async {});

    // get data from server
    _mBridge.init(_dBridge.daemonCfgs, _appVersion);
    _mBridge.activate();

  }

  factory BridgeMgr() {
    return _instance;
  }

  static Future<void> initVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
  }

  static Future<String> initAppDocDir() async {
    // if (Platform.isWindows) {
    //   return Directory.current.path;
    // }

    // if (Platform.isWindows) {
    //   var folderPath = path.join(Directory.current.path, "titanL2");
    //   final directory = Directory(folderPath);
    //   if (!await directory.exists()) {
    //     await directory.create();
    //   }

    //   return directory.path;
    // }
    Directory appDocDir = await getApplicationSupportDirectory();

    var folderPath = path.join(appDocDir.path, "titanL2");

    //test
    // folderPath = path.join(appDocDir.path, "test-titanL2");

    final directory = Directory(folderPath);
    if (!await directory.exists()) {
      await directory.create();
    }

    return directory.path;
  }
}
