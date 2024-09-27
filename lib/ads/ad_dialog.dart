import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/ext/visibility_ext.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../config/constant.dart';
import '../http/HttpService.dart';
import '../l10n/generated/l10n.dart';
import '../main.dart';
import '../providers/ads_provider.dart';
import '../providers/localization_provider.dart';
import '../utils/shared_preferences.dart';
import '../widgets/flutter_swiper/swiper.dart';
import '../widgets/flutter_swiper/swiper_controller.dart';
import '../widgets/flutter_swiper/swiper_pagination.dart';
import '../widgets/flutter_swiper/swiper_plugin.dart';

class AdDialog {
  static bool isDialogShowing = false;

  static Future<void> adDialog(BuildContext context, int tag,
      {Function? onCall}) async {
    LocalizationProvider local =
        Provider.of<LocalizationProvider>(context, listen: false);
    final String lang = local.isEnglish() ? "en" : "cn";
    var map = await HttpService().banners(lang);
    if (map == null) {
      return;
    }
    List<dynamic> list = map["list"] ?? [];
    if (list.isEmpty) {
      return;
    }
    Provider.of<AdsProvider>(context, listen: false).setBanners(list);

    if (tag == 0) {
      await Future.delayed(const Duration(milliseconds: 1000));
      int timestamp1 =
          TTSharedPreferences.getInt(Constant.adNextTimestamp) ?? 0;
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
      DateTime dateTime2 =
          DateTime.fromMillisecondsSinceEpoch(currentTimestamp);
      // DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(1718705179000);
      Duration difference = dateTime2.difference(dateTime1);
      if (difference.inHours > 24) {
      } else {
        return;
      }
    }
    if (isDialogShowing) {
      return;
    }
    isDialogShowing = true;
    showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isChecked = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return PopScope(
              canPop: false,
              child: Material(
                color: Colors.transparent.withOpacity(0.5),
                child: Center(
                  child: SizedBox(
                    height: 350.w,
                    width: 375.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CustomViewBanner(list),
                            Positioned(
                              right: 5.w,
                              top: 5.w,
                              child: GestureDetector(
                                onTap: () async {
                                  if (isChecked) {
                                    await TTSharedPreferences.setInt(
                                        Constant.adNextTimestamp,
                                        DateTime.now().millisecondsSinceEpoch);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Image.asset(
                                  "assets/images/common_icons_close.png",
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                isChecked
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank,
                                //check_box_outline_blank
                                color: Colors.white,
                                size: 15.w,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                S.of(context).t24TimeNotShow,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) => isDialogShowing = false);
  }
}

class CustomViewBanner extends StatefulWidget {
  final List list;

  const CustomViewBanner(this.list, {super.key});

  @override
  State<StatefulWidget> createState() => _CustomBannerViewState();
}

class _CustomBannerViewState extends State<CustomViewBanner>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final SwiperController _swiperController = SwiperController();
  var jsonData = [];

  @override
  void initState() {
    jsonData = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SwiperPlugin swiperPlugin = DotSwiperPaginationBuilder(
      color: Colors.white54,
      activeColor: const Color(0xFF00FF00),
      size: 8.w,
      activeSize: 8.w,
      // activeSize: 8,
    );

    List<Widget> itemArray = jsonData.map((e) {
          return RepaintBoundary(
            child: GestureDetector(
              onTap: () async {
                String url = e["redirect_url"] ?? "";
                if (url.isNotEmpty) {
                  if (!await launchUrl(Uri.parse(url))) {
                    throw Exception('Could not launch $url');
                  }
                }
              },
              child: CachedNetworkImage(
                imageUrl: e["desc"],
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholder: (context, str) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white10,
                    child: const Icon(
                      Icons.image_outlined,
                      color: Colors.white10,
                    ),
                  );
                },
              ),
            ),
          );
        }).toList() ??
        [];
    return VisibilityDetector(
        key: ValueKey(identityHashCode(this)),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.isVisible()) {
            _swiperController.startAutoplay();
          } else {
            _swiperController.stopAutoplay();
          }
        },
        child: Container(
          height: 255.w,
          width: 375.w,
          margin: EdgeInsets.all(15.w),
          color: const Color(0x00000000),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Set the desired bord
            child: jsonData.length == 1
                ? CachedNetworkImage(
                    imageUrl: jsonData[0]["desc"],
                    fit: BoxFit.cover,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholder: (context, str) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white10,
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.white10,
                        ),
                      );
                    },
                  )
                : Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return itemArray[index];
                    },
                    itemCount: jsonData.length,
                    // 选中时的指示器
                    pagination: jsonData.length == 1
                        ? null
                        : SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: swiperPlugin,
                            margin: EdgeInsets.only(bottom: 10.w),
                          ),
                    control: null,
                    controller: _swiperController,
                    duration: 150,
                    scrollDirection: Axis.horizontal,
                    viewportFraction: 1,
                    autoplay: jsonData.length == 1 ? false : true,
                    onTap: (int index) {},
                  ),
          ),
        ));
  }
}
