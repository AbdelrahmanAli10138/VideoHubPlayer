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
        decoration: BoxDecoration(color: AppColors.secondary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            CustomOnBoardingWidget(imagePath: "assets/images/micImage.jpg"),
            Gap(25),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColors.primary, AppColors.tertiary],
              ).createShader(bounds),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    ConstantStrings.onboardingOneTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Gap(20),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColors.whiteColor, AppColors.skyBlue],
              ).createShader(bounds),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    ConstantStrings.onboardingOneSubTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // very important
                    ),
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
