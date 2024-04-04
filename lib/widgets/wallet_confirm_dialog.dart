import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:titan_app/themes/colors.dart';

import '../generated/l10n.dart';

class WalletConfirmDialog {
  void show(
    BuildContext context,
    String email,
    String walletAddress,
    { required VoidCallback onConfirm }) {
    //set default value when empty
    if (walletAddress.isEmpty) walletAddress = '~/Library/App......otannetwork/';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              Center(
                child: Container(
                  width: 310,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppDarkColors.inputBackgroundColor,
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        S.of(context).wallet_verify_information,
                        style: const TextStyle(
                          color: AppDarkColors.titleColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 19.0),
                      Image.asset(
                        "assets/images/wallet_confirm_information.png",
                        width: 120,
                        height: 120,
                      ),
                      // Content
                      const SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).wallet_user,
                            style: const TextStyle(
                                color: AppDarkColors.grayColor, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppDarkColors.backgroundColor,
                            ),
                            child: Column(
                              children: [
                                _leftRightItem(
                                    context,
                                    S.of(context).wallet_email_address,
                                    email,
                                    false),
                                _leftRightItem(
                                    context,
                                    S.of(context).wallet_wallet_address,
                                    walletAddress ?? '~/Library/App......otannetwork/',
                                    false),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppDarkColors.themeColor,
                          minimumSize: const Size(247, 48),
                        ),
                        child: Text(
                          S.of(context).wallet_confirm_bind,
                          style: const TextStyle(
                              color: AppDarkColors.backgroundColor,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 180.w,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: const Color(0xFF565656),
                  onPressed: () => Navigator.of(context).pop(), // 关闭底部弹出框
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _leftRightItem(
      BuildContext context, String title, String content, bool haveBorder) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: haveBorder
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppDarkColors.backgroundColor,
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                const TextStyle(color: AppDarkColors.grayColor, fontSize: 12),
          ),
          Text(
            content,
            style: const TextStyle(color: AppDarkColors.grayColor, fontSize: 9),
          )
        ],
      ),
    );
  }

  void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
