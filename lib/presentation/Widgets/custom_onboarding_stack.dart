import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';

class CustomOnBoardingWidget extends StatelessWidget {
  CustomOnBoardingWidget({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Container(
            height: 360,
            width: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [AppColors.skyBlue, AppColors.darkBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Container(
            height: 260,
            width: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.whiteColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
