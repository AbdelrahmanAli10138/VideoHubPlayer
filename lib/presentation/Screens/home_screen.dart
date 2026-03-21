import 'package:disk_space_plus/disk_space_plus.dart';
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
  double? free;
  double? total;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadStorage();
  }

  void loadStorage() async {
    // DiskSpacePlus members are instance members, so we need to instantiate it.
    final diskSpacePlus = DiskSpacePlus();
    free = await diskSpacePlus.getFreeDiskSpace;
    total = await diskSpacePlus.getTotalDiskSpace;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundColor: AppColors.secondary),
        ),
        title: Text("Welcome Back, $userName"),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),

      endDrawer: Drawer(backgroundColor: AppColors.secondary),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
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
                  CustomHomeStack(
                    backgroundColor: AppColors.tertiary,
                    positionedicon: Icon(
                      Icons.video_camera_back,
                      size: 38,
                      color: AppColors.black,
                    ),
                    positionedString: "Capture Video",
                    stringColor: AppColors.black,
                  ),
                  Spacer(),
                  CustomHomeStack(
                    backgroundColor: AppColors.darkBlue,
                    positionedString: "Record Audio",
                    stringColor: AppColors.tertiary,
                    positionedicon: Icon(
                      Icons.mic_none_rounded,
                      size: 38,
                      color: AppColors.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.darkBlue,
        currentIndex: _currentIndex,
        selectedIconTheme: IconThemeData(color: AppColors.tertiary),
        onTap: (value) {
          setState(() {});
          _currentIndex = value;
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.tertiary,
        selectedLabelStyle: TextStyle(
          color: AppColors.tertiary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedItemColor: AppColors.whiteColor,
        unselectedLabelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: AppColors.whiteColor,
        ),

        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        ],
      ),
    );
  }
}
