import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;
import 'package:url_launcher/url_launcher_string.dart' show LaunchMode;
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/model/services/shared_prefs_services.dart';
import 'package:video_hub/presentation/Screens/edit_profile_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_list_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = "User";
  // create a variable from file type to carry the path of the file
  File? profileImage;
  void initState() {
    super.initState();
    // run the function when the page is running
    loadProfileImage();
    loadUserName();
  }

  // Future function to load the image from shred preferences
  Future<void> loadProfileImage() async {
    final String? path = await SharedPrefsService.getProfileImage();

    if (path != null) {
      setState(() {});
      profileImage = File(path);
    }
  }

  Future<void> loadUserName() async {
    final String? path = await SharedPrefsService.getUserName();
    if (path != null) {
      setState(() {
        userName = path;
      });
    }
  }

  // function to send an email for support
  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: "mailto",
      path: "abdoaliahmed2005@gmail.com",
      queryParameters: {"subject": "Support Request - Video Hub"},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print("Sorry You could not launch the email");
    }
  }

  // function to send an whats app message for support
  Future<void> sendWhatsApp() async {
    final String phoneNumber = "201030048550";
    final String message =
        "Hello i want to contact to the technical support for problem";
    final Uri whatsUri = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );
    if (!await launchUrl(whatsUri, mode: LaunchMode.externalApplication)) {
      throw "could not launch Whats App";
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
                          userName,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
                            // this function to tell to app after pushing to other page transfer the functions data in then function
                          ).then((value) {
                            // must call these function to pass the data from page to another page
                            loadProfileImage();
                            loadUserName();
                          }),
                      child: CustomListTile(
                        leading: Icon(
                          Icons.person,
                          size: 30,
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
                    InkWell(
                      onTap: sendEmail,
                      child: CustomListTile(
                        leading: Icon(
                          Icons.email_outlined,
                          size: 30,
                          color: AppColors.primary,
                        ),
                        title: "Email",
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                        ),
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
                    InkWell(
                      onTap: sendWhatsApp,
                      child: CustomListTile(
                        leading: Icon(
                          Icons.message_outlined,
                          size: 30,
                          color: AppColors.primary,
                        ),
                        title: " WhatsApp",
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                        ),
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
