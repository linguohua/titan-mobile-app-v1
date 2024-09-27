import 'dart:io';

import 'package:flutter/material.dart';

class SystemUtils {
  static double onePixel(BuildContext c) => 1 / View.of(c).devicePixelRatio;

  static statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static isMobileDevices() {
    return (Platform.isAndroid || Platform.isIOS);
  }

  static final isIOS = Platform.isIOS;
}
