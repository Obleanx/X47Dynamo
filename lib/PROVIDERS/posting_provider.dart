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

// post fetching method
  Future<void> createPost({BuildContext? context}) async {
    setLoading(true);
    try {
      String? imageUrl;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User is not authenticated.");
      }

      // Upload image if exists
      if (_imagePath != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child(user.uid)
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        await ref.putFile(File(_imagePath!));
        imageUrl = await ref.getDownloadURL();
      }

      // Create post in Firestore
      final postRef = await FirebaseFirestore.instance.collection('posts').add({
        'content': _content,
        'location': _location,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'userAvatar': user.photoURL,
      });

      // If you want to add to local state, you can do it optionally
      // This requires access to HomeProvider, which should be passed or accessed via Provider
      // For example:
      // Provider.of<HomeProvider>(context, listen: false).addNewPost(
      //   content: _content,
      //   imagePath: imageUrl,
      //   location: _location,
      // );

      // Reset state
      _content = '';
      _location = '';
      _imagePath = null;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating post: $e');
      }

      // Remove context-dependent code
      // You might want to handle errors differently based on your UI
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
