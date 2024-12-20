import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class PostProvider2 with ChangeNotifier {
  String _content = '';
  String _location = '';
  String? _imagePath;
  bool _isLoading = false;
  double _searchRadiusKm = 10.0; // Default search radius in kilometers
  final _firestore = FirebaseFirestore.instance;

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

  // Modified createPost method to include GeoFirePoint
  Future<DocumentReference?> createPost({BuildContext? context}) async {
    setLoading(true);
    try {
      String? imageUrl;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User is not authenticated.");
      }

      // Fetch user document with location data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      final userData = userDoc.data() ?? {};

      // Extract location data
      final latitude = userData['latitude'] as double?;
      final longitude = userData['longitude'] as double?;

      if (latitude == null || longitude == null) {
        throw Exception("Location data is missing.");
      }

      // Create GeoFirePoint
      final geoPoint = _geo.point(latitude: latitude, longitude: longitude);

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

      // Create post with location data
      final postRef = await _firestore.collection('posts').add({
        'content': _content,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userName':
            '${userData['firstName'] ?? 'Anonymous'} ${userData['lastName'] ?? ''}'
                .trim(),
        'userProfilePic': userData['profileImageUrl'] ?? '',
        'location': userData['location'] ?? 'Unknown Location',
        'position': geoPoint.data, // GeoFirePoint data
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

  // Modified getPosts method to fetch location-based posts
  Stream<List<DocumentSnapshot>> getPosts() async* {
    try {
      // Get current user's location
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      final userData = userDoc.data() ?? {};
      final latitude = userData['latitude'] as double?;
      final longitude = userData['longitude'] as double?;

      if (latitude == null || longitude == null) {
        // Fallback to regular post fetching
        yield* _firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs);
        return;
      }

      // Create a GeoFirePoint for the current user's location
      final center = _geo.point(latitude: latitude, longitude: longitude);

      // Query posts based on location
      yield* _geo
          .collection(collectionRef: _firestore.collection('posts'))
          .within(
            center: center,
            radius: _searchRadiusKm,
            field: 'position',
            strictMode: true,
          );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching posts: $e');
      }
      // Fallback to regular post fetching
      yield* _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    }
  }

  // Method to fetch a specific user's posts (unchanged)
  Stream<QuerySnapshot> getUserPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
