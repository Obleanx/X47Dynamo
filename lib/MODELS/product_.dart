import 'package:flutter/material.dart';

class ViewProduct {
  final String name;

  final double price;
  final String description;
  final List<String> images;
  final String sellerName;
  final String sellerJoinDate;

  final String? sellerId; // Optional sellerId
  final String? sellerEmail; // Optional sellerEmail
  ViewProduct({
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.sellerName,
    required this.sellerJoinDate,
    this.sellerId, // Optional
    this.sellerEmail, // Optional
  });

  // Getter for userId, can return sellerId or other logic
  String? get userId => sellerId;

  // Explicitly typed getter for sellerEmail
  String? get email => sellerEmail;
}

// ViewModel
class SellerDetailsViewModel extends ChangeNotifier {
  // Add your state management logic here
}
