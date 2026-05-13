// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerService {
  static Future<File?> pick({ImageSource? source}) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      imageQuality: 80,
      maxWidth: 1920,
      maxHeight: 1080,
      source: source ?? ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<List<File>> pickMulti() async {
    final picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultipleMedia(
      imageQuality: 80,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    return pickedFiles.map((file) => File(file.path)).toList();
  }

  static Future<({File? image, String? path})> updateProfile({
    ImageSource? source,
  }) async {
    var image = await pick(source: source);
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = "profile.jpg";
      log("Image picked: ${directory.path}");
      final String savedPath = '${directory.path}/$fileName';
      final File newImage = await image.copy(savedPath);
      return (image: newImage, path: savedPath);
    }
    return (image: null, path: null);
  }
}
