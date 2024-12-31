import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/all_onboarding_screens.dart';
import 'package:kakra/SCREENS/Auth_screens/auth_manager.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthManager _authManager = AuthManager();

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(
        const Duration(seconds: 4)); // Keep the splash duration

    if (mounted) {
      final String initialRoute = await _authManager.getInitialRoute();

      Navigator.pushReplacementNamed(context, initialRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2486C2),
              Color(0xFF2BBCE7),
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.6, // Circular container size
            height: MediaQuery.of(context).size.width *
                0.6, // Same height for a perfect circle
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Circular shape for the container
              color: Colors.white, // White background
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Subtle shadow color
                  blurRadius: 10, // Shadow blur
                  spreadRadius: 2, // Shadow spread
                  offset: Offset(0, 5), // Shadow position
                ),
              ],
              border: Border.all(
                color: Colors.white, // White border
                width: 3, // Border width
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Add padding to shrink the image
              child: ClipOval(
                child: Image.asset(
                  'lib/images/kk4.png', // Your image path
                  fit: BoxFit
                      .cover, // Ensure the image fills its available space
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
