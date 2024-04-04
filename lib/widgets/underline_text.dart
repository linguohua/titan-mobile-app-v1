import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:titan_app/themes/colors.dart';

class UnderlinedText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color color;
  final double? fontSize;

  const UnderlinedText({
    super.key,
    required this.text,
    this.onTap,
    this.color = AppDarkColors.titleColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: fontSize ?? 12.sp,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
