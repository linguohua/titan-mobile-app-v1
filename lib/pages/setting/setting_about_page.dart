import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/config/appConfig.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../http/HttpService.dart';
import '../../l10n/generated/l10n.dart';
import '../../providers/localization_provider.dart';
import '../../themes/colors.dart';
import '../../widgets/common_text_widget.dart';

class SettingAboutPage extends StatefulWidget {
  const SettingAboutPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingAboutState();
  }
}

class _SettingAboutState extends State<SettingAboutPage> {
  @override
  void initState() {
    _getDiscord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CommonTextWidget(
            S.of(context).setting_about_titan,
            fontSize: FontSize.large,
          ),
          iconTheme: const IconThemeData(color: AppDarkColors.iconColor),
          centerTitle: true,
          backgroundColor: AppDarkColors.backgroundColor,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 70.h,
              ),
              SizedBox(
                width: 217,
                height: 70,
                child: Image.asset("assets/images/setting_about_logo.png",
                    fit: BoxFit.contain),
              ),
              SizedBox(
                height: 70.h,
              ),
              _listTitleItem(context, S.of(context).setting_official_site,
                  () async {
                String url = AppConfig.officialSiteURL;
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              }),
              // _listTitleItem(context, S.of(context).setting_about_titan,
              //     () async {
              //   String url = 'https://test1.titannet.io/';
              //   if (!await launchUrl(Uri.parse(url))) {
              //     throw Exception('Could not launch $url');
              //   }
              // }),
              SizedBox(
                height: 16.h,
              ),
              _listTitleItem(context, S.of(context).setting_huygens_testnet,
                  () async {
                String url = "";
                bool isEnglish =
                    Provider.of<LocalizationProvider>(context, listen: false)
                        .isEnglish();
                if (isEnglish) {
                  url = AppConfig.docENURL;
                } else {
                  url = AppConfig.docCNURL;
                }

                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              }),
              SizedBox(
                height: 16.h,
              ),
              _listTitleItem(context, S.of(context).setting_twitter, () async {
                String url = AppConfig.twitterURL;
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              }),
              SizedBox(
                height: 26.h,
              ),
              _listTitleItem(context, S.of(context).setting_discord, () async {
                String url = discord;
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              }),
              SizedBox(
                height: 16.h,
              ),
              _listTitleItem(context, S.of(context).setting_telegram, () async {
                String url = AppConfig.telegeramURL;
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              })
            ],
          ),
        ));
  }

  static double kItemPaddingHorizontal = 28.0;

  String discord = AppConfig.discordURL;

  void _getDiscord() async {
    discord = await HttpService().discord();

    setState(() {});
  }

  Widget _listTitleItem(
      BuildContext context, String title, GestureTapCallback? onTap) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(
            vertical: 0, horizontal: kItemPaddingHorizontal),
        title: CommonTextWidget(
          title,
          fontSize: FontSize.extraSmall,
        ),
        trailing: _nextIcon(context),
        onTap: onTap);
  }

  Widget _nextIcon(BuildContext context) =>
      const Icon(Icons.chevron_right, color: Color(0xFF767680));
}
