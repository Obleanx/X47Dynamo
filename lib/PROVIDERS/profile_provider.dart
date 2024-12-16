import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileProvider extends ChangeNotifier {
  String? _profileImageUrl;
  String? _firstName;
  String? _lastName;
  bool _isLoading = false;
  bool? _isVerified;
  bool? get isVerified => _isVerified;
  String? _location;

  // Getters
  String? get profileImageUrl => _profileImageUrl;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  bool get isLoading => _isLoading;
  String? get location => _location;

  // Setters
  void setProfileImageUrl(String url) {
    _profileImageUrl = url;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  // Setter methods

  // Initialize profile
  Future<void> initializeProfile() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserData();
      } else {
        _clearUserData();
      }
    });
  }

  void _clearUserData() {
    _firstName = null;
    _lastName = null;
    _profileImageUrl = null;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    try {
      setLoading(true);
      final user = FirebaseAuth.instance.currentUser;

      print('=============== Fetching User Data ===============');
      print('Current User UID: ${user?.uid}');
      print('Current User Email: ${user?.email}');

      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        print('Firestore Document Exists: ${userData.exists}');

        if (userData.exists) {
          final data = userData.data();
          print('Full User Data: $data');

          _firstName = data?['firstName']?.toString() ?? '';
          _lastName = data?['lastName']?.toString() ?? '';
          _profileImageUrl = data?['profileImageUrl']?.toString();

          print('Extracted First Name: $_firstName');
          print('Extracted Last Name: $_lastName');
          print('Extracted Profile Image URL: $_profileImageUrl');

          notifyListeners();
        } else {
          print('No user data found in Firestore for UID: ${user.uid}');
        }
      } else {
        print('No authenticated user found');
      }
    } catch (e) {
      print('Error in fetchUserData: $e');
    } finally {
      setLoading(false);
    }
  }

  // Update user data
  Future<void> updateUserData({
    String? firstName,
    String? lastName,
    String? profileImageUrl,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final updates = <String, dynamic>{};

        if (firstName != null) {
          updates['firstName'] = firstName;
          _firstName = firstName;
        }
        if (lastName != null) {
          updates['lastName'] = lastName;
          _lastName = lastName;
        }
        if (profileImageUrl != null) {
          updates['profileImageUrl'] = profileImageUrl;
          _profileImageUrl = profileImageUrl;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updates);

        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user data: $e');
      }
    }
  }
}
