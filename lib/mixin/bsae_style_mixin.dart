import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/colors.dart';

mixin BaseStyleMixin {

  var text12StyleOpacity6 = TextStyle(
      fontSize: 12..sp,
      color: AppDarkColors.tabBarNormalColor.withOpacity(0.6));

  var text14Style =
      TextStyle(fontSize: 14..sp, color: AppDarkColors.tabBarNormalColor);

}
