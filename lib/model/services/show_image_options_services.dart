import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Screens/full_image_screen.dart';

class ImageOptionsSheet extends StatelessWidget {
  final File? pickedImage;
  final VoidCallback onDelete;
  final VoidCallback onPickFromGallery;
  final VoidCallback onPickFromCamera;

  const ImageOptionsSheet({
    super.key,
    required this.pickedImage,
    required this.onDelete,
    required this.onPickFromGallery,
    required this.onPickFromCamera,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          // View Image
          ListTile(
            leading: const Icon(Icons.remove_red_eye),
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
                    builder: (_) => FullImageScreen(image: pickedImage!),
                  ),
                );
              }
            },
          ),
          // Pick from Gallery
          ListTile(
            leading: const Icon(Icons.photo),
            title: Text("Gallery", style: TextStyle(color: AppColors.tertiary)),
            onTap: () {
              Navigator.pop(context);
              onPickFromGallery();
            },
          ),
          // Pick from Camera
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text("Camera", style: TextStyle(color: AppColors.tertiary)),
            onTap: () {
              Navigator.pop(context);
              onPickFromCamera();
            },
          ),
          // Delete Image
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              "Delete Image",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
