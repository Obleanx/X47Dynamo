// lib/providers/floating_button_provider.dart
import 'package:flutter/material.dart';

class FloatingButtonProvider with ChangeNotifier {
  bool _isMenuOpen = false;
  bool get isMenuOpen => _isMenuOpen;

  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    notifyListeners();
  }
}
