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
    Timer(const Duration(seconds: 5), () {
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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Shadow color
                  blurRadius: 20, // Shadow blur
                  spreadRadius: 5, // Shadow spread
                  offset: Offset(0, 10), // Shadow position
                ),
              ],
              borderRadius:
                  BorderRadius.circular(15), // Optional rounded corners
              border: Border.all(
                color: Colors.white, // Border color
                width: 3, // Border width
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'lib/images/kk4.png', // Your app image
                fit: BoxFit.contain, // Scale the image proportionally
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
              ),
            ),
          ),
        ),
      ),
    );
  }
}
