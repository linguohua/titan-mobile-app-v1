import 'package:flutter/material.dart';

import '../themes/colors.dart';

class LogsItem extends StatelessWidget {
  final String environment;
  final String description;
  final Color? textColor;

  const LogsItem({
    super.key,
    this.environment = "",
    this.description = "",
    this.textColor = AppDarkColors.titleColor,
  });

  Widget _titleItem(BuildContext context, String title) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(
              color: textColor,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleDescItem(BuildContext context, String title) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: AppDarkColors.titleColor,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppDarkColors.inputBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _titleItem(context, environment),
          const SizedBox(
            height: 15,
          ),
          _titleDescItem(context, description),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
