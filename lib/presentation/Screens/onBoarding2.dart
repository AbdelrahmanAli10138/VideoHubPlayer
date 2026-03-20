import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_hub/core/Constant/constant_strings.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Widgets/custom_onboarding_stack.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.blackColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            CustomOnBoardingWidget(imagePath: "assets/images/micImage.jpg"),
            Gap(25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                ConstantStrings.onboardingOneTitle,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(20),
            Align(
              alignment: AlignmentGeometry.center,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  ConstantStrings.onboardingOneSubTitle,
                  style: TextStyle(
                    color: AppColors.subTitleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
