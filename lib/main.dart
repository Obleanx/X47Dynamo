import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/PROVIDERS/home_provider.dart';
import 'package:kakra/PROVIDERS/messages_provider.dart';
import 'package:kakra/PROVIDERS/onboarding_provider.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/messages.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';
import 'package:kakra/SCREENS/all_onboarding_screens.dart';
import 'package:kakra/SCREENS/welcom_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => FloatingButtonProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ChatMessageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kakra App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        // Add these theme settings for consistent colors
        primaryColor: const Color(0xFF2486C2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2486C2),
          secondary: const Color(0xFF2BBCE7),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/onboarding': (context) => const AllOnboardingScreens(),
        '/home': (context) => const HomeScreen(),
        '/messages': (context) => ChatMessageScreen(),
      },
    );
  }
}
