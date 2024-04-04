import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/colors.dart';

enum FontSize {
  /// Extra small font size, suitable for tiny labels or captions.
  extraSmall,

  /// Small font size, suitable for small headers or secondary text.
  small,

  /// Medium font size, suitable for body text as default.
  medium,

  /// Large font size, suitable for prominent headers or important text.
  large,

  /// Extra large font size, suitable for very prominent headers or very large text.
  extraLarge,

  biggest,
}

class CommonTextWidget extends StatelessWidget {
  final String text;
  final FontSize fontSize;
  final Color color;
  final int? maxLines;
  final TextOverflow overflow;

  const CommonTextWidget(
    this.text, {
    super.key,
    this.fontSize = FontSize.medium,
    this.color = AppDarkColors.titleColor,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  double _getFontSize() {
    switch (fontSize) {
      case FontSize.extraSmall:
        return 12.0.sp;
      case FontSize.small:
        return 14.0.sp;
      case FontSize.medium:
        return 16.0.sp;
      case FontSize.large:
        return 18.0.sp;
      case FontSize.extraLarge:
        return 20.0.sp;
      case FontSize.biggest:
        return 24.0.sp;
      default:
        return 16.0.sp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines ?? 1,
      style:
          TextStyle(fontSize: _getFontSize(), color: color, overflow: overflow),
    );
  }
}
