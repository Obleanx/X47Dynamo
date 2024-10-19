import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/PROVIDERS/onboarding_provider.dart';
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

        // You can add more providers here
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
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/onboarding': (context) => AllOnboardingScreens(),
      },
    );
  }
}
