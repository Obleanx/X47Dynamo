import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if user has completed onboarding
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  // Mark onboarding as complete
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  // Check if user is logged in and email is verified
  bool isUserLoggedIn() {
    final user = _auth.currentUser;
    return user != null && user.emailVerified;
  }

  // Get initial route based on auth and onboarding status
  Future<String> getInitialRoute() async {
    if (!await isOnboardingComplete()) {
      return '/onboarding';
    }

    if (isUserLoggedIn()) {
      return '/home';
    }

    return '/signup';
  }
}
