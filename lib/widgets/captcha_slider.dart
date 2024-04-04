import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../themes/colors.dart';

class CaptchaSlider extends StatefulWidget {
  final VoidCallback onSuccess;

  const CaptchaSlider({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _CaptchaSliderState createState() => _CaptchaSliderState();
}

class _CaptchaSliderState extends State<CaptchaSlider> {
  double _sliderPosition = 0;
  bool _isSliding = false;

  @override
  Widget build(BuildContext context) {
    double mLeft = 46;
    double mWidth = MediaQuery.of(context).size.width - mLeft * 2;
    double mImageWidth = 44;
    double mTargetLocation = mWidth - mImageWidth * 2;
    return GestureDetector(
      onHorizontalDragStart: (details) {
        setState(() {
          _isSliding = true;
        });
      },
      onHorizontalDragUpdate: (details) {
        if (_isSliding) {
          setState(() {
            _sliderPosition =
                (details.localPosition.dx).clamp(0, mTargetLocation);
          });
        }
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _isSliding = false;
          if (_sliderPosition >= mTargetLocation) {
            widget.onSuccess();
          } else {
            setState(() {
              _sliderPosition = 0;
            });
          }
        });
      },
      child: Container(
        width: mWidth,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Stack(
          children: [
            Positioned(
              left: 56,
              top: 8,
              child: Text(
                S.of(context).verification_drag_tip,
                style: const TextStyle(
                    fontSize: 16, color: AppDarkColors.hintColor),
              ),
            ),
            Positioned(
              //
              left: _sliderPosition,
              child: Image.asset("assets/images/slider_icon.png"),
            ),
          ],
        ),
      ),
    );
  }
}
