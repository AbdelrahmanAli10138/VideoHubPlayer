import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';

class CustomHomeStack extends StatelessWidget {
  CustomHomeStack({super.key, required this.backgroundColor});
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 155,
          width: 171,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ],
    );
  }
}
