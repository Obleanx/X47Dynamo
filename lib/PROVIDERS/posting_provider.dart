import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Post Provider
class PostProvider with ChangeNotifier {
  String _content = '';
  String _location = '';
  String? _imagePath;
  bool _isLoading = false;

  String get content => _content;
  String get location => _location;
  String? get imagePath => _imagePath;
  bool get isLoading => _isLoading;

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

// post fetching method from the database.
  Future<void> createPost({BuildContext? context}) async {
    setLoading(true);
    try {
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

      // Get user's first name
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
      final postRef = await FirebaseFirestore.instance.collection('posts').add({
        'content': _content,
        'location':
            userLocation ?? _location, // Use saved location or current input
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userName': userName,
      });

      // Reset state
      _content = '';
      _location = '';
      _imagePath = null;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating post: $e');
      }
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
