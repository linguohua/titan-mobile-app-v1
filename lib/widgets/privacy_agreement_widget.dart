import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../themes/colors.dart';
import 'bottom_sheet_dialog.dart';

class PrivacyAgreementWidget extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTap;

  const PrivacyAgreementWidget(
    this.checked, {
    super.key,
    required this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: checked,
            onChanged: onChanged,
            side: const BorderSide(color: Colors.grey),
            checkColor: AppDarkColors.backgroundColor,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            fillColor: MaterialStateProperty.all<Color>(
                checked ? AppDarkColors.themeColor : Colors.transparent),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap;
            } else {
              BottomSheetDialog.show(context,
                  title: S.of(context).usage_protocol,
                  content: S.of(context).privacy_content);
            }
          },
          child: RichText(
            text: TextSpan(
              text: S.of(context).privacy_policy_1,
              style: const TextStyle(
                color: AppDarkColors.grayColor,
                fontSize: 12.0,
                decoration: TextDecoration.underline,
              ),
              children: [
                TextSpan(
                  text: S.of(context).privacy_policy_2,
                  style: const TextStyle(
                    color: AppDarkColors.themeColor,
                    fontSize: 12.0,
                    decoration: TextDecoration.underline,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
