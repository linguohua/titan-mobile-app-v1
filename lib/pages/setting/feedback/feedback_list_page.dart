import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:titan_app/ext/extension_string.dart';
import 'package:titan_app/ext/widget_extension.dart';

import '../../../config/constant.dart';
import '../../../http/HttpService.dart';
import '../../../utils/shared_preferences.dart';
import 'feedback_list_detail_page.dart';

import '../../../l10n/generated/l10n.dart';
import '../../../mixin/base_view_mixin.dart';
import '../../../mixin/base_view_tool.dart';
import '../../../mixin/bsae_style_mixin.dart';
import '../../../themes/colors.dart';

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FeedbackListState();
  }
}

class _FeedbackListState extends State<FeedbackListPage>
    with BaseView, BaseStyleMixin, BaseViewTool {
  final StreamController<List<dynamic>> ctrl = StreamController();

  @override
  void initState() {
    _getBugsList();
    super.initState();
  }

  Future<void> _getBugsList() async {
    var code = TTSharedPreferences.getString(Constant.userCode) ?? "";
    var map = await HttpService().bugsList(code);
    if (map == null) {
      ctrl.sink.add([]);
      return;
    }
    List<dynamic> list = map["list"] ?? [];
    if (list.isEmpty) {
      ctrl.sink.add([]);
      return;
    }
    ctrl.sink.add(list);
  }

  @override
  void dispose() {
    ctrl.close();
    super.dispose();
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
    return Scaffold(
      appBar: appBarView(S.of(context).history),
      body: StreamBuilder<List<dynamic>>(
        stream: ctrl.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppDarkColors.themeColor,
                strokeWidth: 1,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if(snapshot.data?.length==0){
              return Center(child: Text(S.of(context).nothistory));
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var bug = snapshot.data![index];
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white10,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ListTile(
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: Row(
                    
                        children: [
                          Text(
                              '${S.of(context).updateTime}：${bug["updated_at"].toString().toDate()}',
                              style: text12StyleOpacity6),
                          const Spacer(),
                          Text(fromtStatus(bug["state"]), //state1待处理 2已处理
                              style: bug["state"] == 1
                                  ? text12StyleOpacity6.copyWith(
                                      color: AppDarkColors.themeColor)
                                  : text12StyleOpacity6),
                        ],
                      ),
                    ),
                    title: Text('${bug["description"]}', style: text14Style),
                  ),
                ).onTap(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeedbackListDetailPage(
                              bean: bug,
                            )),
                  );
                });
              },
            );
          }
        },
      ),
    );
  }
}
