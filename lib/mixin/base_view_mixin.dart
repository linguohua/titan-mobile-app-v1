import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/colors.dart';

mixin BaseView {
  InputBorder inputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.transparent));
  }

  Widget box(
    margin,
    child, {
    Color? color,
    double? radius = 10,
    double? width = double.infinity,
    double? height = double.infinity,
    Alignment? alignment = Alignment.center,
  }) =>
      Container(
        width: width,
        height: height,
        margin: margin,
        alignment: alignment,
        decoration: BoxDecoration(
          color: color, // Hex color value
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
        ),
        child: child,
      );

  AppBar appBarView(String title,
      {Color? backgroundColor = AppDarkColors.backgroundColor,
      List<Widget>? actions}) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
      iconTheme: const IconThemeData(color: AppDarkColors.iconColor),
      centerTitle: true,
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }

  Widget textField({
    TextEditingController? controller,
    String? hintText = "",
  }) =>
      TextField(
        maxLines: null,  // 设置为 null 允许无限换行
        cursorColor: Colors.green,  // 设置光标颜色
        controller: controller,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 10, left: 10.w, right: 10.w),
          focusedBorder: inputBorder(),
          disabledBorder: inputBorder(),
          errorBorder: inputBorder(),
          focusedErrorBorder: inputBorder(),
          enabledBorder: inputBorder(),
          // border: inputBorder(),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 12), // Text color
      );
}
