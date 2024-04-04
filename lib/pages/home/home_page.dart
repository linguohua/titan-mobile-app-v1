import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:titan_app/themes/colors.dart';
import 'package:titan_app/utils/system_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import '../../bean/bridge_mgr.dart';
import '../../http_repository/bridge_miner.dart';
import '/ffi/titanedge_jcall.dart' as nativel2;

import '../../generated/l10n.dart';
import '../../widgets/common_text_widget.dart';
import '../../widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final double kImageSize = 300.w;
  double money = 0.0;
  bool running = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isDaemonRunning = false;
  int daemonCounter = 0;
  bool isClickHandling = false;
  String _title = "Start";
  late Timer timer;
  bool isQuerying = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/running.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      queryDaemonState();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BridgeMgr().minerBridge.minerInfo.addListener("income", "today", () {
        setState(() {
          money = BridgeMgr().minerBridge.minerInfo.todayIncome();
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    BridgeMgr().minerBridge.minerInfo.removeListener("income", "today");
    super.dispose();
  }

  double isVisible() {
    return running ? 1 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 144.h,
              left: (MediaQuery.of(context).size.width - kImageSize - 40.w) /
                  2, //40 buffer
              child: _imageNode(context),
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
                  "v1.0.0",
                  fontSize: FontSize.extraSmall,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> toMoneyDetailPage() async {
    String url = 'https://test1.titannet.io/nodeidDetail?device_id=${BridgeMgr().daemonBridge.daemonCfgs.id()}';
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
                        text: S.of(context).TTN,
                        style: TextStyle(
                            color: AppDarkColors.titleColor, fontSize: 14.0.sp))
                  ])
            ],
          ),
        ));
  }

  Widget _imageNode(BuildContext context) {
    return SizedBox(
      width: kImageSize,
      height: kImageSize,
      child: running
          ? _startPlayNode(context)
          : Image.asset(
              "assets/images/mobile_node_stop.png",
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _startPlayNode(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (running) {
                _controller.play();
              }
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio * 1,
                child: VideoPlayer(_controller),
              );
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
        if (running) {
          _controller.seekTo(const Duration(seconds: 1));
          _controller.pause();
          setState(() {
            running = false;
          });
        } else {
          LoadingIndicator.show(context, message: S.of(context).running);
          _controller.seekTo(const Duration(seconds: 1));
          Future.delayed(const Duration(seconds: 2), () {
            _controller.play();
            setState(() {
              running = true;
            });
            LoadingIndicator.hide(context);
          });
        }
        handleStartStopClick();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            running ? const Color(0xff181818) : AppDarkColors.themeColor,
        minimumSize: Size(335.w, 48.h),
      ),
      child: Text(
        running
            ? S.of(context).stop_earning_coins
            : S.of(context).start_earning_coins,
        style: TextStyle(
            color: running
                ? AppDarkColors.grayColor
                : AppDarkColors.backgroundColor,
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

  Future<String> startDaemon() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");
    var repoDirectory = Directory(repoPath);
    if (!await repoDirectory.exists()) {
      await repoDirectory.create();
    }

    print("path ${repoDirectory}");

    Map<String, dynamic> startDaemonArgs = {
      'repoPath': repoPath,
      'logPath': path.join(directory.path, "edge.log"),
      'locatorURL':"https://test-locator.titannet.io:5000/rpc/v0"
    };

    String startDaemonArgsJSON = json.encode(startDaemonArgs);

    Map<String, dynamic> jsonCallArgs = {
      'method': 'startDaemon',
      'JSONParams': startDaemonArgsJSON,
    };

    var args = json.encode(jsonCallArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  Future<String> stopDaemon() async{
    Map<String, dynamic> stopDaemonArgs = {
      'method': 'stopDaemon',
      'JSONParams': "",
    };

    var args = json.encode(stopDaemonArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  Future<String> daemonState() async {
    Map<String, dynamic> jsonCallArgs = {
      'method': 'state',
      'JSONParams': "",
    };

    var args = json.encode(jsonCallArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  void handleSignClick() async {
    var ret = await daemonSign();
    debugPrint('handleSignClick: $ret');
  }

  Future<String> daemonSign() async {
    var directory = await getApplicationDocumentsDirectory();
    var repoPath = path.join(directory.path, "titanl2");

    Map<String, dynamic> signReqArgs = {
      'repoPath': repoPath,
      'hash':"abc"
    };

    var signReqArgsJSON = json.encode(signReqArgs);

    Map<String, dynamic> jsonCallArgs = {
      'method': 'sign',
      'JSONParams': signReqArgsJSON,
    };

    var args = json.encode(jsonCallArgs);

    var result = await nativel2.L2APIs().jsonCall(args);
    return result;
  }

  void queryDaemonState() async {
    if (isQuerying) {
      return;
    }

    if (!isDaemonRunning) {
      return;
    }

    isQuerying = true;
    String result;

    result = await daemonState();

    debugPrint('state call: $result');

    isQuerying = false;
    final Map<String, dynamic> jsonResult = jsonDecode(result);

    if (jsonResult["Code"] == 0) {
      if (jsonResult["Counter"] != daemonCounter) {
        daemonCounter = jsonResult["Counter"];

        setState(() {
          final String prefix = isDaemonRunning ? "Stop" : "Start";
          _title = "$prefix(counter:$daemonCounter)";
        });
      }
    }
  }

  void handleStartStopClick() async {
    if (isClickHandling) {
      return;
    }

    isClickHandling = true;
    String result;

    if (isDaemonRunning) {
      result = await stopDaemon();
    } else {
      result = await startDaemon();
    }

    debugPrint('start/stop call: $result');
    isClickHandling = false;
    final Map<String, dynamic> jsonResult = jsonDecode(result);

    if (jsonResult["code"] == 0) {
      isDaemonRunning = !isDaemonRunning;
      setState(() {
        _title = isDaemonRunning ? "Stop" : "Start";
      });
    }
  }
}
