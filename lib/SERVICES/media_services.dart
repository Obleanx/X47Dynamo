import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ImageSourceType {
  camera,
  gallery,
}

class MediaService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> pickImage({
    required ImageSourceType source,
    required BuildContext context,
    int? imageQuality,
    bool cropImage = false,
  }) async {
    try {
      XFile? pickedFile;

      if (source == ImageSourceType.camera) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: imageQuality ?? 50,
        );
      } else {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality ?? 50,
        );
      }

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      _showErrorSnackBar(context, 'Error picking image: ${e.toString()}');
      return null;
    }
  }

  // Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Show image source bottom sheet
  Future<void> showImageSourceBottomSheet({
    required BuildContext context,
    required Function(File?) onImageSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await pickImage(
                    source: ImageSourceType.camera,
                    context: context,
                  );
                  onImageSelected(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await pickImage(
                    source: ImageSourceType.gallery,
                    context: context,
                  );
                  onImageSelected(image);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
