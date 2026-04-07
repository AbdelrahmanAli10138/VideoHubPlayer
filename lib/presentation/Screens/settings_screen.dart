import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/model/services/image_picker_services.dart';
import 'package:video_hub/model/services/shared_prefs_services.dart';
import 'package:video_hub/presentation/Screens/edit_profile_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_list_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // create a variable from file type to carry the path of the file
  File? profileImage;
  void initState() {
    super.initState();
    // run the function when the page is running
    loadProfileImage();
  }

  // Future function to load the image from shred preferences
  Future<void> loadProfileImage() async {
    final String? path = await SharedPrefsService.getProfileImage();

    if (path != null) {
      setState(() {});
      profileImage = File(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(size.height * 0.01),
              Center(
                child: Container(
                  height: size.height * 0.12,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.secondary, AppColors.darkBlue],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.primary,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : null,
                          child: profileImage == null
                              ? Icon(Icons.person_2_rounded)
                              : null,
                        ),

                        Gap(size.width * 0.05),

                        Text(
                          "Name",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(size.height * .03),

              Text(
                "ACCOUNT",
                style: TextStyle(
                  color: AppColors.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Gap(size.width * 0.05),
              // Edit profile list tile
              Container(
                height: size.height * 0.09,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.darkBlue],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          ).then((value) {
                            loadProfileImage();
                          }),
                      child: CustomListTile(
                        leading: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary,
                        ),
                        title: "Edit Profile",
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(size.height * .03),

              Text(
                "SUPPORT & ABOUT",
                style: TextStyle(
                  color: AppColors.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Gap(size.width * 0.05),

              Container(
                height: size.height * 0.18,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.darkBlue],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Email List Tile Widget.
                    CustomListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      title: "Email",
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                      ),
                    ),
                    // the divider widget to break from each widget with line
                    Divider(
                      color: AppColors.tertiary,
                      thickness: 0.5,
                      indent: 10,
                      endIndent: 10,
                    ),
                    // WhatsApp List Tile
                    CustomListTile(
                      leading: Icon(
                        Icons.message_outlined,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      title: " WhatsApp",
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(size.width * 0.09),
              Align(
                alignment: AlignmentGeometry.topCenter,

                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Gap(size.height * 0.01),
              Align(
                alignment: AlignmentGeometry.topCenter,

                child: Text(
                  "VERSION  1.0.0",
                  style: TextStyle(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
