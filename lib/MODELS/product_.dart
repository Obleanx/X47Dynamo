import 'package:flutter/material.dart';

class ViewProduct {
  final String name;
  final double price;
  final String description;
  final List<String> images;
  final String sellerName;
  final String sellerJoinDate;

  ViewProduct({
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.sellerName,
    required this.sellerJoinDate,
  });

  String? get userId => null;

  get sellerEmail => null;
}

// ViewModel
class SellerDetailsViewModel extends ChangeNotifier {
  // Add your state management logic here
}
