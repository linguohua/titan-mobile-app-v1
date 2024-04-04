import 'package:flutter/material.dart';
import 'package:titan_app/themes/colors.dart';
import 'package:titan_app/widgets/common_text_widget.dart';

import '../../generated/l10n.dart';

class WalletInformationPage extends StatelessWidget {
  const WalletInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppDarkColors.backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppDarkColors.inputBackgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonTextWidget("Token"),
                const SizedBox(
                  height: 16,
                ),
                _leftRightItem(context, S.of(context).wallet_bound,
                    "FIABDEKCBHDVKCEDL28934mgcxk", true),
                const SizedBox(
                  height: 20,
                ),
                CommonTextWidget(S.of(context).wallet_user),
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
                          "aaa@gmail.com",
                          false),
                      _leftRightItem(
                          context,
                          S.of(context).wallet_wallet_address,
                          "~/Library/App......otannetwork/",
                          false),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
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
            style:
                const TextStyle(color: AppDarkColors.grayColor, fontSize: 11),
          )
        ],
      ),
    );
  }
}
