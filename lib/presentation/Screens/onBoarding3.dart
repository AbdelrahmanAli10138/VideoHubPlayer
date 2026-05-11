import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:video_hub/core/Constant/constant_strings.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Screens/home_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_onboarding_stack.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomOnBoardingWidget(
                    imagePath: "assets/images/waveImage.png",
                  ),
                  const Gap(25),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [AppColors.primary, AppColors.tertiary],
                      ).createShader(bounds),
                      child: Text(
                        ConstantStrings.onboardingTwoTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const Gap(20),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [AppColors.whiteColor, AppColors.skyBlue],
                      ).createShader(bounds),
                      child: Text(
                        ConstantStrings.onboardingTwoSubTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔽 زرار "Get Started" المعدل
            Padding(
              padding: EdgeInsets.only(
                bottom: size.height * 0.03,
                left: size.width * 0.1,
                right: size.width * 0.1,
              ),
              child: SizedBox(
                width: double.infinity,
                height: size.height * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                    ),
                  ),
                  // التعديل هنا: إضافة async لحفظ البيانات
                  onPressed: () async {
                    // 1. حفظ قيمة "FirstTime" كـ false في ذاكرة الجهاز
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool("FirstTime", false);

                    // 2. الانتقال لصفحة الـ HomeScreen ومسح كل صفحات الـ Onboarding السابقة
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) =>
                            false, 
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.05,
                        ),
                      ),
                      const Gap(10),
                      Icon(
                        Icons.arrow_forward,
                        size: size.width * 0.05,
                        color: AppColors.whiteColor,
                      ),
                    ],
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
