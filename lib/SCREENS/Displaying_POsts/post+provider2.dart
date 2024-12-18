import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostProvider2 with ChangeNotifier {
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

  // Post creation method
  Future<DocumentReference?> createPost({BuildContext? context}) async {
    setLoading(true);
    try {
      String? imageUrl;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User is not authenticated.");
      }

      // Fetch user document directly
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data() ?? {};

      // Extract user details
      String firstName = userData['firstName'] ?? 'Anonymous';
      String lastName = userData['lastName'] ?? '';
      String userProfilePic = userData['profileImageUrl'] ?? '';
      String userLocation = userData['location'] ?? 'Unknown Location';
      String userName = '$firstName $lastName'.trim();

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

      // Create post in Firestore
      final postRef = await FirebaseFirestore.instance.collection('posts').add({
        'content': _content,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userName': userName,
        'userProfilePic': userProfilePic,
        'location': userLocation,
      });

      _content = '';
      _imagePath = null;

      return postRef;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating post: $e');
      }
      return null;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  // Get all posts method
  Stream<QuerySnapshot> getPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get location-prioritized posts method
  Future<Stream<QuerySnapshot>> getLocationPrioritizedPosts() async {
    try {
      // Fetch current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User is not authenticated.");

      // Fetch user document
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data() ?? {};

      // Extract location fields
      String currentLocation = userData['currentLocation'] ?? '';
      String stateRegion = userData['state/region'] ?? '';
      String country = userData['country'] ?? '';
      String permanentAddress = userData['permanentAddress'] ?? '';
      String hometownInAfrica = userData['hometownInAfrica'] ?? '';

      // Fallback: No location info, fetch all posts
      if (currentLocation.isEmpty && stateRegion.isEmpty && country.isEmpty) {
        return FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots();
      }

      // Base posts query
      var postsQuery = FirebaseFirestore.instance.collection('posts');

      // Priority 1: Posts matching exact current location
      var currentLocationPosts = postsQuery
          .where('location', isEqualTo: currentLocation)
          .orderBy('timestamp', descending: true)
          .snapshots();

      // Priority 2: Posts matching the same state/region
      var statePosts = postsQuery
          .where('location', isGreaterThanOrEqualTo: stateRegion)
          .where('location', isLessThan: stateRegion + '\uf8ff')
          .orderBy('timestamp', descending: true)
          .snapshots();

      // Priority 3: Posts matching the same country
      var countryPosts = postsQuery
          .where('location', isGreaterThanOrEqualTo: country)
          .where('location', isLessThan: country + '\uf8ff')
          .orderBy('timestamp', descending: true)
          .snapshots();

      // Priority 4: Posts matching the hometown in Africa
      var hometownPosts = postsQuery
          .where('location', isEqualTo: hometownInAfrica)
          .orderBy('timestamp', descending: true)
          .snapshots();

      // Priority 5: Posts from the permanent address
      var permanentAddressPosts = postsQuery
          .where('location', isEqualTo: permanentAddress)
          .orderBy('timestamp', descending: true)
          .snapshots();

      // Combine prioritized streams
      return Rx.concat([
        currentLocationPosts,
        statePosts,
        countryPosts,
        hometownPosts,
        permanentAddressPosts
      ]);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching location-prioritized posts: $e');
      }

      // Fallback: Return default posts
      return FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }
}
