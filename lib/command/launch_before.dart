import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:titan_app/utils/FileUtils.dart';

import '../bridge/bridge_mgr.dart';
import '../config/appConfig.dart';
import '../utils/shared_preferences.dart';

typedef ExecutePowerShellFunc = Void Function(Pointer<Utf8> command);
typedef ExecutePowerShell = void Function(Pointer<Utf8> command);

class LaunchBeforeCommand {
  ///sdk的初始化
  static Future<void> setUp() async {
    await TTSharedPreferences.setUp();
    await FileUtils.init();
    await AppConfig.load();
    await BridgeMgr.init();
  }
}
