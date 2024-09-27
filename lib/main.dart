import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/pages/home/emulator_page.dart';
import 'package:titan_app/pages/home/home_page.dart';
import 'package:titan_app/pages/logs/logs_page.dart';
import 'package:titan_app/pages/setting/setting_page.dart';
import 'package:titan_app/pages/wallet/wallet_binding_page.dart';
import 'package:titan_app/providers/ads_provider.dart';
import 'package:titan_app/providers/auth_provider.dart';
import 'package:titan_app/providers/localization_provider.dart';
import 'package:titan_app/providers/version_provider.dart';
import 'package:titan_app/themes/system_ui_overlay_style.dart';
import 'package:titan_app/themes/theme_data.dart';
import 'package:titan_app/widgets/tab_bottom_bar.dart';
import 'package:titan_app/widgets/update_red_point.dart';

import 'bridge/bridge_mgr.dart';
import 'command/launch_before.dart';
import 'ffi/nativel2.dart';
import 'l10n/generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // todo: support PAD
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await LaunchBeforeCommand.setUp();
  await Future.delayed(const Duration(milliseconds: 300));

  var str = await NativeL2().isEmulator();
  Map<String, dynamic> jsonResponse = jsonDecode(str!);

  // 获取 code 的值
  bool code = jsonResponse['code'];
  String msg = jsonResponse['msg'];
  if (code) {
    runApp(MyApp(msg));
  } else {
    runApp(const AppHomePage());
  }
}

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _AppHomePageState extends State<AppHomePage> {
  final PageController _controller = PageController();
  final ScrollPhysics _neverScroll = const NeverScrollableScrollPhysics();
  int _pageIndex = 0;
  bool _isNodeBound = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

    BridgeMgr().minerBridge.minerInfo.removeListener("account", "Main.dart");
  }

  @override
  void initState() {
    super.initState();

    _isNodeBound = BridgeMgr().minerBridge.minerInfo.account.isNotEmpty;
    BridgeMgr().minerBridge.minerInfo.addListener("account", "Main.dart", () {
      setState(() {
        _isNodeBound = BridgeMgr().minerBridge.minerInfo.account.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayDarkStyle);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LocalizationProvider()),
        ChangeNotifierProvider(create: (context) => VersionProvider()),
        ChangeNotifierProvider(create: (context) => AdsProvider()),
      ],
      child: Consumer2<AuthProvider, LocalizationProvider>(
        builder: (context, auth, localization, _) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: darkTheme,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: S.supportedLocales,
              locale: localization.locale,
              home: _home(context, localization),
            ),
          );
        },
      ),
    );
  }

  Widget _home(BuildContext context, LocalizationProvider localization) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _controller,
        physics: _neverScroll,
        children: [
          const HomePage(),
          const WalletBindingPage(),
          // LogsPage(),
          SettingPage(
            onBackCall: () {
              setState(() {
                _onTapBottomNav(0);
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    var isLatestVersion =
        !(Provider.of<VersionProvider>(context, listen: true).isUpgradeAble);

    return Stack(
      children: [
        TabBottomBar(
          initPosition: _pageIndex,
          onItemTap: _onTapBottomNav,
          onItemLongTap: _onItemLongTap,
        ),
        Positioned(
            left: 175.w,
            top: 16.h,
            child: UpdateRedPoint(isShow: !_isNodeBound)),
        Positioned(
            right: 55.w,
            top: 16.h,
            child: UpdateRedPoint(isShow: !isLatestVersion))
      ],
    );
  }

  void _onTapBottomNav(int index) {
    _controller.jumpToPage(index);
    _pageIndex = index;
    setState(() {});
  }

  void _onItemLongTap(BuildContext context, int index) {}
}
