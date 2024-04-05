import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionProvider extends ChangeNotifier {
  String _version = '';
  String _oldVersion = '';
  String desc = '';
  String url = '';
  String _newVersion = '';
  String get version => _version;
  String get oldVersion => _oldVersion;

  bool get isLatestVersion => _newVersion == _oldVersion;

  VersionProvider() {
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // _oldVersion = prefs.getString('version') ?? packageInfo.version;
    _oldVersion = packageInfo.version;

    notifyListeners();
  }

  setVersion(String val, String description, String urlVal) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('version', val);

    _version = val;
    _newVersion = val;
    if (val.contains('v') || val.contains('V')) {
      _newVersion = val.substring(1);
    }

    desc = description;
    url = urlVal;
    notifyListeners();
  }

  /// 检查是否有权限
  // void checkPermission() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.storage);
  //   if (permission != PermissionStatus.granted) {
  //     Map<PermissionGroup, PermissionStatus> permissions =
  //         await PermissionHandler()
  //             .requestPermissions([PermissionGroup.storage]);
  //     if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
  //       return;
  //     }
  //   } else {
  //     return;
  //   }
  // }

  ///
}
