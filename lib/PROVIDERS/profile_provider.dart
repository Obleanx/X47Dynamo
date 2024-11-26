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

  // Getters
  String? get profileImageUrl => _profileImageUrl;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  bool get isLoading => _isLoading;

  // Setters
  void setProfileImageUrl(String url) {
    _profileImageUrl = url;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

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

      if (kDebugMode) {
        print('Fetching data for user: ${user?.uid}');
      }

      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          if (kDebugMode) {
            print('User data found: ${userData.data()}');
          }

          _firstName = userData.data()?['firstName']?.toString() ?? '';
          _lastName = userData.data()?['lastName']?.toString() ?? '';
          _profileImageUrl = userData.data()?['profileImageUrl']?.toString();

          if (kDebugMode) {
            print('First Name: $firstName');
            print('Last Name: $lastName');
            print('Profile URL: $_profileImageUrl');
          }

          notifyListeners();
        } else {
          if (kDebugMode) {
            print('No user data found in Firestore');
          }
        }
      } else {
        if (kDebugMode) {
          print('No authenticated user found');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
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
