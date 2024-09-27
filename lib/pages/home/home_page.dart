import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/config/appConfig.dart';
import 'package:titan_app/mixin/base_view_tool.dart';
import 'package:titan_app/providers/version_provider.dart';
import 'package:titan_app/themes/colors.dart';
import 'package:titan_app/utils/system_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../ads/ad_dialog.dart';
import '../../ads/marquee_widget.dart';
import '../../bridge/bridge_mgr.dart';
import '../../config/constant.dart';
import '../../l10n/generated/l10n.dart';
import '../../providers/ads_provider.dart';
import '../../providers/localization_provider.dart';
import '../../utils/NetworkManager.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/common_text_widget.dart';
import '../../widgets/dialog/dialog_widget.dart';
import '../../widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, BaseViewTool {
  final double kImageSize = 300.w;
  double money = 0.0;

  //late VideoPlayerController _prepareController;
  late VideoPlayerController _runningController;

  // late Future<void> _initializePrepareVideoPlayerFuture;
  late Future<void> _initializeRunningVideoPlayerFuture;

  late final AppLifecycleListener _appLifecyclelistener;

  Duration loopStart = const Duration(seconds: 3);
  Duration prepareStart = const Duration(seconds: 0);

  bool isDaemonRunning = false;
  bool isDaemonOnline = false;
  int daemonCounter = 0;
  bool _isActivating = false;
  Timer? timer;
  bool isQuerying = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    isDaemonOnline = BridgeMgr().daemonBridge.isDaemonOnline;
    _appLifecyclelistener = AppLifecycleListener(
      onResume: () => _handleTransition('resume'),
      onInactive: () => _handleTransition('inactive'),
      onRestart: () => _handleTransition('restart'),
    );
    _runningController =
        VideoPlayerController.asset('assets/videos/running.mp4');
    _runningController.setLooping(true);
    _initializeRunningVideoPlayerFuture = _runningController.initialize();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AdDialog.adDialog(context, 0);

      // DialogUtils.openIPMax5Dialog(
      //     context, "The number of IPs exceeds the limit", onFunction: () {
      //   BridgeMgr().daemonBridge.setIpErrorMsg(null);
      // });

      BridgeMgr().minerBridge.minerInfo.addListener("income", "home_page", () {
        setState(() {
          money = BridgeMgr().minerBridge.minerInfo.todayIncome();
        });
      });
    });
    _networkListen();
    _startActivation();

    Provider.of<LocalizationProvider>(context, listen: false).addListener(() {
      AdDialog.adDialog(context, 0);
    });
  }

  @override
  void dispose() {
    _stopActivation();
    // _prepareController.dispose();
    _runningController.dispose();
    _appLifecyclelistener.dispose();
    BridgeMgr().minerBridge.minerInfo.removeListener("income", "home_page");
    super.dispose();
  }

  double isVisible() {
    return !isDaemonOnline ? 0.0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String versionName =
        Provider.of<VersionProvider>(context, listen: false).localVersion;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 144.h,
              left: (MediaQuery.of(context).size.width - kImageSize - 0.w) /
                  2, //40 buffer
              child: SizedBox(
                width: kImageSize,
                height: kImageSize,
                child: _imageNode(context),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 137.h,
                ),
                _todayEarnings(context),
                // SizedBox(
                //   height: 20.h,
                // ),
                // _imageNode(context),
                SizedBox(
                  height: 220.h,
                ),
                Text(
                  S.of(context).current_device_ID,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFAFAFA),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  BridgeMgr().daemonBridge.daemonCfgs.id(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF909090),
                  ),
                ),
                SizedBox(
                  height: SystemUtils.isIOS ? 100.h : 120.h,
                ),
                _startButton(context),
                SizedBox(
                  height: 12.h,
                ),
                _earningInfoButton(context),
                SizedBox(
                  height: 32.h,
                ),
                CommonTextWidget(
                  versionName,
                  fontSize: FontSize.extraSmall,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            Consumer<AdsProvider>(
              builder: (context, adsProvider, child) {
                return adsProvider.banners.isEmpty
                    ? Container()
                    : Positioned(
                        top: 30.h,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            AdDialog.adDialog(context, 1);
                          },
                          icon: const Icon(
                            Icons.notifications_sharp,
                            color: Colors.white,
                          ),
                        ),
                      );
              },
            ),
            MyMarqueeWidget(),
          ],
        ),
      ),
    );
  }

  Future<void> toMoneyDetailPage() async {
    if (!isDaemonOnline) {
      return;
    }
    var baseurl = AppConfig.nodeInfoURL;
    String url = '$baseurl${BridgeMgr().daemonBridge.daemonCfgs.id()}';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _todayEarnings(BuildContext context) {
    return Opacity(
        opacity: isVisible(),
        child: RichText(
          text: TextSpan(
            text: S.of(context).today_earnings,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14.0.sp),
            children: [
              TextSpan(
                  text: ' ${money.toStringAsFixed(3)} ',
                  style: TextStyle(
                      color: AppDarkColors.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0.sp),
                  children: [
                    TextSpan(
                        text: BridgeMgr().minerBridge.minerInfo.tokenUnit(),
                        style: TextStyle(
                            color: AppDarkColors.titleColor, fontSize: 14.0.sp))
                  ])
            ],
          ),
        ));
  }

  Widget _imageNode(BuildContext context) {
    // if (!isDaemonRunning) {
    //   return Image.asset(
    //     "assets/images/mobile_node_stop.png",
    //     fit: BoxFit.contain,
    //   );
    // }
    if (!isDaemonOnline) {
      return _startPrepareNode(context);
    } else {
      return _startRunningNode(context);
    }
  }

  void _networkListen() {
    NetworkManager().initialize();
    NetworkManager().connectivityStream.listen((result) async {
      openWifi(0);
    });
  }

  void _startActivation() {
    if (_isActivating) {
      return;
    }

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      await queryDaemonState();
    });

    BridgeMgr().minerBridge.startActivationg();
    _updateAnimation();

    _isActivating = true;
  }

  void _stopActivation() {
    timer?.cancel();
    BridgeMgr().minerBridge.stopActivation();

    // _prepareController.pause();
    _runningController.pause();

    _isActivating = false;
  }

  void _handleTransition(String name) {
    switch (name) {
      case "resume":
        _startActivation();
        break;
      case "inactive":
        _stopActivation();
        break;
      case "restart":
        _startActivation();
        break;
    }
  }

  void _updateAnimation() {
    const Duration zero = Duration(seconds: 0);
    _runningController.seekTo(zero);
    _runningController.pause();
    // _prepareController.seekTo(zero);
    // _prepareController.pause();

    if (isDaemonOnline) {
      _runningController.play();
    }
  }

  Widget _startPrepareNode(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Image.asset("assets/images/mobile_node_stop.png",
          fit: BoxFit.contain),
    );
  }

  Widget _startRunningNode(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: FutureBuilder(
          future: _initializeRunningVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (isDaemonOnline) {
                return AspectRatio(
                  aspectRatio: _runningController.value.aspectRatio * 1,
                  child: VideoPlayer(_runningController),
                );
              } else {
                return Image.asset("assets/images/mobile_node_stop.png",
                    fit: BoxFit.contain);
              }
            } else {
              return Image.asset("assets/images/mobile_node_stop.png",
                  fit: BoxFit.contain);
            }
          }),
    );
  }

  Widget _startButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        openWifi(1);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: (!isDaemonOnline)
            ? AppDarkColors.themeColor
            : const Color(0xff181818),
        minimumSize: Size(335.w, 48.h),
      ),
      child: Text(
        (!isDaemonOnline)
            ? S.of(context).start_earning_coins
            : S.of(context).stop_earning_coins,
        style: TextStyle(
            color: (!isDaemonOnline)
                ? AppDarkColors.backgroundColor
                : AppDarkColors.grayColor,
            fontSize: 18.sp),
      ),
    );
  }

  Widget _earningInfoButton(BuildContext context) {
    return Opacity(
        opacity: isVisible(),
        child: ElevatedButton(
          onPressed: toMoneyDetailPage,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(85.0),
                side: const BorderSide(color: AppDarkColors.themeColor),
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(Size(335.w, 48.h)),
            elevation: MaterialStateProperty.all<double>(5),
            overlayColor: MaterialStateProperty.all<Color>(
                Colors.lightBlueAccent.withOpacity(0.5)),
          ),
          child: Text(
            S.of(context).view_earnings_details,
            style: TextStyle(color: AppDarkColors.themeColor, fontSize: 18.sp),
          ),
        ));
  }

  void handleSignClick() async {
    var ret = await BridgeMgr().daemonBridge.sign("abc");
    debugPrint('handleSignClick: $ret');
  }

  Future<void> queryDaemonState() async {
    if (isQuerying) {
      return;
    }
    isQuerying = true;
    String result;
    result = await BridgeMgr().daemonBridge.daemonState();

    debugPrint('~~~state call: $result');
    isQuerying = false;

    var jsonResult = jsonDecode(result);
    bool isOnline = false;
    bool isRunning = false;
    if (jsonResult["code"] == 0) {
      final data = jsonDecode(jsonResult["data"]);
      isOnline = data["online"];
      isRunning = data["running"];

      if (BridgeMgr().daemonBridge.daemonCfgs.id() == "") {
        await BridgeMgr().daemonBridge.loadDaemonConfig();
        // update node info
        var cfg = BridgeMgr().daemonBridge.daemonCfgs;
        BridgeMgr().minerBridge.setNodeInfo(cfg.id(), cfg.areaID());
        // pull data from server
        BridgeMgr().minerBridge.pullInfo();
      }
    }
    if (isRunning && isOnline) {
      DialogUtils.closeIpDialog();
    }
    if (isDaemonOnline == isRunning && isDaemonOnline == isOnline) {
      return;
    }

    if (isOnline != isDaemonOnline) {
      if (isOnline) {
        // pull data from server imm
        BridgeMgr().minerBridge.pullInfo();
      } else {
        // if it is offline, stop increase incoming
        if (isDaemonOnline) {
          BridgeMgr().minerBridge.minerInfo.clearIncomeIncr();
        }
      }
    }

    setState(() {
      isDaemonRunning = isRunning;
      isDaemonOnline = isOnline;
      _updateAnimation();
    });

    openWifi(2);
  }

  Future<void> _onAction() async {
    Map<String, dynamic> result;
    String action;
    final String indicatorMsg =
        isDaemonOnline ? S.of(context).stopping : S.of(context).starting;

    LoadingIndicator.show(context, message: indicatorMsg);
    if (isDaemonOnline) {
      result = await BridgeMgr().daemonBridge.stopDaemon();
      action = "Stop daemon";
    } else {
      result = await BridgeMgr().daemonBridge.startDaemon();
      action = "Start daemon";
    }
    if (context.mounted) {
      LoadingIndicator.hide(context);
    }

    //debugPrint('start/stop call, action:$action, result: $result');
    if (result["bool"]) {
      setState(() {
        isDaemonOnline = !isDaemonOnline;
        _updateAnimation();
      });
    } else {
      if (context.mounted && !isDaemonOnline && !isDaemonRunning) {
        var ipError = BridgeMgr().daemonBridge.ipErrorMsg;
        if (ipError.isNotEmpty) {
          DialogUtils.openIPMax5Dialog(
              context, BridgeMgr().daemonBridge.ipErrorMsg, onFunction: () {
            BridgeMgr().daemonBridge.setIpErrorMsg(null);
          });
        } else {
          String msg = result["r"];
          Indicators.showMessage(context, action, msg, null, null);
        }
      }
    }
  }

  /**
   * 0: 网络监听；1 点击； 2 状态查询
   */
  Future<void> openWifi(int type) async {
    bool isConnected = await NetworkManager().isConnected();

    /// 没有网络
    if (!isConnected) {
      showToast(S.of(context).networkNotConnected);
      return;
    }
    bool isConnectedToWiFi = await NetworkManager().isConnectedToWiFi();
    var has4gRun = TTSharedPreferences.getInt(Constant.has4gRun) ?? 0;

    debugPrint(
        "network:is isWiFi  type=$type..$isConnectedToWiFi...$isDaemonOnline.....$has4gRun");

    if (isConnectedToWiFi) {
      DialogUtils.closeWifiDialog();
    }

    void showWifiDialog(
        String message, String cancelText, Function(bool) onCall) {
      DialogUtils.wifiDialog(
        context,
        message,
        cancel: cancelText,
        onCall: onCall,
        onDimssCall: () {},
      );
    }

    void handleDefaultCase() {
      showWifiDialog(
        S.of(context).usingMobileData,
        S.of(context).prohibit,
        (isStart) {
          if (!isStart) {
            _onAction();
          }
        },
      );
    }

    void handleProhibitedCase() {
      _onAction();
    }

    if (type == 0) {
      if (!isConnectedToWiFi && isDaemonOnline) {
        if (has4gRun == 0) {
          handleDefaultCase();
        } else if (has4gRun == 2) {
          handleProhibitedCase();
        }
      }
    } else if (type == 1) {
      if (!isConnectedToWiFi) {
        if (has4gRun == 0) {
          //默认 : 如果没有启动：提示启动流量信息
          if (!isDaemonOnline) {
            showWifiDialog(
              S.of(context).usingMobileData,
              S.of(context).cancel,
              (isStart) {
                if (isStart) {
                  _onAction();
                }
              },
            );
          } else {
            // 如果已经启动：停止操作
            _onAction();
          }
        } else if (has4gRun == 1) {
          // 允许
          // isDaemonOnline：判断是否是启动和断开
          _onAction();
        } else if (has4gRun == 2) {
          //禁止 ：如果没有启动：启动时提示 设置信息
          if (!isDaemonOnline) {
            showWifiDialog(
              S.of(context).currentResource,
              S.of(context).cancel,
              (isStart) {
                if (isStart) {
                  // 允许：去启动
                  _onAction();
                }
              },
            );
          } else {
            ///isDaemonOnline： 如果启动了则停止
            _onAction();
          }
        }
      } else {
        _onAction();
      }
    } else if (type == 2) {
      ///
      if (!isConnectedToWiFi && isDaemonOnline) {
        if (has4gRun == 0) {
          handleDefaultCase();
        } else if (has4gRun == 2) {
          handleProhibitedCase();
        }
      }
    }
  }
}
