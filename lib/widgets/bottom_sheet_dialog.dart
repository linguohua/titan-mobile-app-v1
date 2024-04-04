import 'package:flutter/material.dart';

import '../themes/colors.dart';

class BottomSheetDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: AppDarkColors.hintColor,
                  onPressed: () => Navigator.of(context).pop(), // 关闭底部弹出框
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(title, context),
                  const SizedBox(height: 20),
                  _buildContent(content, context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTitle(String title, BuildContext context) {
    return Stack(
      children: [
        Text(
          title,
          style: const TextStyle(color: AppDarkColors.titleColor, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Widget _buildContent(String content, BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          child: Text(
            content,
            style:
                const TextStyle(color: AppDarkColors.hintColor, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
