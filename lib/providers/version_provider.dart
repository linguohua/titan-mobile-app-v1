import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersionProvider extends ChangeNotifier {
  String _version = '';
  String desc = '';
  String url = '';
  String get version => _version;

  VersionProvider() {
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = prefs.getString('version') ?? packageInfo.version;
    notifyListeners();
  }

  setVersion(String val, String description, String urlVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('version', val);
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
