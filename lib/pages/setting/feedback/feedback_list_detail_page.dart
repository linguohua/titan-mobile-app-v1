import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:titan_app/ext/extension_string.dart';

import '../../../l10n/generated/l10n.dart';
import '../../../mixin/base_view_mixin.dart';
import '../../../mixin/base_view_tool.dart';
import '../../../mixin/bsae_style_mixin.dart';
import '../../../themes/colors.dart';

class FeedbackListDetailPage extends StatefulWidget {
  final bean;

  const FeedbackListDetailPage({super.key, this.bean});

  @override
  State<StatefulWidget> createState() {
    return _FeedbackListDetailState();
  }
}

class _FeedbackListDetailState extends State<FeedbackListDetailPage>
    with BaseView, BaseStyleMixin, BaseViewTool {
  @override
  void initState() {
    super.initState();
  }

  String fromtStatus(int status) {
    if (status == 1) {
      return S.of(context).pending;
    } else if (status == 2) {
      return S.of(context).password;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    var bean = widget.bean;
    var pics = [];
    try {
      pics = jsonDecode(bean['pics']) ?? [];
    } catch (e) {}

    return Scaffold(
        appBar: appBarView(S.of(context).history),
        body: Container(
            margin: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    box(
                      const EdgeInsets.all(0),
                      width: 88.w,
                      height: 38.h,
                      radius: 34.w,
                      color: const Color(0xFF181818),
                      Text(fromtStatus(bean["state"]), //state1待处理 2已处理
                          style: bean["state"] == 1
                              ? text14Style.copyWith(
                                  color: AppDarkColors.themeColor)
                              : text14Style),
                    ),
                    if (bean["state"] == 2) ...[
                      const Spacer(),
                      Image.asset(
                        "assets/images/icon_jiangli.png",
                        width: 18.w,
                        height: 18.w,
                      ),
                      Text('${S.of(context).reward}：TNT2 +${bean['reward']}',
                          style: const TextStyle(
                              fontSize: 12, color: AppDarkColors.themeColor)),
                      SizedBox(height: 10.h),
                    ]
                  ],
                ),
                SizedBox(height: 15.h),
                Text(
                    '${S.of(context).updateTime}：${bean["updated_at"].toString().toDate()}',
                    style: text12StyleOpacity6),
                SizedBox(height: 10.h),
                box(
                  const EdgeInsets.all(0),
                  width: 340.w,
                  height: 150.h,
                  color: const Color(0xFF181818), // Hex
                  alignment: Alignment.center,
                  Container(
                    padding: EdgeInsets.all(10.w),
                    height: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80.w,
                              child: Text(
                                "${S.of(context).nodeId}：",
                                style: text12StyleOpacity6,
                              ),
                            ),
                            SizedBox(
                              width: 230.w,
                              child: Text(
                                "${bean['node_id']}",
                                softWrap: true,
                                style: text14Style,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SizedBox(
                              width: 80.w,
                              child: Text(
                                "${S.of(context).email}：",
                                style: text12StyleOpacity6,
                              ),
                            ),
                            Text(
                              "${bean['email']}",
                              style: text14Style,
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SizedBox(
                              width: 80.w,
                              child: Text(
                                "${S.of(context).setting_telegram}：",
                                style: text12StyleOpacity6,
                              ),
                            ),
                            SizedBox(
                              width: 230.w,
                              child: Text(
                                "${bean['telegram_id']}",
                                softWrap: true,
                                style: text14Style,
                              ),
                            )

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(S.of(context).questionDsc3, style: text12StyleOpacity6),
                SizedBox(height: 15.h),
                Container(
                  width: 340.w,
                  padding: EdgeInsets.all(10.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF181818),
                    borderRadius: BorderRadius.all(Radius.circular(8)), // 圆角边框
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${bean['description']}",
                    style: text12StyleOpacity6,
                  ),
                ),
                Expanded(
                    child: GridView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: pics.length,
                  // 项目总数
                  itemBuilder: (context, index) {
                    var url = pics[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: url,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ))
              ],
            )));
  }
}
