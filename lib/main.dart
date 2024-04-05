import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/pages/home/home_page.dart';
// import 'package:titan_app/pages/login/login_page.dart';
import 'package:titan_app/pages/logs/logs_page.dart';
import 'package:titan_app/pages/setting/setting_page.dart';
import 'package:titan_app/pages/wallet/wallet_binding_page.dart';
import 'package:titan_app/providers/auth_provider.dart';
import 'package:titan_app/providers/localization_provider.dart';
import 'package:titan_app/providers/version_provider.dart';
import 'package:titan_app/themes/system_ui_overlay_style.dart';
import 'package:titan_app/themes/theme_data.dart';
import 'package:titan_app/widgets/tab_bottom_bar.dart';
import 'package:titan_app/widgets/update_red_point.dart';

import 'bean/bridge_mgr.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BridgeMgr.init();
  // https://stackoverflow.com/questions/69851578/why-does-my-flutter-page-sometimes-not-render-completely-in-release-version
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(const AppHomePage());
}

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  final PageController _controller = PageController();
  final ScrollPhysics _neverScroll = const NeverScrollableScrollPhysics();
  int _pageIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
      ],
      child: Consumer2<AuthProvider, LocalizationProvider>(
        builder: (context, auth, localization, _) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: darkTheme,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales,
              locale: localization.locale,
              home: _home(context, localization),
            ),
          );
        },
      ),
    );
  }

  // Widget _login(BuildContext context) {
  //   return Scaffold(
  //       extendBody: true,
  //       body: SafeArea(
  //         top: false,
  //         child: PageView(
  //           controller: _controller,
  //           physics: _neverScroll,
  //           children: const [
  //             LoginPage(),
  //           ],
  //         ),
  //       ));
  // }

  Widget _home(BuildContext context, LocalizationProvider localization) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _controller,
        physics: _neverScroll,
        children: const [
          HomePage(),
          WalletBindingPage(),
          // WalletInformationPage(),
          LogsPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    var isLatestVersion =
        Provider.of<VersionProvider>(context, listen: true).isLatestVersion;

    return Stack(
      children: [
        TabBottomBar(
          initPosition: _pageIndex,
          onItemTap: _onTapBottomNav,
          onItemLongTap: _onItemLongTap,
        ),
        const Positioned(
            left: 165, top: 16, child: UpdateRedPoint(isShow: true)),
        Positioned(
            right: 35, top: 16, child: UpdateRedPoint(isShow: !isLatestVersion))
      ],
    );
  }

  void _onTapBottomNav(int index) {
    _controller.jumpToPage(index);
    _pageIndex = index;
  }

  void _onItemLongTap(BuildContext context, int index) {}
}
