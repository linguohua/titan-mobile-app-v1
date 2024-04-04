import 'package:flutter/material.dart';
import 'package:titan_app/themes/colors.dart';
import 'package:titan_app/themes/text_theme.dart';

ThemeData darkTheme = ThemeData(
  textTheme: dartTextTheme,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    color: AppDarkColors.titleColor,
    iconTheme: IconThemeData(color: AppDarkColors.iconColor),
  ),
  colorScheme: const ColorScheme(
    primary: AppDarkColors.backgroundColor, // 主色的变体
    secondary: AppDarkColors.grayColor, // 辅助色的变体
    surface: AppDarkColors.backgroundColor, // 表面色
    background: AppDarkColors.backgroundColor, // 背景色
    error: Colors.red, // 错误色
    onPrimary: AppDarkColors.titleColor, // 在主色上的文本颜色
    onSecondary: Colors.white, // 在辅助色上的文本颜色
    onSurface: AppDarkColors.backgroundColor, // 在表面色上的文本颜色
    onBackground: AppDarkColors.titleColor, // 在背景色上的文本颜色
    onError: Colors.white, // 在错误色上的文本颜色
    brightness: Brightness.light, // 亮度模式
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
  ),
);
