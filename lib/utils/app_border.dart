import 'package:flutter/cupertino.dart';

class AppBorder {
  /// 边框宽度
  final double width;

  /// 边框颜色
  final Color? color;

  /// 边框样式，默认solid
  final BorderStyle style;

  AppBorder({this.width = 0.5, this.color, this.style = BorderStyle.solid});

  /// [bool] true-存在边框， false-不存在边框
  bool isExist() {
    return width > 0 && color != null;
  }
}
