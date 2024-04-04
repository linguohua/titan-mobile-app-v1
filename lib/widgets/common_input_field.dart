import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/colors.dart';

class CommonInputField extends StatelessWidget {
  final TextEditingController controller;
  final Color backgroundColor;
  final String hintText;
  final Color hintColor;
  final double hintFontSize;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  const CommonInputField(
      {super.key,
      required this.controller,
      this.backgroundColor = AppDarkColors.inputBackgroundColor,
      required this.hintText,
      this.hintColor = AppDarkColors.hintColor,
      this.hintFontSize = 14,
      this.obscureText = false,
      this.validator,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(72.0.w),
        border: Border.all(width: 1.0),
        color: backgroundColor,
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: AppDarkColors.titleColor),
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor, fontSize: hintFontSize),
          border: InputBorder.none,
        ),
        cursorColor: AppDarkColors.cursorColor,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
