import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;
import 'package:video_hub/core/Constant/constant_strings.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Screens/home_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_onboarding_stack.dart';

class Onboarding3 extends StatelessWidget {
  Onboarding3({super.key});

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
            CustomOnBoardingWidget(imagePath: "assets/images/waveImage.png"),
            Gap(25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                ConstantStrings.onboardingTwoTitle,
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
                  ConstantStrings.onboardingTwoSubTitle,
                  style: TextStyle(
                    color: AppColors.subTitleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Gap(220),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pureOrangeColor,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get Started",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Gap(10),
                    Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
