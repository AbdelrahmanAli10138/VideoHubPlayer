import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/model/services/image_picker_services.dart';
import 'package:video_hub/model/services/shared_prefs_services.dart';
import 'package:video_hub/presentation/Screens/settings_screen.dart';
import 'package:video_hub/presentation/Screens/library_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_home_stack.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  File? pickedImage;

  final List<String> appBarTitles = ["Welcome Back", " Library", "Settings"];

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    displayProfileImage();
    screens = [const HomeContent(), const LibraryScreen(), SettingsScreen()];
  }

  Future<void> displayProfileImage() async {
    final String? path = await SharedPrefsService.getProfileImage();
    if (path != null) {
      setState(() {
        pickedImage = File(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      // changing appBar
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        // changing depends on current index of bottom navigation bar
        title: Text(appBarTitles[currentIndex]),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        leading: currentIndex == 0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: AppColors.primary,
                  backgroundImage: pickedImage != null
                      ? FileImage(pickedImage!)
                      : null,
                  child: pickedImage == null
                      ? const Icon(Icons.person, size: 20, color: Colors.white)
                      : null,
                ),
              )
            : null,
      ),

      body: IndexedStack(index: currentIndex, children: screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          // to show the image in the screen
          if (index == 0) {
            displayProfileImage();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.secondary,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          const Gap(20),
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
                const Spacer(),
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
    );
  }
}
