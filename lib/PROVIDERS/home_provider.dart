import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> posts = [
    {
      'avatar': 'lib/images/kk6.png',
      'name': 'Ola',
      'group': 'Leeds group',
      'content':
          'Handcrafted by Nala creations, this vibrant jewelset celebrates African heritage',
      'time': '38min',
      'image': 'lib/images/kk7.png',
    },
    {
      'avatar': 'lib/images/kk8.png',
      'name': 'John',
      'group': 'Manchester group',
      'content': 'Exploring the rich culinary traditions of West Africa',
      'time': '1h',
      'image': 'lib/images/kk9.png',
    },
    {
      'avatar': 'lib/images/kk10.png',
      'name': 'Sarah',
      'group': 'London group',
      'content':
          'Discussing the impact of African literature on global culture',
      'time': '2h',
    },
    {
      'avatar': 'lib/images/kk8.png',
      'name': 'Sarah',
      'group': 'London group',
      'content':
          'Discussing the impact of African literature on global culture',
      'time': '2h',
    },
    {
      'avatar': 'lib/images/kk8.png',
      'name': 'John',
      'group': 'Manchester group',
      'content': 'Exploring the rich culinary traditions of West Africa',
      'time': '1h',
      'image': 'lib/images/kk11.png',
    },
    // Add more posts as needed
  ];

  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  void setSelectedCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  // Add more methods as needed
}
