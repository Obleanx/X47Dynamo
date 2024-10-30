import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> posts = [
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

  final List<Map<String, dynamic>> _townSquarePosts = [
    // Your town square posts data

    {
      'avatar': 'lib/images/kk8.png',
      'group': 'Blacks in UK',
      'content': 'Happy to connect with everyone!',
      'time': '5 min ago',
      'image': 'lib/images/kk13.png',
    },
    {
      'avatar': 'lib/images/kk10.png',
      'group': 'Leeds Group',
      'content': 'Here are some amazing photos from my trip!',
      'time': '10 min ago',
      'image': 'lib/images/kk14.png',
    },
    {
      'avatar': 'lib/images/kk6.png',
      'group': 'London Group',
      'content': 'Looking forward to our next meetup!',
      'time': '20 min ago',
      'image': 'lib/images/kk7.png',
    },
  ];

  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  List<Map<String, dynamic>> get post =>
      _selectedCategoryIndex == 1 ? _townSquarePosts : posts;

  void setSelectedCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }
  // Add more methods as needed
}
