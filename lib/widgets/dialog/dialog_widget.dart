import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/l10n.dart';
import '../../providers/localization_provider.dart';
import '../../utils/utility.dart';

class DialogUtils {
  static bool isShowWifiDialog = false;
  static BuildContext? WifiDialogContext;
  static BuildContext? Ip5DialogContext;

  static void closeWifiDialog() {
    if (WifiDialogContext != null &&
        WifiDialogContext!.mounted &&
        isShowWifiDialog) {
      Navigator.of(WifiDialogContext!).pop();
    }
  }

  static void closeIpDialog() {
    if (Ip5DialogContext != null &&
        Ip5DialogContext!.mounted &&
        isShowIP5Error) {
      Navigator.of(Ip5DialogContext!).pop();
    }
  }

  static void wifiDialog(BuildContext context, String describe,
      {Function? onCall, Function? onDimssCall, String? cancel}) async {
    if (isShowWifiDialog) return;
    isShowWifiDialog = true;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171717), // 设置背景颜色
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
      ),
      builder: (BuildContext ctx) {
        WifiDialogContext = ctx;
        // print(context.runtimeType.toString());
        // print(ctx.runtimeType.toString());
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          margin: EdgeInsets.all(15.w),
          child: Column(children: [
            SizedBox(height: 20.h),
            Image.asset(
              "assets/images/icon_wifi_open.png",
              width: 90.w,
              height: 90.w,
            ),
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(describe,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
                onCall?.call(true);
              },
              child: Container(
                width: 335.w,
                height: 48.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF52FF38), // Background color
                  borderRadius:
                      BorderRadius.all(Radius.circular(85)), // Border radius
                ),
                child: Text(
                  S.of(context).stillrunning,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
                onCall?.call(false);
              },
              child: Container(
                width: 335.w,
                height: 48.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white12, // Background color
                  borderRadius:
                      BorderRadius.all(Radius.circular(85)), // Border radius
                ),
                child: Text(
                  cancel ?? S.of(context).cancel,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            )
          ]),
        );
      },
    ).then((value) {
      isShowWifiDialog = false;
      WifiDialogContext = null;
      onDimssCall?.call();
    });
  }

  static void openUpdateAppDialog(BuildContext context, map,
      {Function? onFunction}) {}

  static bool isShowIP5Error = false;

  static void openIPMax5Dialog(BuildContext context, String ipMsg,
      {Function? onFunction}) {
    /// 点击启动节点 第一次通过状态差会出IP错误：
    var ipError = ipMsg;
    LocalizationProvider local =
        Provider.of<LocalizationProvider>(context, listen: false);
    if (ipError.isNotEmpty &&
        !isShowIP5Error &&
        ipError.contains("The number of IPs exceeds the limit")) {
      isShowIP5Error = true;
      Indicators.showMessage(
          context,
          !local.isEnglish() ? "启动失败,IP错误" : "Start failed,IP Error",
          !local.isEnglish()
              ? "IP数量超过限制"
              : "The number of IPs exceeds the limit",
          null, () {
        onFunction?.call();
        isShowIP5Error = false;
      }, onInit: (ctx) {
        Ip5DialogContext = ctx;
      });
    }
  }
}
