import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegistrationProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? email;
  String? africanPhoneNumber;
  String? foreignPhoneNumber;
  String? gender;
  String? password;
  String? confirmPassword;

  bool isSignUp = true;

  void setIsSignUp(bool value) {
    isSignUp = value;
    notifyListeners();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,14}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  void createAccount(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Here you would typically send the data to your backend
      // For now, we'll just print the data
      if (kDebugMode) {
        print('Creating account with:');
      }
      if (kDebugMode) {
        print('First Name: $firstName');
      }
      if (kDebugMode) {
        print('Last Name: $lastName');
      }
      if (kDebugMode) {
        print('Email: $email');
      }
      if (kDebugMode) {
        print('African Phone Number: $africanPhoneNumber');
      }
      if (kDebugMode) {
        print('Foreign Phone Number: $foreignPhoneNumber');
      }
      if (kDebugMode) {
        print('Gender: $gender');
      }
      if (kDebugMode) {
        print('Password: $password');
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
    }
  }

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Here you would typically send the login request to your backend
      // For now, we'll just print the data
      if (kDebugMode) {
        print('Logging in with:');
      }
      if (kDebugMode) {
        print('Email: $email');
      }
      if (kDebugMode) {
        print('Password: $password');
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully!')),
      );
    }
  }
}
