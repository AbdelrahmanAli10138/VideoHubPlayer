import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Screens/home_screen.dart';
import 'package:video_hub/presentation/Screens/library_screen.dart';
import 'package:video_hub/presentation/Screens/settings_screen.dart';
import 'package:video_hub/presentation/Screens/settings_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currentIndex != 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
        break;
      case 1:
        if (currentIndex != 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LibraryScreen()),
          );
        }
        break;
      case 2:
        if (currentIndex != 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SettingsScreen()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.darkBlue,
      currentIndex: currentIndex,
      selectedIconTheme: IconThemeData(color: AppColors.tertiary),
      onTap: (index) => _onTap(context, index),
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
      items: const [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(
          label: "Library",
          icon: Icon(Icons.video_library),
        ),
        BottomNavigationBarItem(label: "History", icon: Icon(Icons.history)),
        BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings)),
      ],
    );
  }
}
