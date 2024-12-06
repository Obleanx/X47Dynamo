import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakra/WIDGETS/contents_filter/categories_screen.dart';
// categories_provider.dart

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
      name: 'Musical Instruments',
      icon: FontAwesomeIcons.guitar,
      subCategories: [
        'Guitars',
        'Keyboards',
        'Cellos & Violins',
        'Drums',
        'Wind Instruments',
        'DJ Equipment',
        'Audio Interfaces',
        'Amplifiers',
        'Accessories'
      ],
    ),
    CategoryItem(
      name: 'Books & Education',
      icon: FontAwesomeIcons.book,
      subCategories: [
        'Textbooks',
        'Novels',
        'Academic Books',
        'Comics',
        'Language Learning',
        'Study Materials',
        'Stationery'
      ],
    ),
    CategoryItem(
      name: 'Sports & Outdoors',
      icon: FontAwesomeIcons.basketball,
      subCategories: [
        'Team Sports',
        'Gym Equipment',
        'Outdoor Gear',
        'Camping',
        'Fishing',
        'Cycling Gear',
        'Sportswear'
      ],
    ),
    CategoryItem(
      name: 'Gaming & Entertainment',
      icon: FontAwesomeIcons.gamepad,
      subCategories: [
        'Video Games',
        'Gaming Consoles',
        'Board Games',
        'Collectibles',
        'Gaming Accessories',
        'Home Entertainment'
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
