import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';
import '../themes/colors.dart';
import '../utils/system_utils.dart';

typedef IndexTapCallback = void Function(int);
typedef IndexLongTapCallback = void Function(BuildContext, int);

class TabBottomBar extends StatefulWidget {
  final int initPosition;

  final IndexTapCallback? onItemTap;
  final IndexLongTapCallback? onItemLongTap;

  const TabBottomBar(
      {super.key, this.onItemTap, this.onItemLongTap, this.initPosition = 0});

  @override
  State<TabBottomBar> createState() => _TabBottomBarState();
}

class _TabBottomBarState extends State<TabBottomBar> {
  List<String> get bottomBar => [
        S.of(context).tab_home,
        S.of(context).tab_wallet,
        S.of(context).tab_history,
        S.of(context).tab_setting,
      ];

  Image createTabImage(String name) {
    return Image.asset(name, width: 20.w, height: 20.w);
  }

  List<Image> get bottomBarActiveIcon => [
        createTabImage("assets/images/tab_home_active.png"),
        createTabImage("assets/images/tab_wallet_active.png"),
        createTabImage("assets/images/tab_log_active.png"),
        createTabImage("assets/images/tab_setting_active.png"),
      ];
  List<Image> get bottomBarIcon => [
        createTabImage("assets/images/tab_home_normal.png"),
        createTabImage("assets/images/tab_wallet_normal.png"),
        createTabImage("assets/images/tab_log_normal.png"),
        createTabImage("assets/images/tab_setting_normal.png"),
      ];
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _position = widget.initPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white24,
                width: SystemUtils.onePixel,
              ),
            ),
          ),
          child: Container(
            color: AppDarkColors.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            child: BottomNavigationBar(
              onTap: (position) {
                _position = position;
                widget.onItemTap?.call(_position);
                setState(() {});
              },
              backgroundColor: AppDarkColors.backgroundColor,
              currentIndex: _position,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: AppDarkColors.tabBarNormalColor,
              selectedItemColor: AppDarkColors.tabBarNormalColor,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              showUnselectedLabels: true,
              showSelectedLabels: true,
              useLegacyColorScheme: false,
              items: bottomBar
                  .asMap()
                  .keys
                  .map((index) => BottomNavigationBarItem(
                      label: bottomBar[index],
                      icon: bottomBarIcon[index],
                      activeIcon: bottomBarActiveIcon[index]))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
