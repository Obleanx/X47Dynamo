import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostProvider2 with ChangeNotifier {
  // Keep track of current location
  String _currentLocation = '';
  String _content = '';
  String _location = '';
  String? _imagePath;
  bool _isLoading = false;
  double _searchRadiusKm = 10.0; // Default search radius in kilometers
  final _firestore = FirebaseFirestore.instance;
  String _errorMessage = '';

  // Current user location data
  double? _currentLatitude;
  double? _currentLongitude;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Getters
  String get content => _content;
  String get location => _location;
  String? get imagePath => _imagePath;

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

  // Add new properties for location tracking
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  // Constants for distance ranges (in kilometers)
  static const double _immediateRange = 5.0; // Posts within 5km
  static const double _nearbyRange = 20.0; // Posts within 20km
  static const double _distantRange = 50.0; // Posts within 50km

  // Initialize location tracking
  Future<void> initializeLocationTracking() async {
    // Request permission and start location updates
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Start listening to location updates
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100, // Update every 100 meters
        ),
      ).listen((Position position) {
        _currentPosition = position;
        notifyListeners(); // Trigger UI update when location changes
      });
    }
  }

  // Dispose of location tracking
  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  // Modified createPost method
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
        'latitude': latitude,
        'longitude': longitude,
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

  // Modified getPosts method with dynamic location prioritization
  Stream<List<QueryDocumentSnapshot>> getPosts() {
    try {
      return _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asyncMap((querySnapshot) async {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            print('No authenticated user found');
            return querySnapshot.docs;
          }

          // Get current user's location from their document
          final userDoc = await _firestore
              .collection('users')
              .doc(user.uid)
              .get()
              .catchError((error) {
            print('Error fetching user document: $error');
            return null;
          });

          if (userDoc == null || !userDoc.exists) {
            print('User document not found');
            return querySnapshot.docs;
          }

          final userData = userDoc.data() ?? {};
          _currentLocation = userData['location'] ?? '';
          _currentLatitude = userData['latitude'] as double?;
          _currentLongitude = userData['longitude'] as double?;

          if (_currentLatitude == null || _currentLongitude == null) {
            print('User coordinates not found');
            return querySnapshot.docs;
          }

          print('Current location: $_currentLocation');

          // Process and sort posts
          final processedPosts = querySnapshot.docs.map((doc) {
            final postData = doc.data() as Map<String, dynamic>;
            final postLocation = postData['location'] as String? ?? '';
            final postLat = postData['latitude'] as double?;
            final postLon = postData['longitude'] as double?;

            // Calculate priority and distance
            int priority = _calculatePriority(_currentLocation, postLocation);
            double distance = double.infinity;

            if (postLat != null &&
                postLon != null &&
                _currentLatitude != null &&
                _currentLongitude != null) {
              distance = Geolocator.distanceBetween(
                    _currentLatitude!,
                    _currentLongitude!,
                    postLat,
                    postLon,
                  ) /
                  1000; // Convert to kilometers
            }

            return {
              'doc': doc,
              'priority': priority,
              'distance': distance,
              'timestamp':
                  postData['timestamp'] as Timestamp? ?? Timestamp.now(),
            };
          }).toList();

          // Sort posts based on priority and distance
          processedPosts.sort((a, b) {
            // First compare by priority
            int priorityCompare =
                (a['priority'] as int).compareTo(b['priority'] as int);
            if (priorityCompare != 0) return priorityCompare;

            // If same priority, compare by distance
            int distanceCompare =
                (a['distance'] as double).compareTo(b['distance'] as double);
            if (distanceCompare != 0) return distanceCompare;

            // If same distance, sort by timestamp (newer first)
            return (b['timestamp'] as Timestamp)
                .compareTo(a['timestamp'] as Timestamp);
          });

          // Return sorted documents
          return processedPosts
              .map((post) => post['doc'] as QueryDocumentSnapshot)
              .toList();
        } catch (e) {
          print('Error in filtering posts: $e');
          return querySnapshot.docs;
        }
      });
    } catch (e) {
      print('Error in getPosts stream creation: $e');
      _errorMessage = e.toString();
      notifyListeners();
      return Stream.value([]);
    }
  }

  // Helper method to calculate priority dynamically
  int _calculatePriority(String userLocation, String postLocation) {
    if (userLocation.isEmpty || postLocation.isEmpty) return 999;

    // Split locations into components
    List<String> userComponents =
        userLocation.toLowerCase().split(',').map((e) => e.trim()).toList();
    List<String> postComponents =
        postLocation.toLowerCase().split(',').map((e) => e.trim()).toList();

    // Check for exact location match
    if (userLocation.toLowerCase() == postLocation.toLowerCase()) {
      return 0;
    }

    // Check if same city/area
    if (userComponents.first == postComponents.first) {
      return 1;
    }

    // Check if same state/region
    if (userComponents.length > 1 &&
        postComponents.length > 1 &&
        userComponents[1] == postComponents[1]) {
      return 2;
    }

    // Check if same country
    if (userComponents.length > 2 &&
        postComponents.length > 2 &&
        userComponents[2] == postComponents[2]) {
      return 3;
    }

    // Different country
    return 4;
  }
}
