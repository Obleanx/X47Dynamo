// seller_provider.dart
import 'package:flutter/material.dart';

class SellerHQProvider with ChangeNotifier {
  String? productName;
  String? price;
  String? description;
  String? category;
  String? condition;
  String? selectedImage;
  int photoCount = 0;

  bool get isFormValid {
    return productName != null &&
        price != null &&
        description != null &&
        category != null &&
        condition != null &&
        selectedImage != null;
  }

  void updateField(String field, String value) {
    switch (field) {
      case 'productName':
        productName = value;
        break;
      case 'price':
        price = value;
        break;
      case 'description':
        description = value;
        break;
      case 'category':
        category = value;
        break;
      case 'condition':
        condition = value;
        break;
    }
    notifyListeners();
  }

  void setImage(String imagePath) {
    selectedImage = imagePath;
    photoCount++;
    notifyListeners();
  }
}
