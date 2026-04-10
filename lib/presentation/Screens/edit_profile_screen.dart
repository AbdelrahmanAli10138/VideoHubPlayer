import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/model/services/image_picker_services.dart';
import 'package:video_hub/model/services/shared_prefs_services.dart';
import 'package:video_hub/model/services/show_image_options_services.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  void initState() {
    super.initState();
    loadImage();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  File? pickedImage;
  final ImagePickerService _imagePickerService = ImagePickerService();

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
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(size.height * 0.02),
                Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: Text(
                    "Change Your Profile Image",
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Gap(size.height * 0.02),
                Center(
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
                      radius: 80,
                      backgroundColor: AppColors.primary,
                      backgroundImage: pickedImage != null
                          ? FileImage(pickedImage!)
                          : null,
                      child: pickedImage == null
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                Gap(size.height * 0.05),
                Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: Text(
                    "Change Your Name",
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(size.height * 0.03),
                TextFormField(
                  style: TextStyle(color: AppColors.whiteColor),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Enter The New Name",

                    fillColor: AppColors.darkBlue,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter Your Name";
                    }
                    if (value.trim().length < 3) {
                      return "Un Valid Name";
                    }
                    return null;
                  },
                ),
                Gap(size.height * 0.02),
                SizedBox(
                  height: size.height * 0.05,
                  width: size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await SharedPrefsService.setUserName(
                          nameController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Name Saved!")),
                        );
                      }
                    },
                    child: Text(
                      "Change Name",
                      style: TextStyle(color: AppColors.tertiary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
