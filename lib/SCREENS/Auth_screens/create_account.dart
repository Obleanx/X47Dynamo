import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Auth_screens/forgot_password.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/WIDGETS/registration_form.dart';
import 'package:kakra/WIDGETS/registration_tabs.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';
import 'package:kakra/WIDGETS/google_sign_up.dart';
import 'package:kakra/WIDGETS/terms_of_service.dart';
import 'package:kakra/widgets/reusable_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<RegistrationProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    if (provider.isSignUp) ...[
                      Center(
                        child: Image.asset('lib/images/kk4.png', height: 100),
                      ),
                      const Text(
                        "Welcome to Kakra",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Discover a network of Africans in the diaspora, connecting you to people who share your journey, culture and passions.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      Center(
                        child: Image.asset('lib/images/kk4.png', height: 100),
                      ),
                      const Text(
                        "Login into your account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "You have to login into your account to continue using Kakra services",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    const RegistrationTabs(),
                    const SizedBox(height: 20),
                    if (provider.isSignUp) ...[
                      const Center(
                        child: Text(
                          "Registration",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const RegistrationForm(),
                      const SizedBox(height: 40),
                      KakraButton(
                        text: "submit",
                        onPressed: () {
                          //provider.login(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        },
                      ),
                    ] else ...[
                      Column(
                        children: [
                          const Center(
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          CustomTextField(
                            label: "Email",
                            onSaved: (value) => provider.email = value,
                            validator: (value) => provider.validateEmail(value),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: "Password",
                            obscureText: true,
                            onSaved: (value) => provider.password = value,
                            validator: (value) =>
                                provider.validatePassword(value),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen()),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      KakraButton(
                        text: "Login",
                        onPressed: () {
                          provider.login(context);
                        },
                      ),
                    ],
                    const SizedBox(height: 70),
                    const GoogleSignUpButton(),
                    const SizedBox(height: 20),
                    const TermsOfService(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
