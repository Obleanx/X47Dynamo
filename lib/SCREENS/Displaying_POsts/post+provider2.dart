import 'dart:io';
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

  // Modified getPosts method to ensure all posts are fetched
  Stream<QuerySnapshot> getPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Optional: Add a method to fetch a specific user's posts
  Stream<QuerySnapshot> getUserPosts(String userId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

Future<Stream<QuerySnapshot>> getLocationPrioritizedPosts() async {
  try {
    // Get current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is not authenticated.");
    }

    // Fetch user document
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final userData = userDoc.data() ?? {};

    // Get current user's details
    String currentLocation = userData['currentLocation'] ?? '';
    String registeredLocation = userData['location'] ?? '';
    String currentCountry = userData['currentCountry'] ?? '';
    String registeredCountry = userData['registeredCountry'] ?? '';

    // If no location information is available, return default posts
    if (currentLocation.isEmpty) {
      return FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }

    // Split location into components (assuming format like "City, State, Country")
    List<String> currentLocationParts = currentLocation.split(', ');
    String currentCity =
        currentLocationParts.isNotEmpty ? currentLocationParts[0] : '';
    String currentState =
        currentLocationParts.length > 1 ? currentLocationParts[1] : '';

    // Create a query with location-based priority
    Query postsQuery = FirebaseFirestore.instance.collection('posts');

    // Priority 1: Posts from the exact current city
    var cityPosts = postsQuery
        .where('location', isEqualTo: currentLocation)
        .orderBy('timestamp', descending: true);

    // Priority 2: Posts from nearby towns/settlements in the same state
    var nearbyPosts = postsQuery
        .where('location', isNotEqualTo: currentLocation)
        .where('location', isGreaterThanOrEqualTo: currentState)
        .where('location', isLessThan: currentState + '\uf8ff')
        .orderBy('location')
        .orderBy('timestamp', descending: true);

    // Priority 3: Posts from the same state
    var statePosts = postsQuery
        .where('location', isGreaterThanOrEqualTo: currentState)
        .where('location', isLessThan: currentState + '\uf8ff')
        .orderBy('location')
        .orderBy('timestamp', descending: true);

    // Priority 4: Posts from the same country
    var countryPosts = postsQuery
        .where('location', isGreaterThanOrEqualTo: currentCountry)
        .where('location', isLessThan: currentCountry + '\uf8ff')
        .orderBy('location')
        .orderBy('timestamp', descending: true);

    // Priority 5: If current country is different from registered country, fetch posts from registered country
    Stream<QuerySnapshot> registeredCountryPosts = postsQuery
        .where('location', isGreaterThanOrEqualTo: registeredCountry)
        .where('location', isLessThan: registeredCountry + '\uf8ff')
        .orderBy('location')
        .orderBy('timestamp', descending: true)
        .snapshots();

    // Combine the streams (Note: This is a simplified approach and might need more sophisticated merging)
    return registeredCountryPosts;
  } catch (e) {
    print('Error fetching location-prioritized posts: $e');

    // Fallback to default posts retrieval
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
