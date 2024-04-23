import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/pages/setting/setting_about_page.dart';
import 'package:titan_app/providers/localization_provider.dart';
import 'package:titan_app/providers/version_provider.dart';
import 'package:titan_app/themes/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bridge/bridge_mgr.dart';
import '../../l10n/generated/l10n.dart';
import '../../utils/system_utils.dart';
import '../../widgets/common_text_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // bool isAutoUpdate = true;
  bool isLatestVersion = true;
  late Timer timer;

  double progress = 0.0;
  Timer? downTimer;
  late BuildContext mContext;

  String downPath = "";

  @override
  void initState() {
    super.initState();
    _getVersion(context);
    timer = Timer.periodic(const Duration(seconds: 60 * 5), (Timer timer) {
      _getVersion(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onCancelDown();
  }

  @override
  Widget build(BuildContext context) {
    isLatestVersion =
        !(Provider.of<VersionProvider>(context, listen: true).isUpgradeAble);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppDarkColors.backgroundColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: ListView(
          children: <Widget>[
            _listTitleItem(
                context,
                S.of(context).setting_change_language,
                Image.asset(
                  "assets/images/setting_languages.png",
                  width: 18,
                  height: 18,
                ),
                _toggleSwitch(context),
                null),
            SizedBox(
              height: 10.h,
            ),
            _listTitleItem(
                context,
                S.of(context).setting_about_titan,
                Image.asset(
                  "assets/images/setting_about_titan.png",
                  width: 18,
                  height: 18,
                ),
                _nextIcon(context), () {
              toSpecifiedPage(context, const SettingAboutPage());
            }),
            SizedBox(
              height: 10.h,
            ),
            _listTitleItem(
                context,
                S.of(context).setting_version,
                Image.asset(
                  "assets/images/setting_version.png",
                  width: 18,
                  height: 18,
                ),
                Text(
                  Provider.of<VersionProvider>(context, listen: true)
                      .localVersion,
                  style: const TextStyle(color: AppDarkColors.grayColor),
                ),
                null),
            SizedBox(
              height: 10.h,
            ),
            /*_listTitleItem(
                context,
                S.of(context).setting_automatic_updates,
                Image.asset(
                  "assets/images/setting_update.png",
                  width: 18,
                  height: 18,
                ),
                Switch(
                    value: isAutoUpdate,
                    activeColor: AppDarkColors.themeColor,
                    activeTrackColor: AppDarkColors.themeColor,
                    inactiveTrackColor: AppDarkColors.grayColor,
                    thumbColor: MaterialStateProperty.all<Color>(
                        AppDarkColors.backgroundColor),
                    onChanged: (_) {
                      setState(() {
                        isAutoUpdate = !isAutoUpdate;
                      });
                    }),
                null),
            SizedBox(
              height: 10.h,
            ),*/
            _versionInfo(context),
          ],
        ),
      ),
    );
  }

  toSpecifiedPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _listTitleItem(BuildContext context, String title, Image image,
      Widget widget, GestureTapCallback? onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
        leading: image,
        title: CommonTextWidget(
          title,
          fontSize: FontSize.medium,
        ),
        trailing: widget,
      ),
    );
  }

  Widget _toggleSwitch(BuildContext context) {
    return Consumer<LocalizationProvider>(builder: (context, localization, _) {
      return ToggleSwitch(
        minWidth: 56,
        minHeight: 30,
        cornerRadius: 32.0,
        activeBgColors: const [
          [AppDarkColors.themeColor],
          [AppDarkColors.themeColor]
        ],
        activeFgColor: AppDarkColors.backgroundColor,
        inactiveBgColor: AppDarkColors.inputBackgroundColor,
        inactiveFgColor: AppDarkColors.grayColor,
        initialLabelIndex: localization.isEnglish() ? 1 : 0,
        totalSwitches: 2,
        labels: [
          S.of(context).setting_language_zh,
          S.of(context).setting_language_en
        ],
        radiusStyle: true,
        onToggle: (index) {
          debugPrint('switched to: $index');
          LocalizationProvider local =
              Provider.of<LocalizationProvider>(context, listen: false);
          if (index == 0) {
            local.toggleChangeLocale(LocalizationProvider.kLocalZh);
          } else {
            local.toggleChangeLocale(LocalizationProvider.kLocalEn);
          }

          _getVersion(context);
        },
      );
    });
  }

  Widget _nextIcon(BuildContext context) =>
      const Icon(Icons.chevron_right, color: Color(0xFF767680));

  Widget _versionInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Provider.of<VersionProvider>(context, listen: true).remoteVersion,
            style:
                const TextStyle(color: AppDarkColors.titleColor, fontSize: 16),
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            Provider.of<VersionProvider>(context, listen: true).desc,
            // S.of(context).setting_update_info_1(
            //     Provider.of<VersionProvider>(context, listen: true).version),
            style:
                const TextStyle(color: AppDarkColors.grayColor, fontSize: 12),
          ),
          SizedBox(
            height: 46.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLatestVersion
                      ? const Color(0xFF2E2E2E)
                      : AppDarkColors.themeColor,
                  minimumSize: const Size(315, 48),
                ),
                onPressed: () async {
                  if (isLatestVersion) {
                    return;
                  }
                  _showLoadingDialog();
                },
                child: Text(
                  isLatestVersion
                      ? S.of(context).setting_up_to_date
                      : S.of(context).setting_update_now,
                  style: const TextStyle(
                      color: AppDarkColors.backgroundColor, fontSize: 18),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _getVersion(context) async {
    LocalizationProvider local =
        Provider.of<LocalizationProvider>(context, listen: false);
    final String lang = local.isEnglish() ? "en" : "cn";
    final String platf = Platform.operatingSystem.toLowerCase();
    // debugPrint('_getVersion, lang:$lang, platform:$platf');
    Response response = await Dio().get(
        'https://api-test1.container1.titannet.io/api/v2/app_version',
        options: Options(headers: {'Lang': lang, "platform": platf}));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      if (data['code'] == 0) {
        Provider.of<VersionProvider>(context, listen: false).setVersion(
          (data['data']['version']),
          data['data']['description'],
          data['data']['url'],
          // "bafybeie6ukms7oegxf2rynosikzugeodoccwyauhwy3pd7guzal5iqngfu"
          data['data']['cid'] ?? "",
        );
      }
    }
    debugPrint(response.data.toString());
  }

  Future<void> _showLoadingDialog() async {
    if (SystemUtils.isIOS) {
      /// todo
      return;
    }
    String cid = Provider.of<VersionProvider>(context, listen: false).cid;
    if (cid.isEmpty) {
      await _onOpenLaunch();
      return;
    }
    bool hasFileExists = await _checkFileExists();
    if (hasFileExists) {
      return;
    }
    await _onDownloadFile(cid);
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        mContext = ctx;
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.dm),
              height: 150.dm,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.all(Radius.circular(10.dm)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _onCancelDown();
                        },
                        icon: const Icon(
                          Icons.cancel_rounded,
                          color: Colors.red,
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 20.dm),
                      child: Text(
                        S.of(context).download_progress,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                    Container(
                      height: 10.dm,
                      margin: EdgeInsets.symmetric(
                          horizontal: 50.dm, vertical: 10.dm),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.dm)),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.dm)),
                          child: LinearProgressIndicator(
                              backgroundColor: AppDarkColors.hintColor,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppDarkColors.themeColor),
                              value: Provider.of<VersionProvider>(ctx,
                                      listen: true)
                                  .downProgress)),
                    ),
                    Center(
                      child: Text(
                        "${S.of(context).download_installation_package} ${(progress * 100).floor()}%",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      _onCancelDown();
    });
  }

  Future<void> _onOpenLaunch() async {
    String url = Provider.of<VersionProvider>(context, listen: false).url;
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _onCancelDown() async {
    progress = 0.0;
    Provider.of<VersionProvider>(context, listen: false)
        .setDownProgress(progress);
    downTimer?.cancel();
    await BridgeMgr().daemonBridge.downloadCancel(downPath);
  }

  Future<String> _onDownloadFile(cid) async {
    var version =
        Provider.of<VersionProvider>(context, listen: false).remoteVersion;
    String path = await BridgeMgr().daemonBridge.downloadFile(cid, version);
    downPath = path;
    _downloadProgress();
    return path;
  }

  Future<bool> _checkFileExists({bool installByPath = true}) async {
    var directory = await getApplicationDocumentsDirectory();
    var downloadDirectory = Directory('${directory.path}/downloadFile');
    var version =
        Provider.of<VersionProvider>(context, listen: false).remoteVersion;
    String filePath = '${downloadDirectory.path}/$version' '_titan.apk';
    File file = File(filePath);
    bool hasFileExists = await file.exists();
    if (hasFileExists) {
      if (installByPath) {
        await InstallPlugin.installApk(filePath);
      }
    }
    return hasFileExists;
  }

  Future<void> _downloadProgress() async {
    num maxFailedCount = 0;
    downTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      var map = await BridgeMgr().daemonBridge.downloadProgress(downPath);
      String dataString = map['data'];
      Map<String, dynamic> dataMap = jsonDecode(dataString);
      var totalSize = dataMap["total_size"];
      var doneSize = dataMap["done_size"];
      var status = dataMap["status"];
      maxFailedCount++;
      if (status == "failed" && maxFailedCount == 10) {
        Navigator.of(mContext).pop();
        downTimer?.cancel();
        await _onOpenLaunch();
        return;
      }
      try {
        progress = doneSize / (totalSize == 0 ? 1.0 : totalSize);
        if (progress < 1) {
          if (progress > 0) {
            Provider.of<VersionProvider>(context, listen: false)
                .setDownProgress(progress);
          }
        } else {
          Navigator.of(mContext).pop();
          downTimer?.cancel();
          await InstallPlugin.installApk(downPath);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }
}
