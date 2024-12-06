import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/seller_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewProduct {
  final String name;
    final String sellerId; // New field

  final double price;
  final String description;
  final List<String> images;
  final String sellerName;
  final String sellerJoinDate;

  const ViewProduct({
    required this.name,
        required this.sellerId,

    required this.price,
    required this.description,
    required this.images,
    required this.sellerName,
    required this.sellerJoinDate,
  });
}