import 'package:flutter/material.dart';

class OnboardingProvider with ChangeNotifier {
  // Example of state management in OnboardingProvider
  bool _isReady = false;

  bool get isReady => _isReady;

  void setReady(bool value) {
    _isReady = value;
    notifyListeners();
  }
}
