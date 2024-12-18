import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileProvider with ChangeNotifier {
  // Form data storage
  final Map<String, String> _formData = {};

  // Validation state
  bool _isValidating = false;
  bool _isLoading = false;
  Map<String, String> _validationErrors = {};

  // Getters
  Map<String, String> get formData => _formData;
  bool get isValidating => _isValidating;
  bool get isLoading => _isLoading;
  Map<String, String> get validationErrors => _validationErrors;

  // Validation methods
  String? validateName(String? value, {bool isRequired = false}) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }
    if (value != null && value.trim().length < 2) {
      return 'Must be at least 2 characters';
    }
    return null;
  }

  // String? validateEmail(String? value) {
  // if (value == null || value.trim().isEmpty) {
  // return 'Email is required';
  // }
  // final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  // if (!emailRegex.hasMatch(value.trim())) {
  // return 'Enter a valid email address';
  // }
  // return null;
  // }

  // String? validatePhoneNumber(String? value, {bool isRequired = false}) {
  // if (isRequired && (value == null || value.trim().isEmpty)) {
  // return 'Phone number is required';
  // }
  // if (value != null && value.isNotEmpty) {
  // Remove any non-digit characters
  // final cleanedNumber = value.replaceAll(RegExp(r'\D'), '');
  // if (cleanedNumber.length < 10 || cleanedNumber.length > 15) {
  // return 'Invalid phone number length';
  // }
  // }
  // return null;
  // }

  String? validateLocation(String? value, {bool isRequired = false}) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return 'Location is required';
    }
    if (value != null && value.trim().length < 2) {
      return 'Location must be at least 2 characters';
    }
    return null;
  }

  String? validateSkillsOrInterests(String? value, {int maxItems = 5}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    final items = value.split(',').map((e) => e.trim()).toList();
    if (items.length > maxItems) {
      return 'Maximum $maxItems items allowed';
    }
    return null;
  }

  // Method to update form data
  void updateFormData(String key, String? value) {
    if (value != null) {
      _formData[key] = value;
    } else {
      _formData.remove(key);
    }
    notifyListeners();
  }

  // Comprehensive form validation
  bool validateEntireForm() {
    _isValidating = true;
    _validationErrors.clear();

    // Validate each field
    _validateField(
        'firstName', validateName(_formData['firstName'], isRequired: true));
    _validateField(
        'lastName', validateName(_formData['lastName'], isRequired: true));
    // _validateField('email', validateEmail(_formData['email']));
    // _validateField(
    // 'africanPhone', validatePhoneNumber(_formData['africanPhone']));
    // _validateField(
    // 'foreignPhone', validatePhoneNumber(_formData['foreignPhone']));
    _validateField('location', validateLocation(_formData['location']));
    _validateField('state', validateLocation(_formData['state']));
    _validateField('country', validateLocation(_formData['country']));
    _validateField('skills', validateSkillsOrInterests(_formData['skills']));
    _validateField(
        'interests', validateSkillsOrInterests(_formData['interests']));

    _isValidating = false;
    notifyListeners();

    return _validationErrors.isEmpty;
  }

  // Helper method to add validation errors
  void _validateField(String fieldName, String? errorMessage) {
    if (errorMessage != null) {
      _validationErrors[fieldName] = errorMessage;
    }
  }

  // Save user profile method
  Future<bool> saveUserProfile(BuildContext context) async {
    // Perform comprehensive validation
    if (!validateEntireForm()) {
      // Show validation error
      _showValidationErrorSnackBar(context);
      return false;
    }

    // Start loading
    _isLoading = true;
    notifyListeners();

    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Prepare user data for update
      final userData = {
        'firstName': _formData['firstName'],
        'lastName': _formData['lastName'],
        // 'email': _formData['email'],
        // 'africanPhone': _formData['africanPhone'] ?? '',
        // 'foreignPhone': _formData['foreignPhone'] ?? '',
        'background': _formData['background'] ?? '',
        'gender': _formData['gender'] ?? '',
        'language': _formData['language'] ?? '',
        'location': _formData['location'] ?? '',
        'state': _formData['state'] ?? '',
        'country': _formData['country'] ?? '',
        'permanentAddress': _formData['permanentAddress'] ?? '',
        'interests': _formData['interests'] ?? '',
        'skills': _formData['skills'] ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(userData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      return true;
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
      return false;
    } finally {
      // Stop loading
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to show validation errors
  void _showValidationErrorSnackBar(BuildContext context) {
    final errorMessages = _validationErrors.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please correct the following errors:\n$errorMessages'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Clear form data
  void clearForm() {
    _formData.clear();
    _validationErrors.clear();
    notifyListeners();
  }
}
