import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/widgets/common_input_field.dart';
import 'package:titan_app/widgets/common_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/parsing.dart';

import '../../bridge/bridge_mgr.dart';
import '../../bridge/error.dart';
import '../../config/constant.dart';
import '../../l10n/generated/l10n.dart';
import '../../providers/localization_provider.dart';
import '../../themes/colors.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/wallet_confirm_dialog.dart';

class WalletBindingPage extends StatefulWidget {
  const WalletBindingPage({super.key});

  @override
  WalletBindingPageState createState() => WalletBindingPageState();
}

const String bindHelpUrlZh =
    "https://titannet.gitbook.io/titan-network-cn/herschel-testnet/chang-jian-wen-ti/bang-ding-shen-fen-ma";
//'https://titannet.gitbook.io/titan-network-cn/huygens-testnet/an-zhuang-cheng-xu-zhuan-qu/bang-ding-shen-fen-ma';

const String bindHelpUrlEn =
    "https://titannet.gitbook.io/titan-network-en/herschel-testnet/faq/bind-the-identity-code";
// "https://titannet.gitbook.io/titan-network-en/huygens-testnet/installation-and-earnings/bind-the-identity-code";

class WalletBindingPageState extends State<WalletBindingPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  //  _controller.text = "D754085C-60DE-445F-A906-84CC44ED8E63";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BridgeMgr().minerBridge.minerInfo.addListener("account", "page_binding",
          () {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isBinded = BridgeMgr().minerBridge.minerInfo.account.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppDarkColors.backgroundColor,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: !isBinded
            ? Column(
                children: [
                  _getIdentityCode(context),
                  const SizedBox(
                    height: 23,
                  ),
                  _inputIdentityCode(context)
                ],
              )
            : _bindedView(),
      )),
    );
  }

  Widget _getIdentityCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppDarkColors.inputBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/wallet_get_identity.png",
            width: 32,
            height: 32,
          ),
          const SizedBox(
            width: 12,
          ),
          SizedBox(
            width: 240.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(S.of(context).wallet_get_identity_title),
                const SizedBox(
                  height: 20,
                ),
                Text(S.of(context).wallet_get_identity_desc,
                    style: const TextStyle(
                      color: AppDarkColors.hintColor,
                      fontSize: 12,
                    ),
                    maxLines: 5,
                    softWrap: true),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    bool isEnglish = Provider.of<LocalizationProvider>(context,
                            listen: false)
                        .isEnglish();
                    launchUrl(
                        Uri.parse(isEnglish ? bindHelpUrlEn : bindHelpUrlZh));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppDarkColors.themeColor,
                    minimumSize: Size(222.w, 40.h),
                  ),
                  child: Text(
                    S.of(context).wallet_get_identity_button,
                    style: TextStyle(
                        color: AppDarkColors.backgroundColor, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onBoundAction(String bindingCode, BuildContext context1) {
    String nodeSign = "";
    if (bindingCode.isEmpty) {
      Indicators.showMessage(context1, S.of(context1).failed_bind,
          S.of(context1).error_input_empty, null, null);
      return;
    }

    try {
      UuidParsing.parse(bindingCode);
    } catch (e) {
      debugPrint("boundAction parse uuid failed:${e.runtimeType}");
      Indicators.showMessage(context1, S.of(context1).failed_bind,
          S.of(context1).error_identity_format_invalid, null, null);
      return;
    }

    getInfoCallback(String account, String address, int code) {
      if (code != 0) {
        Indicators.showMessage(context1, S.of(context1).failed_bind,
            ErrorCode.getErrorMessage(context1, code), null, null);
      } else {
        WalletConfirmDialog().show(
          context1,
          account,
          address,
          onConfirm: () async {
            await BridgeMgr().minerBridge.bindingAccount(bindingCode, nodeSign,
                (int code) {
              if (code != 0) {
                Indicators.showMessage(context1, S.of(context1).failed_bind,
                    ErrorCode.getErrorMessage(context1, code), null, null);
              } else {
                TTSharedPreferences.setString(Constant.userCode, bindingCode);
                TTSharedPreferences.setString(Constant.userAddress, account);
                BridgeMgr().minerBridge.minerInfo.account = account;
                BridgeMgr().minerBridge.minerInfo.address = address;
                BridgeMgr().minerBridge.minerInfo.bindingCode = bindingCode;
                BridgeMgr().minerBridge.minerInfo.notify('account');
                if (context1.mounted) {
                  Navigator.pop(context1);
                }
              }
            });
          },
        );
      }
    }

    BridgeMgr().daemonBridge.sign(bindingCode).whenComplete(() {}).then((sign) {
      var signature = json.decode(sign);
      if (signature['code'] != 0) {
        var msg = signature['msg'];
        Indicators.showMessage(
            context, S.of(context1).failed_bind, msg, null, null);
        return;
      }

      var data = json.decode(sign)['data'];
      nodeSign = json.decode(data)['signature'];
      BridgeMgr().minerBridge.getAccountInfo(bindingCode, getInfoCallback);
    }, onError: (e) {
      Indicators.showMessage(
          context, S.of(context1).failed_bind, e, null, null);
    });
  }

  void boundAction(String bindingCode, BuildContext context1) {
    var isRunning = BridgeMgr().daemonBridge.isEdgeExeRunning();
    var isOnline = BridgeMgr().daemonBridge.isEdgeOnline();

    debugPrint('isRunning:$isRunning :isOnline=$isOnline');

    if (!isRunning && !isOnline) {
      showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            backgroundColor: const Color(0xff181818),
            contentPadding: EdgeInsets.zero,
            title: Text(
              S.of(context).startNodeContinue,
              style: const TextStyle(),
            ),
            content: Container(
              margin: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60.w,
              child: Text(S.of(context).bindingErrorNode,
                  style: const TextStyle(fontSize: 16)),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(_context).pop(false);
                },
                child: Text(S.of(context).cancel,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(_context).pop();
                  LoadingIndicator.show(context,
                      message: S.of(context).starting);
                  var map = await BridgeMgr().daemonBridge.startDaemon();
                  Navigator.of(context).pop();
                  var isRunning = BridgeMgr().daemonBridge.isEdgeExeRunning();
                  var isOnline = BridgeMgr().daemonBridge.isEdgeOnline();
                  if (!isRunning && !isOnline) {
                    Indicators.showMessage(context1,
                        S.of(context1).failed_start, "$map", null, null);
                  } else {
                    _onBoundAction(bindingCode, context1);
                  }
                },
                child: Text(S.of(context).confirm,
                    style: const TextStyle(fontSize: 14, color: Colors.green)),
              ),
            ],
          );
        },
      ).then((value) {});
    } else {
      _onBoundAction(bindingCode, context1);
    }
  }

  Widget _inputIdentityCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // 设置内边距
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppDarkColors.inputBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/wallet_input_identity.png",
            width: 32,
            height: 32,
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonTextWidget(S.of(context).wallet_input_identity_title),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 222.w,
                height: 48.w,
                child: CommonInputField(
                  hintText: S.of(context).wallet_input_identity_desc,
                  backgroundColor: AppDarkColors.backgroundColor,
                  hintColor: const Color(0xFF4C4C4C),
                  hintFontSize: 12.sp,
                  controller: _controller,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  boundAction(_controller.text, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppDarkColors.themeColor,
                  minimumSize: Size(222.w, 40.h),
                ),
                child: Text(
                  S.of(context).wallet_input_identity_button,
                  style: TextStyle(
                      color: AppDarkColors.backgroundColor, fontSize: 16.sp),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _bindedView() {
    return Container(
        padding: const EdgeInsets.all(16), // 设置内边距
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppDarkColors.inputBackgroundColor),
        child: SizedBox(
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTextWidget('Token'),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(16), // 设置内边距
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppDarkColors.backgroundColor),
                  child: SizedBox(
                    width: 1.sw,
                    child: Row(
                      children: [
                        Text(S.of(context).bound,
                            style: const TextStyle(
                              color: AppDarkColors.hintColor,
                              fontSize: 12,
                            )),
                        const Expanded(child: SizedBox()),
                        Spacer(),
                        Container(
                          width: 200.w,
                          child: Text(
                              BridgeMgr().minerBridge.minerInfo.bindingCode,
                              softWrap: true,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: AppDarkColors.hintColor,
                                fontSize: 12,
                              )),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 25,
              ),
              CommonTextWidget(S.of(context).belongs),
              const SizedBox(
                height: 30,
              ),
              Container(
                  padding: const EdgeInsets.all(16), // 设置内边距
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppDarkColors.backgroundColor),
                  child: SizedBox(
                    width: 1.sw,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(S.of(context).email,
                                style: const TextStyle(
                                  color: AppDarkColors.hintColor,
                                  fontSize: 12,
                                )),
                            const Expanded(child: SizedBox()),
                            Text(BridgeMgr().minerBridge.minerInfo.account,
                                style: const TextStyle(
                                  color: AppDarkColors.hintColor,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(S.of(context).wallet_wallet_address,
                                style: const TextStyle(
                                  color: AppDarkColors.hintColor,
                                  fontSize: 12,
                                )),
                            const Expanded(child: SizedBox()),
                            Text(BridgeMgr().minerBridge.minerInfo.address,
                                style: const TextStyle(
                                  color: AppDarkColors.hintColor,
                                  fontSize: 12,
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    BridgeMgr().minerBridge.minerInfo.removeListener("account", "page_binding");
    super.dispose();
  }
}
