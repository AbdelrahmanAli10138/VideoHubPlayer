import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/model/services/image_picker_services.dart';
import 'package:video_hub/model/services/shared_prefs_services.dart';
import 'package:video_hub/presentation/Screens/full_image_screen.dart';
import 'package:video_hub/presentation/Screens/history_screen.dart';
import 'package:video_hub/presentation/Screens/library_screen.dart';
import 'package:video_hub/presentation/Screens/settings_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_home_stack.dart';
import 'package:video_hub/presentation/Widgets/custom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [
    LibraryScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];
  final String userName = "Abdelrahman";
  int currentIndex = 0;
  File? pickedImage;

  final ImagePickerService _imagePickerService = ImagePickerService();

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  // Load image from shared preferences
  Future<void> loadImage() async {
    final path = await SharedPrefsService.getProfileImage();
    if (path != null) {
      setState(() {
        pickedImage = File(path);
      });
    }
  }

  // Pick image from gallery
  Future<void> fetchImageFromGallery() async {
    final file = await _imagePickerService.pickFromGallery();
    if (file != null) {
      setState(() => pickedImage = file);
      await SharedPrefsService.saveProfileImage(file.path);
    }
  }

  // Pick image from camera
  Future<void> fetchImageFromCamera() async {
    final file = await _imagePickerService.pickFromCamera();
    if (file != null) {
      setState(() => pickedImage = file);
      await SharedPrefsService.saveProfileImage(file.path);
    }
  }

  // Delete image
  Future<void> deleteImage() async {
    await SharedPrefsService.deleteProfileImage();
    setState(() {
      pickedImage = null;
    });
  }

  // Show bottom sheet for image options
  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text(
                  "View Image",
                  style: TextStyle(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (pickedImage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullImageScreen(image: pickedImage!),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text(
                  "Gallery",
                  style: TextStyle(color: AppColors.tertiary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  fetchImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined),
                title: Text(
                  "Camera",
                  style: TextStyle(color: AppColors.tertiary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  fetchImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  "Delete Image",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  deleteImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: showImageOptions,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondary,
              backgroundImage: pickedImage == null
                  ? null
                  : FileImage(pickedImage!),
            ),
          ),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
      ),
    );
  }
}
