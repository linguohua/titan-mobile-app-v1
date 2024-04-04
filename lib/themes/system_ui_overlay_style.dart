import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:titan_app/themes/colors.dart';

SystemUiOverlayStyle systemUiOverlayDarkStyle = const SystemUiOverlayStyle(
  // statusBarColor: AppDarkColors.backgroundColor,
  systemNavigationBarColor: AppDarkColors.backgroundColor,
  statusBarIconBrightness: Brightness.light,
  statusBarColor: Colors.transparent, // 透明状态栏
);

SystemUiOverlayStyle systemUiOverlayLightStyle = const SystemUiOverlayStyle(
  statusBarColor: AppDarkColors.backgroundColor,
  systemNavigationBarColor: AppDarkColors.backgroundColor,
  statusBarIconBrightness: Brightness.light,
);
