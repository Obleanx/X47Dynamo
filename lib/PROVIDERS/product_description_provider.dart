import 'package:flutter/material.dart';

// Product Image Provider
class ProductImageProvider extends ChangeNotifier {
  String _currentImage = '';

  String get currentImage => _currentImage;

  void updateImage(String newImage) {
    _currentImage = newImage;
    notifyListeners();
  }
}
