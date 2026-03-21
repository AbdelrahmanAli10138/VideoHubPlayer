import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Screens/onBoarding2.dart';
import 'package:video_hub/presentation/Screens/onBoarding3.dart';

class OnBoarding1 extends StatefulWidget {
  const OnBoarding1({super.key});

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Center(child: Image.asset("assets/images/yellowLogo.png")),
    );
  }
}
