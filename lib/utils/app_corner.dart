class AppCorner {
  double? all;
  double? top;
  double? bottom;
  double? topLeft;
  double? topRight;
  double? bottomLeft;
  double? bottomRight;

  AppCorner(
      {this.all,
      this.top,
      this.bottom,
      this.topLeft,
      this.topRight,
      this.bottomLeft,
      this.bottomRight}) {
    if (all != null) {
      top = all;
      bottom = all;
    }
    if (top != null) {
      topRight = top;
      topLeft = top;
    }
    if (bottom != null) {
      bottomLeft = bottom;
      bottomRight = bottom;
    }
  }

  static AppCorner get none => AppCorner(all: 0);

  /// [bool] true-存在圆角， false-不存在圆角
  bool isExist() {
    return topLeft != null ||
        topRight != null ||
        bottomLeft != null ||
        bottomRight != null;
  }
}
