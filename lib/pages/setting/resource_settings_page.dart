import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/ext/extension_num.dart';
import 'package:titan_app/ext/widget_extension.dart';
import 'package:titan_app/mixin/bsae_style_mixin.dart';

import '../../bridge/bridge_mgr.dart';
import '../../bridge/log.dart';
import '../../config/constant.dart';
import '../../http/HttpService.dart';
import '../../l10n/generated/l10n.dart';
import '../../mixin/base_view_mixin.dart';
import '../../mixin/base_view_tool.dart';
import '../../providers/localization_provider.dart';
import '../../themes/colors.dart';
import '../../utils/shared_preferences.dart';

class ResourceSettingsPage extends StatefulWidget {
  const ResourceSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ResourceSettingsState();
  }
}

class _ResourceSettingsState extends State<ResourceSettingsPage>
    with BaseView, BaseStyleMixin, BaseViewTool {
  int _groupValue = 0;

  @override
  void initState() {
    _groupValue = TTSharedPreferences.getInt(Constant.has4gRun) ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView(S.of(context).zyanSSet),
      body: Container(
        margin: EdgeInsets.all(15.w),
        child: SingleChildScrollView(
          child: Theme(
            data: Theme.of(context).copyWith(
              radioTheme: RadioThemeData(
                fillColor: MaterialStateProperty.all(Colors.white10),
                overlayColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(S.of(context).usingMobileData, style: text14Style),
                SizedBox(height: 30.h),
                box(
                    const EdgeInsets.all(0),
                    width: 340.w,
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    color: const Color(0xFF181818),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value!;
                            });
                          },
                          activeColor: AppDarkColors.themeColor,
                          focusColor: Colors.red,
                          // 设置焦点时的颜色
                          hoverColor: Colors.green, // 设置悬停时的颜色
                        ),
                        Text(S.of(context).allowrun, style: text14Style)
                      ],
                    )).onTap(() {
                  setState(() {
                    _groupValue = 1;
                  });
                }),
                SizedBox(height: 20.h),
                box(
                    const EdgeInsets.all(0),
                    width: 340.w,
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    color: const Color(0xFF181818),
                    Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value!;
                            });
                          },
                          activeColor: AppDarkColors.themeColor,
                          focusColor: Colors.red,
                          // 设置焦点时的颜色
                          hoverColor: Colors.green, // 设置悬停时的颜色
                        ),
                        Text(S.of(context).prohibit, style: text14Style)
                      ],
                    )).onTap(() {
                  setState(() {
                    _groupValue = 2;
                  });
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: box(
              EdgeInsets.all(15.w),
              Text(
                S.of(context).submit,
                style: const TextStyle(color: Colors.black),
              ),
              radius: 24.w,
              width: 335.w,
              height: 48.h,
              color: AppDarkColors.themeColor)
          .onTap(
        () {
          TTSharedPreferences.setInt(Constant.has4gRun, _groupValue);
          showToast(S.of(context).zyanSSetok);
          Navigator.pop(context);
        },
      ),
    );
  }
}
