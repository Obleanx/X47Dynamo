import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakra/SERVICES/options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakra/SCREENS/welcom_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/PROVIDERS/home_provider.dart';
import 'WIDGETS/MARKET_PLACE/backend_products.dart';
import 'package:kakra/PROVIDERS/ListingProvider.dart';
import 'package:kakra/PROVIDERS/posting_provider.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:kakra/PROVIDERS/messages_provider.dart';
import 'package:kakra/PROVIDERS/categories_provider.dart';
import 'package:kakra/PROVIDERS/onboarding_provider.dart';
import 'package:kakra/SCREENS/all_onboarding_screens.dart';
import 'package:kakra/PROVIDERS/market_place_provider.dart';
import 'package:kakra/PROVIDERS/sellerlisting_provider.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:kakra/PROVIDERS/product_description_provider.dart';
import 'package:kakra/SCREENS/Displaying_POsts/post+provider2.dart';
import 'package:kakra/SCREENS/Home_screens/post/creating_post.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/profile.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/messages.dart';

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
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider2()),
        ChangeNotifierProvider(create: (_) => FirebaseProductProvider()),

        // Add this line
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

// Flutter Build Commands Cheat Sheet

// 1. Basic Build Commands:
// Debug APK
// flutter build apk

// Release APK
// flutter build apk --release

// Profile APK
// flutter build apk --profile

// 2. Architecture-Specific Builds:
// ARM 64-bit
// flutter build apk --target-platform=android-arm64

// ARM 32-bit
// flutter build apk --target-platform=android-arm

// 3. Split APK (Recommended for Release)
// flutter build apk --release --split-per-abi

// 4. Web Build
// flutter build web

// 5. iOS Build
// flutter build ios

// 6. Windows Build
// flutter build windows

// 7. macOS Build
// flutter build macos

// 8. Linux Build
// flutter build linux

// 9. Advanced Build Options:
// Build with specific flavor
// flutter build apk --flavor production

// Build with dart define
// flutter build apk --dart-define=FLAVOR=production

// Specify output directory
// flutter build apk --output-dir=/path/to/your/directory

// 10. Pre-Build Cleanup
// flutter clean   // Always run before building

// 11. Get Dependencies
// flutter pub get

// 12. Verbose Build (for debugging)
// flutter build apk --verbose

// 13. Build with specific dart SDK
// flutter build apk --dart-sdk=/path/to/dart-sdk

// Pro Tips:
// - Ensure keystore is configured for release builds
// - Check android/app/build.gradle for signing configurations
// - Use --split-per-abi for optimized app size on different devices


