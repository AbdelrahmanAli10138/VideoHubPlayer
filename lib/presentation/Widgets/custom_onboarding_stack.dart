import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';

class CustomOnBoardingWidget extends StatelessWidget {
  CustomOnBoardingWidget({super.key, required this.imagePath});
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: AlignmentGeometry.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            height: height * 0.40,
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.secondary,
              gradient: LinearGradient(
                colors: [AppColors.skyBlue, AppColors.darkBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 140),
          child: Container(
            height: height * 0.30,
            width: width * 0.8,
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
