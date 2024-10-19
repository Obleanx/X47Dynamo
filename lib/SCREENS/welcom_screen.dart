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
    Timer(const Duration(seconds: 10), () {
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
          child: Image.asset('lib/images/kk4.png'), // Your app image
        ),
      ),
    );
  }
}
