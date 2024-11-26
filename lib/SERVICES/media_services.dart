import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:provider/provider.dart';

enum ImageSourceType {
  camera,
  gallery,
}

class MediaService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add the missing _showErrorSnackBar method
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Add the missing pickImage method
  Future<File?> pickImage({
    required ImageSourceType source,
    required BuildContext context,
    int? imageQuality,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source == ImageSourceType.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: imageQuality ?? 100,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
      _showErrorSnackBar(context, 'Error picking image: ${e.toString()}');
      return null;
    }
  }

  // Existing deletePreviousProfilePicture method
  Future<void> deletePreviousProfilePicture(String userId) async {
    try {
      final ListResult result = await _storage
          .ref()
          .child('profile_pictures')
          .child(userId)
          .listAll();

      for (var item in result.items) {
        await item.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting previous profile picture: $e');
      }
    }
  }

  // Existing uploadImage method
  Future<String?> uploadImage({
    required File imageFile,
    required BuildContext context,
    String? customPath,
  }) async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.setLoading(true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showErrorSnackBar(context, 'User not logged in');
        return null;
      }

      await deletePreviousProfilePicture(user.uid);

      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageRef = _storage
          .ref()
          .child('profile_pictures')
          .child(user.uid)
          .child(fileName);

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
        final downloadURL = await storageRef.getDownloadURL();
        provider.setProfileImageUrl(downloadURL);
        provider.setLoading(false);
        return downloadURL;
      }

      provider.setLoading(false);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Upload error: $e');
      }
      provider.setLoading(false);
      _showErrorSnackBar(context, 'Error uploading image: ${e.toString()}');
      return null;
    }
  }

  // Existing showImageSourceDialog method
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
