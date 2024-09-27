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

import '../../../bridge/bridge_mgr.dart';
import '../../../bridge/log.dart';
import '../../../config/constant.dart';
import '../../../http/HttpService.dart';
import '../../../l10n/generated/l10n.dart';
import '../../../mixin/base_view_mixin.dart';
import '../../../mixin/base_view_tool.dart';
import '../../../mixin/bsae_style_mixin.dart';
import '../../../providers/localization_provider.dart';
import '../../../themes/colors.dart';

import '../../../utils/shared_preferences.dart';
import '../../../widgets/loading_indicator.dart';
import 'feedback_list_page.dart';

class ProblemFeedbackPage extends StatefulWidget {
  const ProblemFeedbackPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProblemFeedbackState();
  }
}

class _ProblemFeedbackState extends State<ProblemFeedbackPage>
    with BaseView, BaseStyleMixin, BaseViewTool {
  String address = "";
  String code = "";
  String logs = "";
  int feedbackType = 1;
  final TextEditingController _telegramController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  var feedbackTypeListCn = ['意见', '咨询', '异常', '其他'];
  ValueNotifier<List<Picture>> picListNotifier = ValueNotifier([]);

  @override
  void initState() {
    loadLogFiles();
    address = TTSharedPreferences.getString(Constant.userAddress) ?? "";
    code = TTSharedPreferences.getString(Constant.userCode) ?? "";
    picListNotifier.value.add(Picture(url: "", type: -1, progress: 0));
    LocalizationProvider local =
        Provider.of<LocalizationProvider>(context, listen: false);
    String lang = local.isEnglish() ? "en" : "cn";
    if (lang == "en") {
      feedbackTypeListCn = ['Opinion', 'Consultation', 'Exception', 'Other'];
    }
    super.initState();
  }

  @override
  void dispose() {
    _telegramController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView(S.of(context).submitBugs, actions: [
        box(
                width: 95.w,
                height: 33.h,
                EdgeInsets.only(right: 5.w),
                Text(
                  S.of(context).history,
                  style: text12StyleOpacity6.copyWith(
                      color: AppDarkColors.themeColor),
                ),
                color: const Color(0xFF171717))
            .onTap(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackListPage()),
          );
        })
      ]),
      body: Container(
        margin: EdgeInsets.all(15.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text("${S.of(context).nodeId}: ", style: text12StyleOpacity6),
                  Text(BridgeMgr().daemonBridge.daemonCfgs.id().truncate(),
                      style: text14Style)
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Text("${S.of(context).email}: ", style: text12StyleOpacity6),
                  Text(address, style: text14Style)
                ],
              ),
              SizedBox(height: 30.h),
              Text(S.of(context).setting_telegram, style: text12StyleOpacity6),
              SizedBox(height: 20.h),
              box(
                EdgeInsets.only(right: 5.w),
                height: 50.h,
                width: 340.w,
                color: const Color(0xFF181818), // Hex
                textField(
                  controller: _telegramController,
                  hintText: S.of(context).telegramDsc,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                S.of(context).yourQuestion,
                style: text12StyleOpacity6,
              ),
              SizedBox(height: 20.h),
              box(
                EdgeInsets.only(right: 5.w),
                width: 340.w,
                height: 180.h,
                alignment: Alignment.topLeft,
                color: const Color(0xFF181818),
                textField(
                  controller: _contentController,
                  hintText: S.of(context).questionDsc,
                ),
              ),
              SizedBox(height: 20.h),
              ValueListenableBuilder<List<Picture>>(
                valueListenable: picListNotifier,
                builder: (context, list, child) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      Picture bean = list[index];
                      return InkWell(
                        onTap: () {
                          _checkPermissions(index);
                        },
                        child: Stack(children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.w),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: bean.type == -1
                                ? const Icon(
                                    Icons.add,
                                    color: AppDarkColors.themeColor,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: bean.url,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Visibility(
                            visible: bean.url.isNotEmpty,
                            child: Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                child: const Icon(
                                  Icons.highlight_remove,
                                  color: AppDarkColors.themeColor,
                                ),
                                onTap: () {
                                  onRemovePicker(index);
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: bean.progress < 1.0,
                            child: Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.transparent,
                                    value: bean.progress,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppDarkColors.themeColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  _openDialog();
                },
                child: box(
                    const EdgeInsets.all(0),
                    Text(
                      S.of(context).submit,
                      style: const TextStyle(color: Colors.black),
                    ),
                    radius: 24.w,
                    width: 335.w,
                    height: 48.h,
                    color: AppDarkColors.themeColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadLogFiles() async {
    final directory = Directory(LogManager.getLogDir());
    var edgeDir = await LogManager.getLogEdgeFilePath();
    var files = await directory.list().toList();
    var logFolder = directory.path;
    files
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

    var logFiles = files.map((file) => file.path).toList();
    logFiles.add(edgeDir);

    if (logFiles.isNotEmpty) {
      String filePath = logFiles[0];
      List<LogEntry> list = await LogManager.readLogEntries(filePath);
      DateTime now = DateTime.now();
      DateTime threeDaysAgo = now.subtract(const Duration(days: 3));
      List<LogEntry> recentData = list.where((data) {
        DateTime ts = DateTime.parse(data.ts);
        return ts.isAfter(threeDaysAgo);
      }).toList();
      logs = jsonEncode(recentData);
    }
  }

  void _openDialog() {
    if (code.isEmpty) {
      showToast(S.of(context).questionDsc2);
      return;
    }
    if (_telegramController.text.trim().isEmpty) {
      showToast(S.of(context).telegramDsc);
      return;
    }
    if (_contentController.text.trim().isEmpty) {
      showToast(S.of(context).questionDsc);
      return;
    }

    if (picListNotifier.value.length < 2) {
      showToast(S.of(context).pleasePicture);
      return;
    }
    _showModalBottomSheet(context);
  }

  //feedback_type1:意见 2:咨询 3:异常 4:其他, platform 1macos 2windows 3android 4ios
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      // backgroundColor: Color(0x181818FF),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
      ),
      builder: (BuildContext context) {
        int selectIndex = 0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 260.h,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        S.of(context).feedbackDes,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 3.5,
                      ),
                      itemCount: feedbackTypeListCn.length,
                      // 项目总数
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectIndex = index;
                            });
                          },
                          child: box(
                              const EdgeInsets.all(0),
                              Text(
                                feedbackTypeListCn[index],
                                style: TextStyle(
                                    color: selectIndex == index
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              color: selectIndex == index
                                  ? const Color(0xFF52FF38)
                                  : Colors.white10,
                              radius: 40.0),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      feedbackType = selectIndex + 1;
                      Navigator.of(context).pop();
                      onSubmit();
                    },
                    child: Container(
                      width: 335,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFF52FF38), // Background color
                        borderRadius: BorderRadius.all(
                            Radius.circular(85)), // Border radius
                      ),
                      child: Text(
                        S.of(context).submit,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _checkPermissions(int position) async {
    var res = await checkAndRequestPermissions();
    if (res) {
      _pickImage(ImageSource.gallery, position);
    } else {
      LocalizationProvider local =
          Provider.of<LocalizationProvider>(context, listen: false);
      showToast(local.isEnglish() ? 'Album permissions not opened' : "相册权限未打开");
    }
  }

  Future<void> _pickImage(ImageSource source, int position) async {
    final pickedFile = await _picker.pickImage(source: source);
    var image = File(pickedFile!.path);
    var res = await HttpService().uploadImage(image, onProgress: (p) {
      print("image:onProgress..$p");
      picListNotifier.value[position].progress = p;
    });
    print("image:$res");
    if (res != null) {
      picListNotifier.value[position].url = res!["url"];
      picListNotifier.value[position].type = 0;
      picListNotifier.value = List.from(picListNotifier.value)
        ..add(Picture(url: "", type: -1, progress: 0));
    } else {
      showToast('error!');
    }
  }

  void onRemovePicker(int index) {
    if (index >= 0 && index < picListNotifier.value.length) {
      picListNotifier.value = List.from(picListNotifier.value)..removeAt(index);
    }
  }

  List<String> filterAndConvertToStrings(List<Picture> list) {
    List<Picture> filteredList =
        list.where((picture) => picture.type == 0).toList();
    List<String> stringList =
        filteredList.map((picture) => picture.url).toList();
    return stringList;
  }

  Future<void> onSubmit() async {
    if (code.isEmpty) {
      showToast(S.of(context).questionDsc2);
      return;
    }
    if (_telegramController.text.trim().isEmpty) {
      showToast(S.of(context).telegramDsc);
      return;
    }
    if (_contentController.text.trim().isEmpty) {
      showToast(S.of(context).questionDsc);
      return;
    }

    List pics = filterAndConvertToStrings(picListNotifier.value);
    if (pics.isEmpty) {
      showToast(S.of(context).pleasePicture);
      return;
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var image = jsonEncode(pics);
    final data = {
      'code': code,
      'telegram_id': _telegramController.text.trim(),
      "description": _contentController.text.trim(),
      "feedback_type": feedbackType,
      "platform": 3, //platform 1macos 2windows 3android 4ios
      "version": packageInfo.version,
      "log": logs,
      "pics": image.toString(),
    };

    LocalizationProvider local =
        Provider.of<LocalizationProvider>(context, listen: false);
    final String lang = local.isEnglish() ? "en" : "cn";
    LoadingIndicator.show(context, message: "提交中.....");

    var res = await HttpService().report(data, lang);
    Navigator.of(context).pop();
    if (res == null || res == "") {
      showToast(S.of(context).submittedOk);
      Navigator.of(context).pop(true);
    } else {
      showToast(res);
    }
  }
}

class Picture {
  String url;
  int type;
  double progress = 0.0;

  Picture({
    required this.url,
    required this.type,
    required this.progress,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      url: json['url'],
      type: json['type'],
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type,
      'progress': progress,
    };
  }
}
