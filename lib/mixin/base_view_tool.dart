import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

mixin BaseViewTool {
  void showToast(String msg, {bool showLong = false}) {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 12..sp,
      gravity: ToastGravity.CENTER,
      toastLength: showLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
    );
  }

  ///申请存本地相册权限
  Future<bool> checkAndRequestPermissions() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses =
            await [Permission.photos].request();
        return statuses[Permission.photos]!.isGranted;
      } else {
        //_showSettingsDialog
        return false;
      }
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        var storageStatus = await Permission.videos.status;
        if (storageStatus.isGranted) {
          return true;
        } else if (storageStatus.isPermanentlyDenied) {
          return false;
        } else if (storageStatus.isDenied) {
          return false;
        } else {
          PermissionStatus status = await Permission.videos.request();
          if (status.isGranted) {
            return true;
          } else {
            return false;
          }
        }
      } else {
        var storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          return true;
        } else if (storageStatus.isPermanentlyDenied) {
          return false;
        } else if (storageStatus.isDenied) {
          return false;
        } else {
          PermissionStatus status = await Permission.storage.request();
          if (status.isGranted) {
            return true;
          } else {
            return false;
          }
        }
      }
    }
  }
}
