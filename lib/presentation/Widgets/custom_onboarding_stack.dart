import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';

class CustomOnBoardingWidget extends StatelessWidget {
  const CustomOnBoardingWidget({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.12),
          child: Container(
            height: height * 0.30,
            width: width * 0.75,
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
          padding: EdgeInsets.only(top: height * 0.17),
          child: Container(
            height: height * 0.22,
            width: width * 0.55,
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
