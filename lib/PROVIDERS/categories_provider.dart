// categories_provider.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakra/WIDGETS/contents_filter/categories_screen.dart';

class CategoriesProvider with ChangeNotifier {
  final List<CategoryItem> categories = [
    CategoryItem(
      name: 'Electronics & Gadgets',
      icon: FontAwesomeIcons.desktop,
      subCategories: ['Phones', 'Laptops', 'Smart Devices'],
    ),
    CategoryItem(
      name: 'Fashion',
      icon: FontAwesomeIcons.shirt,
      subCategories: [
        'Bags',
        'Shoes',
        'Male Shoes',
        'Dress',
        'Caps',
        'Wristwatches',
        'Others'
      ],
    ),
    CategoryItem(
      name: 'Home & Living',
      icon: Icons.home_outlined,
      subCategories: [
        'Decore',
        'Home Appliances',
        'Furniture',
        'Kitchen Essentials'
      ],
    ),
    CategoryItem(
      name: 'Services & Offers',
      icon: FontAwesomeIcons.handshake,
      subCategories: ['Tutoring', 'Repairs'],
    ),
    CategoryItem(
      name: 'Health & Wellness',
      icon: FontAwesomeIcons.hospitalUser,
      subCategories: [
        'Fitness Equipments',
        'Beauty Products',
        'Supplements',
        'Personal Care'
      ],
    ),
    CategoryItem(
      name: 'Automotive',
      icon: FontAwesomeIcons.car,
      subCategories: ['Vehicles', 'Bicycles', 'Bikes'],
    ),
  ];

  final ValueNotifier<bool> isPublishEnabled = ValueNotifier(false);

  void validateForm() {
    // Implement form validation logic
    // Update isPublishEnabled value
    isPublishEnabled.value = true; // Set this dynamically
  }

  void toggleCategory(int index) {
    categories[index].isExpanded = !categories[index].isExpanded;
    notifyListeners();
  }
}
