import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/pages/setting/setting_about_page.dart';
import 'package:titan_app/providers/localization_provider.dart';
import 'package:titan_app/providers/version_provider.dart';
import 'package:titan_app/themes/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../../widgets/common_text_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isAutoUpdate = true;
  bool isLatestVersion = true;
  late Timer timer;
  // final version = "v1.0.1";

  @override
  void initState() {
    super.initState();
    _getVersion(context);

    timer = Timer.periodic(const Duration(seconds: 60 * 5), (Timer timer) {
      _getVersion(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // var oV = Provider.of<VersionProvider>(context, listen: true).oldVersion;
    // var nV = Provider.of<VersionProvider>(context, listen: true).version;

    // isLatestVersion = oV == nV;

    isLatestVersion =
        Provider.of<VersionProvider>(context, listen: true).isLatestVersion;

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
                      .oldVersion,
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
            Provider.of<VersionProvider>(context, listen: true).version,
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
                  String url =
                      Provider.of<VersionProvider>(context, listen: false).url;
                  if (!await launchUrl(Uri.parse(url))) {
                    throw Exception('Could not launch $url');
                  }
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

    debugPrint('_getVersion, lang:$lang, platform:$platf');

    Response response = await Dio().get(
        'https://api-test1.container1.titannet.io/api/v2/app_version',
        options: Options(headers: {'Lang': lang, "platform": platf}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      if (data['code'] == 0) {
        Provider.of<VersionProvider>(context, listen: false).setVersion(
            (data['data']['version']),
            data['data']['description'],
            data['data']['url']);
      }
    }
    // debugPrint(response.data);
    // debugPrint('++++++++');
    // debugPrint(response.data['url']);

    // var data = jsonDecode(response.toString());
    // debugPrint('当前的地址是${data['data']['url']}');
    // debugPrint('=======');
  }
}
