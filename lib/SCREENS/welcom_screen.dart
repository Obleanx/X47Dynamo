import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/all_onboarding_screens.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    // Start a timer to navigate after 10 seconds
    Timer(const Duration(seconds: 4), () {
      // Navigate to the OnboardingScreen after 10 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AllOnboardingScreens()),
      );
    });
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
