// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2486C2);
  static const Color secondary = Color(0xFF2BBCE7);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
