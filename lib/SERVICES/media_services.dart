import 'dart:io';
import 'package:flutter/foundation.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          imageQuality: imageQuality ?? 100, // Increased to maximum quality
          preferredCameraDevice:
              CameraDevice.rear, // Using rear camera for better quality
          maxWidth: 2048, // Maximum width for high quality
          maxHeight: 2048, // Maximum height for high quality
        );
      } else {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality ?? 100, // Increased to maximum quality
          maxWidth: 2048, // Maximum width for high quality
          maxHeight: 2048, // Maximum height for high quality
        );
      }

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      _showErrorSnackBar(context, 'Error picking image: ${e.toString()}');
      return null;
    }
  }

  // Added uploadImage method
  Future<String?> uploadImage({
    required File imageFile,
    required BuildContext context,
    String? customPath,
  }) async {
    try {
      // Get current user
      final user = _auth.currentUser;
      if (user == null) {
        _showErrorSnackBar(context, 'User not logged in');
        return null;
      }

      // Generate unique filename
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create storage reference with user-specific path
      final storageRef = _storage
          .ref()
          .child('profile_pictures')
          .child(user.uid)
          .child(fileName);

      // Create upload task
      final uploadTask = await storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': user.uid,
            'timestamp': DateTime.now().toString(),
          },
        ),
      );

      if (uploadTask.state == TaskState.success) {
        // Get download URL
        final downloadURL = await storageRef.getDownloadURL();
        return downloadURL;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Upload error: $e');
      } // Debug print
      _showErrorSnackBar(context, 'Error uploading image: ${e.toString()}');
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

// Show image source dialog on the screen
  Future<void> showImageSourceDialog({
    required BuildContext context,
    required Function(File?) onImageSelected,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose an Option',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: const Icon(Icons.camera_alt, color: Colors.blue),
                ),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await pickImage(
                    source: ImageSourceType.camera,
                    context: context,
                    imageQuality: 100,
                  );
                  onImageSelected(image);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.2),
                  child: const Icon(Icons.photo_library, color: Colors.green),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await pickImage(
                    source: ImageSourceType.gallery,
                    context: context,
                    imageQuality: 100,
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
