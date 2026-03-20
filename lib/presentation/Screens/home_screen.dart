import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Widgets/custom_home_stack.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "Abdelrahman";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(backgroundColor: AppColors.skyBlue),
        title: Text("Welcome Back, $userName"),
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      endDrawer: Drawer(backgroundColor: AppColors.darkBlue),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text(
                "Start Recording",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            Gap(20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CustomHomeStack(backgroundColor: AppColors.skyBlue),
                  Spacer(),
                  CustomHomeStack(backgroundColor: AppColors.darkBlue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
