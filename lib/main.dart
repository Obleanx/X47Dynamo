import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/ListingProvider.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/PROVIDERS/categories_provider.dart';
import 'package:kakra/PROVIDERS/home_provider.dart';
import 'package:kakra/PROVIDERS/market_place_provider.dart';
import 'package:kakra/PROVIDERS/messages_provider.dart';
import 'package:kakra/PROVIDERS/onboarding_provider.dart';
import 'package:kakra/PROVIDERS/product_description_provider.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:kakra/PROVIDERS/sellerlisting_provider.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/messages.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/profile.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';
import 'package:kakra/SCREENS/Home_screens/post/creating_post.dart';
import 'package:kakra/SCREENS/all_onboarding_screens.dart';
import 'package:kakra/SCREENS/welcom_screen.dart';
import 'package:kakra/SERVICES/options.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => FloatingButtonProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ChatMessageProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductImageProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => ListingProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider4()),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider()..initializeProfile(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure profile data is loaded when app starts
    Future.microtask(() {
      context.read<ProfileProvider>().fetchUserData();
    });

    return MaterialApp(
      title: 'Kakra App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
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
        '/messages': (context) => const ChatMessageScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/create-post': (context) => PostCreationScreen(),
      },
    );
  }
}
