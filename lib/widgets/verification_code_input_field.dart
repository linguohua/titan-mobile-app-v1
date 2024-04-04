import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';
import '../themes/colors.dart';
import 'captcha_slider.dart';

class VerificationCodeInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<void>? operationVerificationSuccess;

  const VerificationCodeInputField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator,
      this.onChanged,
      this.operationVerificationSuccess});

  @override
  _VerificationCodeInputFieldState createState() =>
      _VerificationCodeInputFieldState();
}

class _VerificationCodeInputFieldState
    extends State<VerificationCodeInputField> {
  bool _isButtonEnabled = true;

  void _sendVerificationCode() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            content: CaptchaSlider(
              onSuccess: () {
                Navigator.pop(context);
                widget.operationVerificationSuccess;
                setState(() {
                  _isButtonEnabled = false;
                });
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(72.0.w),
        border: Border.all(width: 1.0),
        color: AppDarkColors.inputBackgroundColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              style: const TextStyle(color: AppDarkColors.titleColor),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20.0),
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: AppDarkColors.hintColor),
                border: InputBorder.none,
              ),
              validator: widget.validator,
              onChanged: widget.onChanged,
            ),
          ),
          Container(
            constraints: BoxConstraints(minWidth: 88.0.w),
            decoration: BoxDecoration(
              color: AppDarkColors.backgroundColor,
              borderRadius: BorderRadius.circular(71.0.w),
            ),
            child: TextButton(
              onPressed: _isButtonEnabled ? _sendVerificationCode : null,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              child: Text(
                _isButtonEnabled
                    ? S.of(context).sender_decoder
                    : S.of(context).sent,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: _isButtonEnabled
                        ? const Color(0xFFE2E2E2)
                        : AppDarkColors.grayColor),
              ),
            ),
          ),
          SizedBox(
            width: 8.0.w,
          ),
        ],
      ),
    );
  }
}
