import 'package:flutter/material.dart';

class ListingProvider with ChangeNotifier {
  bool isSold = false;
  String selectedDays = '7 days';
  int currentImageIndex = 0;

  void toggleSold() {
    isSold = !isSold;
    notifyListeners();
  }

  void setSelectedDays(String days) {
    selectedDays = days;
    notifyListeners();
  }

  void setImageIndex(int index) {
    currentImageIndex = index;
    notifyListeners();
  }
}
