import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../themes/colors.dart';

class LogsItem extends StatelessWidget {
  final String time;
  final String status;
  final String environment;
  final String description;

  const LogsItem({
    super.key,
    this.time = "",
    this.status = "",
    this.environment = "",
    this.description = "",
  });

  Widget _titleItem(BuildContext context, String title, String text) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: AppDarkColors.grayColor,
              fontSize: 12.0,
            ),
            children: [
              TextSpan(
                text: text,
                style: const TextStyle(
                  color: AppDarkColors.titleColor,
                  fontSize: 14.0,
                ),
              )
            ],
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
          _titleItem(context, S.of(context).history_time, time),
          const SizedBox(
            height: 15,
          ),
          _titleItem(context, S.of(context).history_status, status),
          const SizedBox(
            height: 15,
          ),
          _titleItem(context, S.of(context).history_environment, environment),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            style:
                const TextStyle(color: AppDarkColors.grayColor, fontSize: 12),
          )
        ],
      ),
    );
  }
}
