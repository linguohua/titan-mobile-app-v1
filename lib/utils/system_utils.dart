import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class SystemUtils {
  static final double onePixel = 1 / window.devicePixelRatio;

  static statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static isMobileDevices() {
    return (Platform.isAndroid || Platform.isIOS);
  }

  static final isIOS = Platform.isIOS;
}
