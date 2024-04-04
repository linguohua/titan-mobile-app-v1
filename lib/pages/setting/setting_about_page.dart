import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../../themes/colors.dart';
import '../../widgets/common_text_widget.dart';

class SettingAboutPage extends StatelessWidget {
  const SettingAboutPage({super.key});

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
                String url = 'https://www.titannet.io/';
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
                String url = 'https://huygens.titannet.io/';
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              }),
              SizedBox(
                height: 16.h,
              ),
              _listTitleItem(context, S.of(context).setting_twitter, () async {
                String url = 'https://twitter.com/Titannet_dao';
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              }),
              SizedBox(
                height: 26.h,
              ),
              _listTitleItem(context, S.of(context).setting_discord, () async {
                String url = 'https://discord.com/invite/web3depin';
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              }),
              SizedBox(
                height: 16.h,
              ),
              _listTitleItem(context, S.of(context).setting_telegram, () async {
                String url = 'https://t.me/titannet_dao';
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              })
            ],
          ),
        ));
  }

  static double kItemPaddingHorizontal = 28.0;

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
