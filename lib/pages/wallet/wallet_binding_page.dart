import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/widgets/common_input_field.dart';
import 'package:titan_app/widgets/common_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bean/bridge_mgr.dart';
import '../../generated/l10n.dart';
import '../../http_repository/error.dart';
import '../../lang/lang.dart';
import '../../providers/localization_provider.dart';
import '../../themes/colors.dart';
import '../../utils/utility.dart';
import '../../widgets/wallet_confirm_dialog.dart';

class WalletBindingPage extends StatefulWidget {
  const WalletBindingPage({super.key});

  @override
  WalletBindingPageState createState() => WalletBindingPageState();
}

const String bindHelpUrlZh =
    'https://titannet.gitbook.io/titan-network-cn/huygens-testnet/an-zhuang-cheng-xu-zhuan-qu/bang-ding-shen-fen-ma';

const String bindHelpUrlEn =
    "https://titannet.gitbook.io/titan-network-en/huygens-testnet/installation-and-earnings/bind-the-identity-code";

class WalletBindingPageState extends State<WalletBindingPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    debugPrint('build call, isBinded:$isBinded');
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

  void boundAction(String bindingCode, BuildContext context1) {
    String nodeSign = "";
    getInfoCallback(String account, String address, int code) {
      if (code != 0) {
        Indicators.showMessage(context1, Lang().dict.bindingError,
            ErrorCode.getErrorMessage(code), null, null);
      } else {
        WalletConfirmDialog().show(
          context1,
          account,
          address,
          onConfirm: () async {
            await BridgeMgr().minerBridge.bindingAccount(bindingCode, nodeSign,
                (int code) {
              if (code != 0) {
                Indicators.showMessage(context1, Lang().dict.bindingError,
                    ErrorCode.getErrorMessage(code), null, null);
              } else {
                BridgeMgr().minerBridge.minerInfo.account = account;
                BridgeMgr().minerBridge.minerInfo.address = address;
                BridgeMgr().minerBridge.minerInfo.bindingCode = bindingCode;
                BridgeMgr().minerBridge.minerInfo.notify('account');
              }
            });
            if (context1.mounted) {
              Navigator.pop(context1);
            }
          },
        );
      }
    }

    BridgeMgr().daemonBridge.sign(bindingCode).whenComplete(() {}).then((sign) {
      var signature = json.decode(sign);
      if (signature['code'] != 0) {
        var msg = signature['msg'];
        Indicators.showMessage(
            context, Lang().dict.bindingError, msg, null, null);
        return;
      }

      var data = json.decode(sign)['data'];
      nodeSign = json.decode(data)['signature'];
      BridgeMgr().minerBridge.getAccountInfo(bindingCode, getInfoCallback);
    }, onError: (e) {
      Indicators.showMessage(context, Lang().dict.bindingError, e, null, null);
    });
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
                        Text(Lang().dict.bound,
                            style: const TextStyle(
                              color: AppDarkColors.hintColor,
                              fontSize: 12,
                            )),
                        const Expanded(child: SizedBox()),
                        Text(BridgeMgr().minerBridge.minerInfo.bindingCode,
                            style: const TextStyle(
                              color: AppDarkColors.hintColor,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 25,
              ),
              CommonTextWidget(Lang().dict.belongs),
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
                            Text(Lang().dict.email,
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
                            Text(Lang().dict.walletAddress,
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
