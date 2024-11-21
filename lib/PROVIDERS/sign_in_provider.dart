import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? email;
  String? password;
  bool isLoading = false;
  String? errorMessage;

  Future<User?> signIn(BuildContext context) async {
    // Reset previous error
    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      // Attempt to sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // Check if email is verified
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        // Send verification email if not verified
        await userCredential.user!.sendEmailVerification();
        errorMessage =
            'Please verify your email. A verification email has been sent.';
        isLoading = false;
        notifyListeners();
        return null;
      }

      // Successfully logged in
      isLoading = false;
      notifyListeners();

      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      isLoading = false;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }

      notifyListeners();
      return null;
    } catch (e) {
      // Handle any other unexpected errors
      isLoading = false;
      errorMessage = 'An unexpected error occurred.';
      notifyListeners();
      return null;
    }
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // Basic email validation regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // You can add more password validation if needed
    return null;
  }
}
