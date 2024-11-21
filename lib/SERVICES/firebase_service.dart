import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
      throw e.message ?? 'An error occurred during registration.';
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw 'Error sending verification email.';
    }
  }

  // Save user data to Firestore
  Future<void> saveUserData({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String africanPhoneNumber,
    required String foreignPhoneNumber,
    required String gender,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'africanPhoneNumber': africanPhoneNumber,
        'foreignPhoneNumber': foreignPhoneNumber,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
        'isEmailVerified': false,
      });
    } catch (e) {
      throw 'Error saving user data.';
    }
  }

  // Check if email is verified
  Future<bool> checkEmailVerification() async {
    try {
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } catch (e) {
      throw 'Error checking email verification.';
    }
  }

  // Update email verification status in Firestore
  Future<void> updateEmailVerificationStatus(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isEmailVerified': true,
      });
    } catch (e) {
      throw 'Error updating verification status.';
    }
  }
}
