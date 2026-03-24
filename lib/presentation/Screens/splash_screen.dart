import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Screens/onBoarding2.dart';
import 'package:video_hub/presentation/Screens/onBoarding3.dart';
import 'package:video_hub/presentation/Screens/on_boarding1.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  // عرفنا الـ controller هنا
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        alignment: Alignment.bottomCenter, // to make indicator in the bottom
        children: [
          PageView(
            reverse: false,

            controller: controller,
            children: [const OnBoarding1(), const Onboarding2(), Onboarding3()],
          ),

          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.18),
            child: SmoothPageIndicator(
              controller:
                  controller, // take the same controller of page view to change simulatiously
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 10,
                expansionFactor: 4,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.subTitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
