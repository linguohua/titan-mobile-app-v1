import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/generated/l10n.dart';

class ConfirmDialog {
  static void create(BuildContext context, {Function? onCall}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff181818),
          contentPadding: EdgeInsets.zero,
          content: Container(
            margin: const EdgeInsets.all(10),
            color: const Color(0xFF181818),
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: 140.w,
            child: Column(
              children: [
                SizedBox(height: 15.w),
                Text(S.of(context).noLongerPrompt,
                    style: const TextStyle(fontSize: 16)),
                SizedBox(height: 45.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onCall?.call(false);
                      },
                      child: Container(
                        width: 120.0.w,
                        height: 40.0.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45.0.sw),
                          border: Border.all(
                            color: const Color(0xFF00F352),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).cancel,
                            style: const TextStyle(color: Color(0xFF00F352)),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onCall?.call(true);
                      },
                      child: Container(
                        width: 120.0.w,
                        height: 40.0.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00F352),
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).confirm,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    ).then((value) {});
  }
}
