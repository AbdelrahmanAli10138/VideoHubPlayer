import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/model/services/image_picker_services.dart';
import 'package:video_hub/model/services/shared_prefs_services.dart';
import 'package:video_hub/model/services/show_image_options_services.dart';
import 'package:video_hub/presentation/Screens/history_screen.dart';
import 'package:video_hub/presentation/Screens/library_screen.dart';
import 'package:video_hub/presentation/Screens/settings_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_home_stack.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  File? pickedImage;
  final ImagePickerService _imagePickerService = ImagePickerService();

  final List<String> appBarTitles = [
    "Welcome Back",
    " Library",
    " History",
    "Settings",
  ];

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    loadImage();
    screens = [
      const HomeContent(),
      const LibraryScreen(),
      const HistoryScreen(),
      SettingsScreen(),
    ];
  }

  // load image function
  Future<void> loadImage() async {
    final path = await SharedPrefsService.getProfileImage();
    if (path != null) setState(() => pickedImage = File(path));
  }

  Future<void> fetchImageFromGallery() async {
    final file = await _imagePickerService.pickFromGallery();
    if (file != null) {
      setState(() => pickedImage = file);
      await SharedPrefsService.saveProfileImage(file.path);
    }
  }

  Future<void> fetchImageFromCamera() async {
    final file = await _imagePickerService.pickFromCamera();
    if (file != null) {
      setState(() => pickedImage = file);
      await SharedPrefsService.saveProfileImage(file.path);
    }
  }

  Future<void> deleteImage() async {
    await SharedPrefsService.deleteProfileImage();
    setState(() => pickedImage = null);
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
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageOptionsSheet(
                        pickedImage: pickedImage,
                        onDelete: deleteImage,
                        onPickFromGallery: fetchImageFromGallery,
                        onPickFromCamera: fetchImageFromCamera,
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: AppColors.primary,
                    backgroundImage: pickedImage != null
                        ? FileImage(pickedImage!)
                        : null,
                    child: pickedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              )
            : null,
      ),

      body: IndexedStack(index: currentIndex, children: screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; // تحديث الـ Index
          });
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

// 5. ويدجت محتوى صفحة الهوم (الجزء اللي فيه الزراير)
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // عشان لو الشاشة صغيرة ميعملش Overflow
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
