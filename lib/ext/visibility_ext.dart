import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

///处理三方库计算溢出的bug
extension VisibilityExt on VisibilityInfo {
  bool isVisible() {
    if (appVisibleFraction > 0) {
      return true;
    }
    return false;
  }

  // 范围 [0, 1]，表示小部件可见的比例（假设矩形边界框）。
  // 0表示不可见； 1 表示完全可见。
  double get appVisibleFraction {
    final visibleArea = _area(visibleBounds.size);
    final maxVisibleArea = _area(size);

    if (_floatNear(maxVisibleArea, 0)) {
      return 0;
    }

    var visibleFraction = visibleArea / maxVisibleArea;

    if (_floatNear(visibleFraction, 0)) {
      visibleFraction = 0;
    } else if (_floatNear(visibleFraction, 1)) {
      visibleFraction = 1;
    }

    return visibleFraction.clamp(0, 1);
  }

  double _area(Size size) {
    double width = size.width < 0 ? 0 : size.width;
    double height = size.height < 0 ? 0 : size.height;
    return width * height;
  }

  bool _floatNear(double f1, double f2) {
    const kDefaultTolerance = 0.01;
    final absDiff = (f1 - f2).abs();
    return absDiff <= kDefaultTolerance ||
        (absDiff / max(f1.abs(), f2.abs()) <= kDefaultTolerance);
  }
}
