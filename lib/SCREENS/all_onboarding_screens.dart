import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Auth_screens/create_account.dart';
import 'package:kakra/WIDGETS/reusable_button.dart';
import 'package:kakra/PROVIDERS/onboarding_provider.dart';
import 'package:kakra/SCREENS/Auth_screens/auth_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AllOnboardingScreens extends StatefulWidget {
  const AllOnboardingScreens({super.key});

  @override
  State<AllOnboardingScreens> createState() => _AllOnboardingScreensState();
}

class _AllOnboardingScreensState extends State<AllOnboardingScreens> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.round();
        _controller.dispose();
      });
    });
  }

  // Place this function in your screen/widget class
  void _completeOnboarding(BuildContext context) async {
    final authManager = AuthManager();
    await authManager.completeOnboarding();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/signup');
    }
  }

// Replace your existing navigation calls in AllOnboardingScreens with:

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                TheOnboardingPage(
                  image: 'lib/images/kk2.png',
                  title: "Find your community, No matter where you are",
                  description:
                      "Join a vibrant network of Africans in the diaspora, connecting you to people who share your journey, culture and passions.",
                ),

                TheOnboardingPage(
                  image: 'lib/images/kk1.png',
                  title: "Elevate your brand within the diaspora",
                  description:
                      "Promote your business services, connect with potential clients, and grow with Kakra's dedicated business features.",
                ),
                TheOnboardingPage(
                  image: 'lib/images/kk5.png',
                  title:
                      "Your hub for local knowledge and global conversations",
                  description:
                      "From local tips to global discussions, Kakra is your platform to share experiences, seek advice, and stay connected.",
                ),
                // Add your third onboarding screen here
              ],
            ),

// The modified button widget
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () => _completeOnboarding(context),
                child: const Text("Skip"),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const WormEffect(
                      activeDotColor: Colors.blue,
                      dotHeight: 8,
                      dotWidth: 30,
                      spacing: 4,
                    ),
                  ),
                  KakraButton(
                    text: "Next",
                    onPressed: () {
                      if (_currentPage < 2) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Navigate to the main app after onboarding
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//this method holds the design of all the onboardding screens UI
class TheOnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const TheOnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 200),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// Keep your ReusableButton class as it is

  
                