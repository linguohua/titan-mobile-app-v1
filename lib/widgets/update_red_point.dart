import 'package:flutter/material.dart';

class UpdateRedPoint extends StatelessWidget {
  final bool isShow;

  const UpdateRedPoint({super.key, required this.isShow});
  @override
  Widget build(BuildContext context) {
    Widget radPoint = Container(
      width: 8,
      height: 8,
      decoration:
      const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
    if (isShow) {
      return radPoint;
    } else {
      return const SizedBox();
    }
  }
}
