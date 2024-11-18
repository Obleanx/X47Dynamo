import 'package:flutter/material.dart';

// Product Model
class Product4 {
  final String name;
  final double price;
  final String imagePath;

  Product4({required this.name, required this.price, required this.imagePath});
}

// Product Provider
class ProductProvider4 extends ChangeNotifier {
  List<Product4> products = [
    Product4(name: 'Gift Box', price: 24.99, imagePath: 'lib/images/kr.13.png'),
    Product4(name: 'Phone', price: 299.99, imagePath: 'lib/images/kr12.png'),
    Product4(name: 'Hand Wash', price: 5.50, imagePath: 'lib/images/kr11.png'),
    Product4(name: 'Hand Wash', price: 5.50, imagePath: 'lib/images/kr11.png'),
    Product4(name: 'Hand Wash', price: 5.50, imagePath: 'lib/images/kr11.png'),
    Product4(name: 'Gift Box', price: 24.99, imagePath: 'lib/images/kr.13.png'),
    Product4(name: 'Gift Box', price: 24.99, imagePath: 'lib/images/kr.13.png'),
    Product4(
        name: 'Headphones', price: 79.99, imagePath: 'lib/images/kr10.png'),
  ];
}
