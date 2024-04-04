import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersionProvider extends ChangeNotifier {
  String _version = '';
  String oldVersion = '';
  String desc = '';
  String url = '';
  bool isLatestVersion = true;
  String get version => _version;

  VersionProvider() {
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = prefs.getString('version') ?? packageInfo.version;
    oldVersion = 'v${packageInfo.version}';
    notifyListeners();
  }

  setVersion(String val, String description, String urlVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('version', val);
    desc = description;
    url = urlVal;
    notifyListeners();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (val.contains('v') || val.contains('V')) {
      val = val.substring(1);
    }
    _isUpdateVersion(val, packageInfo.version);
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

  /// 下载安卓更新包
  Future<void> downloadAndroid(String url) async {
    //获取APK文件名
    String fileName = getFlieName(url);
    if (fileName != '') {
      Directory? storageDir = await getExternalStorageDirectory();
      String storagePath = storageDir!.path;

      String filePath = '$storagePath/$fileName';
      File file = File(filePath);
      try {
        Response response = await Dio().download(
          url,
          filePath,
          onReceiveProgress: (count, total) {
            //进度
            var d = (count / total).toStringAsFixed(2);
          },
        );
        if (response.data.statusCode == 200) {
          print('文件下载完成！:${response.data}');
        }
        print('文件path : ${file.path}');
      } catch (e) {
        print(e);
      }
    }
  }

  //用分割URL来获取下载的APK名称
  String getFlieName(String url) {
    try {
      List<String> lstStr = url.split('/');
      return lstStr.last;
    } catch (e) {
      print("获取下载文件名错误：$e");
    }
    return "";
  }

  _installApk(String path) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    InstallPlugin.installApk(path, appId: packageInfo.packageName)
        .then((result) {
      print('install apk $path success: $result');
    }).catchError((error) {
      print('install apk $path fail: $error');
    });
  }

  _isUpdateVersion(String newVersion, String old) {
    if (newVersion == null ||
        newVersion.isEmpty ||
        old == null ||
        old.isEmpty) {
      isLatestVersion = false;
    }
    int newVersionInt, oldVersion;
    var newList = newVersion.split('.');
    var oldList = old.split('.');
    if (newList.isEmpty || oldList.isEmpty) {
      isLatestVersion = false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        isLatestVersion = true;
      } else if (newVersionInt < oldVersion) {
        isLatestVersion = false;
      }
    }
    notifyListeners();
  }
}
