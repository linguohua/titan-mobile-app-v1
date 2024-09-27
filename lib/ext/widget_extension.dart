import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_border.dart';
import '../utils/app_corner.dart';

typedef BoolCallback = void Function(bool value);

/// @Description：Widget扩展
/// @Author 黄克瑾(kegem@foxmail.com)
/// @Time 2022/10/30 18:42
extension WidgetExtension<T extends Widget> on T {
  /// @Description：设置内边距padding
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:04
  /// @Param [all]四边同值，[horizontal]水平方向边距left/right，[vertical]垂直方向边距top/bottom，
  ///   [left]设置left，[right]设置right，[top]设置top，[bottom]设置bottom
  /// @Return
  Widget padding(
      {double? all,
      double? horizontal,
      double? vertical,
      double? left,
      double? right,
      double? top,
      double? bottom}) {
    if (all != null) {
      left = all;
      right = all;
      top = all;
      bottom = all;
    } else {
      if (horizontal != null) {
        left = horizontal;
        right = horizontal;
      }
      if (vertical != null) {
        top = vertical;
        bottom = vertical;
      }
    }
    return Padding(
      padding: EdgeInsets.only(
          left: left ?? 0.0, right: right ?? 0.0, top: top ?? 0.0, bottom: bottom ?? 0.0),
      child: this,
    );
  }

  //居中
  Widget center({double? widthFactor, double? heightFactor}) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// @Description：对齐方式
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:13
  Widget align({Alignment alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  /// @Description：设置安全区域
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:38
  Widget safeArea() {
    return SafeArea(
      child: this,
    );
  }

  /// @Description：给Widget添加点击事件
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:17
  Widget onTap(
    VoidCallback? onClick, {
    Color? highlightColor,
    double? borderRadius,
  }) {
    if (onClick == null) return this;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onClick,
      highlightColor: highlightColor ?? const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: this,
    );
  }

  /// @Description：Expanded扩展系数，一般用于Row、Column内的child
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:19
  Widget expend({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget flexible({int flex = 1}) {
    return Flexible(
      flex: flex,
      child: this,
    );
  }

  Widget flex({int flex = 1}) {
    return expend(flex: flex);
  }

  /// @Description：是否隐藏
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:23
  /// @Param
  ///   [isHidden]true隐藏，false显示，
  ///   [isExist]true隐藏后还占位，false隐藏后不占位
  Widget isHidden(bool isHidden, {bool isExist = false}) {
    if (isExist) {
      return opacity(isHidden ? 0 : 1);
    }
    return isVisible(!isHidden);
  }

  /// @Description：设置控件是否可见
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:30
  /// @Param [isVisible]true-可见，false-不可见
  Widget isVisible(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: this,
    );
  }

  /// @Description：设置透明度
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:29
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  /// @Description：拦截系统事件导致的页面返回(例如iOS的侧滑返回， Android的底部物理键返回等等)
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 18:44
  /// @Param [disable]true-禁止返回，false-允许返回, [action]触发返回事件的回调
  Widget disableBackFunction({bool disable = true, BoolCallback? action}) {
    return WillPopScope(
      child: this,
      onWillPop: () async {
        if (action != null) {
          action(disable);
        }
        return await Future.value(!disable);
      },
    );
  }

  /// @Description：Container 设置 背景 圆角 边框等
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/10/30 20:15
  /// @Param [bgColor]背景颜色, [height]高，[height]宽，[constraints]约束，
  ///   [appCorner]圆角，[appBorder]边框，[margin]外边距，[alignment]对齐方式，[padding]内边距，[transform]转换
  Widget container(
      {Color? bgColor,
      double? height,
      double? width,
      BoxConstraints? constraints,
      AppCorner? appCorner,
      AppBorder? appBorder,
      EdgeInsetsGeometry? margin,
      AlignmentGeometry? alignment,
      EdgeInsetsGeometry? padding,
      Decoration? decoration,
      Matrix4? transform}) {
    Widget view = Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      child: this,
    );

    if (bgColor != null) {
      view = view.bgColor(bgColor);
    }

    if ((appCorner != null && appCorner.isExist()) || (appBorder != null && appBorder.isExist())) {
      view = view.corner(appCorner: appCorner, appBorder: appBorder);
    }
    return view;
    /*
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      alignment: alignment,
      padding: padding,
      color: bgColor,
      decoration: useDecoration
          ? BoxDecoration(
              color: bgColor,
              borderRadius: radius,
              border: border,
              shape: BoxShape.rectangle,
            )
          : null,
      clipBehavior: useDecoration ? Clip.antiAlias : Clip.none,
      child: this,
    );*/
  }

  /// @Description：设置背景颜色
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/12/17 17:38
  /// @Param [color] 颜色
  Widget bgColor(Color color) {
    return Material(
      color: color,
      child: this,
    );
  }

  /// @Description：设置圆角边框
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2022/12/17 17:39
  /// @Param [appCorner]圆角；[appBorder]边框
  Widget corner({
    AppCorner? appCorner,
    AppBorder? appBorder,
    Color? color,
  }) {
    // 圆角
    BorderRadius? radius;
    if (appCorner != null) {
      if (appCorner.isExist()) {
        radius = BorderRadius.only(
          topLeft: Radius.circular(appCorner.topLeft ?? 0.0),
          topRight: Radius.circular(appCorner.topRight ?? 0.0),
          bottomLeft: Radius.circular(appCorner.bottomLeft ?? 0.0),
          bottomRight: Radius.circular(appCorner.bottomRight ?? 0.0),
        );
      }
    }
    return Material(
      color: color ?? Colors.transparent,
      borderRadius: appBorder == null ? radius : null,
      shape: appBorder != null && appBorder.isExist()
          ? RoundedRectangleBorder(
              side: BorderSide(
                color: appBorder.color ?? Colors.transparent,
                width: appBorder.width,
                style: appBorder.style,
              ),
              borderRadius: radius ?? BorderRadius.zero)
          : null,
      clipBehavior: Clip.antiAlias,
      child: this,
    );
  }

  /// @Description：添加滚动
  /// @Author 黄克瑾(kegem@foxmail.com)
  /// @Time 2023/4/8 19:38
  /// @Param [scrollDirection]滚动方向，[padding]内间距，[controller]控制器，[keyboardDismissBehavior]键盘Dimiss方式
  /// @Return [Widget]
  Widget scrollView({
    Axis scrollDirection = Axis.vertical,
    EdgeInsetsGeometry? padding,
    ScrollController? controller,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      padding: padding,
      controller: controller,
      keyboardDismissBehavior: keyboardDismissBehavior,
      physics: const BouncingScrollPhysics(),
      child: this,
    );
  }

  /// stack布局 位置
  Widget positioned({
    Key? key,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  /// 背景模糊效果
  Widget blur({
    Key? key,
    double? sigmaX,
    double? sigmaY,
    TileMode? tileMode,
  }) {
    return ClipRect(
        child: BackdropFilter(
      key: key,
      filter: ImageFilter.blur(
        sigmaX: sigmaX ?? 5,
        sigmaY: sigmaY ?? 5,
        tileMode: tileMode ?? TileMode.clamp,
      ),
      child: this,
    ));
  }

  /// 裁剪圆角
  Widget clipRRect({
    Key? key,
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipRRect(
      key: key,
      clipper: clipper,
      clipBehavior: clipBehavior,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft ?? all ?? 0.0),
        topRight: Radius.circular(topRight ?? all ?? 0.0),
        bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
        bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
      ),
      child: this,
    );
  }

  /// material
  Widget material(
    double elevation, {
    Key? key,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Color shadowColor = const Color(0xFF000000),
  }) {
    return Material(
      key: key,
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: borderRadius,
      shadowColor: shadowColor,
      child: this,
    );
  }

  /// UnconstrainedBox 打破约束
  Widget realSizeBox({
    Key? key,
    TextDirection? textDirection,
    AlignmentGeometry? alignment,
    Axis? constrainedAxis,
    Clip? clipBehavior,
  }) {
    return UnconstrainedBox(
      key: key,
      textDirection: textDirection,
      alignment: alignment ?? Alignment.center,
      constrainedAxis: constrainedAxis,
      clipBehavior: clipBehavior ?? Clip.none,
      child: this,
    );
  }

  /// 普通Widget转sliver
  Widget sliver({
    Key? key,
  }) {
    return SliverToBoxAdapter(
      key: key,
      child: this,
    );
  }

  /// 阴影
  Widget boxShadow({
    Key? key,
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
    BlurStyle blurStyle = BlurStyle.outer,
  }) {
    BoxDecoration decoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: color,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
          offset: offset,
          blurStyle: blurStyle,
        ),
      ],
    );
    return DecoratedBox(
      key: key,
      decoration: decoration,
      child: this,
    );
  }

  /// 卡片
  Widget card({
    Key? key,
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    bool semanticContainer = true,
  }) {
    return Card(
      key: key,
      color: color,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: this,
    );
  }

  /// 状态栏 isDark 白字
  Widget statusBar({
    Key? key,
    bool isDark = true,
  }) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: this,
    );
  }

  /// 盒子装饰器
  Widget decorated({
    Key? key,
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
    DecorationPosition position = DecorationPosition.background,
  }) {
    BoxDecoration decoration = BoxDecoration(
      color: color,
      image: image,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      gradient: gradient,
      backgroundBlendMode: backgroundBlendMode,
      shape: shape,
    );
    return DecoratedBox(
      key: key,
      child: this,
      decoration: decoration,
      position: position,
    );
  }

  // 比例布局
  Widget aspectRatio({
    Key? key,
    required double aspectRatio,
  }) =>
      AspectRatio(
        key: key,
        aspectRatio: aspectRatio,
        child: this,
      );

  /// 约束
  Widget constrained({
    Key? key,
    double? width,
    double? height,
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    BoxConstraints constraints = BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
    constraints = (width != null || height != null)
        ? constraints.tighten(width: width, height: height)
        : constraints;
    return ConstrainedBox(
      key: key,
      child: this,
      constraints: constraints,
    );
  }
}
