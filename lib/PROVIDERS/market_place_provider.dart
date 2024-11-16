import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Home_screens/market%20place/market_home_screen.dart';

// Product Provider
class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Facewash',
      price: 2500,
      assetimage: 'lib/images/k.png',
      category: 'Beauty',
    ),
    Product(
      id: '2',
      name: 'UK Bright Yellow Long Sleeves',
      price: 15000,
      assetimage: 'lib/images/kr.png',
      category: 'Fashion',
    ),
    Product(
      id: '3',
      name: 'Kids Educational Toy Set',
      price: 8500,
      assetimage: 'lib/images/kr3.png',
      category: 'Toys',
    ),
    Product(
      id: '4',
      name: 'Professional Kitchen Knife Set',
      price: 12000,
      assetimage: 'lib/images/kr9.png',
      category: 'Kitchen',
    ),
    Product(
      id: '5',
      name: 'Nike Air Max Sneakers',
      price: 45000,
      assetimage: 'lib/images/kr12.png',
      category: 'Shoes',
    ),
    Product(
      id: '6',
      name: 'Office Desk Organizer',
      price: 5500,
      assetimage: 'lib/images/kr11.png',
      category: 'Office',
    ),
  ];

  List<Product> get products => [..._products];

  void filterByCategory(String category) {
    // Implement category filtering logic
    notifyListeners();
  }
}
