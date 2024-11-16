import 'package:flutter/foundation.dart';

class ProductImageProvider extends ChangeNotifier {
  String _currentImage;

  ProductImageProvider([this._currentImage = 'lib/images/kr13.png']);

  String get currentImage => _currentImage;

  void updateImage(String newImage) {
    if (_currentImage != newImage) {
      _currentImage = newImage;
      notifyListeners();
    }
  }
}
