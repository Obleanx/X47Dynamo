import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

//this code is what is responsible for user beign able to create post.
class PostProvider with ChangeNotifier {
  String _content = '';
  String _location = '';
  String? _imagePath;
  bool _isLoading = false;

  // Getters
  String get content => _content;
  String get location => _location;
  String? get imagePath => _imagePath;
  bool get isLoading => _isLoading;

  // Setters
  void setContent(String value) {
    _content = value;
    notifyListeners();
  }

  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void setImagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Create Post Method
  Future<void> createPost(
      BuildContext scaffoldContext, BuildContext navigationContext) async {
    if (_content.trim().isEmpty) {
      return;
    }

    try {
      // Set loading state
      setLoading(true);

      String? imageUrl;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User is not authenticated.");
      }

      // Fetch user details from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String userName = userDoc.data()?['firstName'] ?? 'Anonymous';

      // Upload post image if exists
      if (_imagePath != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child(user.uid)
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        await ref.putFile(File(_imagePath!));
        imageUrl = await ref.getDownloadURL();
      }

      // Get user's saved location from Firestore
      String? userLocation = userDoc.data()?['location'];

      // Create post in Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'content': _content,
        'location': userLocation ?? _location,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userName': userName,
      });

      // Reset state
      _content = '';
      _location = '';
      _imagePath = null;
      notifyListeners();

      // Navigate to home screen after post creation
      if (navigationContext.mounted) {
        Navigator.pushReplacementNamed(navigationContext, '/home');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating post: $e');
      }
    } finally {
      // Reset loading state
      setLoading(false);
    }
  }
}
