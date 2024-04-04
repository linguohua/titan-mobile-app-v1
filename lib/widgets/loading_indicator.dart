import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/colors.dart';

class LoadingIndicator {
  static void show(BuildContext context,
      {String message = '加载中',
      Color backgroundColor = Colors.grey,
      Color valueColor = AppDarkColors.themeColor}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Center(
            heightFactor: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xff181818),
                borderRadius: BorderRadius.circular(85.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: backgroundColor,
                      valueColor: AlwaysStoppedAnimation<Color>(valueColor),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    message,
                    style: TextStyle(
                        fontSize: 14.sp, color: AppDarkColors.titleColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
