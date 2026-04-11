import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'shared_prefs_services.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    await SharedPrefsService.saveProfileImage(image.path);
    return File(image.path);
  }

  Future<File?> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    await SharedPrefsService.saveProfileImage(image.path);
    return File(image.path);
  }

  Future<File?> pickVideoFromCamera() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      return File(video.path);
    }
  }
}
