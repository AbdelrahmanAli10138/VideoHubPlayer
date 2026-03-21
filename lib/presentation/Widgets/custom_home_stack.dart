import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';

class CustomHomeStack extends StatelessWidget {
  CustomHomeStack({
    super.key,
    required this.backgroundColor,
    required this.positionedicon,
    required this.positionedString,
    required this.stringColor,
  });
  final Color backgroundColor;
  final Icon positionedicon;
  final String positionedString;
  final Color stringColor;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          height: height * 0.20,
          width: width * 0.40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        Positioned(
          bottom: 55,
          right: 22,
          child: Container(
            child: Column(
              children: [
                positionedicon,
                Text(
                  positionedString,
                  style: TextStyle(
                    color: stringColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
