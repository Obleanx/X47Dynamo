import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakra/WIDGETS/reusable_button.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';
import 'package:kakra/SCREENS/Auth_screens/create_account.dart';
import 'package:kakra/SCREENS/Auth_screens/create_newpassword.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Create Password'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Image.asset('lib/images/kk4.png', height: 100),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Enter your email address correctly to retrieve your password.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Image.asset('lib/images/kkpass.png', height: 150),
                  ),
                  const SizedBox(height: 40),
                  Consumer<RegistrationProvider>(
                    builder: (context, provider, child) {
                      return CustomTextField2(
                        label: "Email",
                        controller: _emailController, // Use the controller
                        onChanged: (value) {
                          // Add onChanged
                          if (kDebugMode) {
                            print('Email changed to: $value');
                          } // Debug print
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  KakraButton(
                    text: "Submit",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (kDebugMode) {
                          print(
                              'Email being submitted: ${_emailController.text.trim()}');
                        }

                        bool success = await handlePasswordReset(
                          context,
                          _emailController.text.trim(),
                        );

                        if (success && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreatePasswordScreen(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> handlePasswordReset(BuildContext context, String email) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (kDebugMode) {
        print('Attempting to send reset email to: $email');
      } // Add this debug line
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('FirebaseAuthException: ${e.code} - ${e.message}');
      } // Add detailed error logging
      if (context.mounted) {
        Navigator.pop(context);
      }

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        default:
          errorMessage =
              'Error: ${e.message}'; // Show actual Firebase error message
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('General error: $e');
      } // Add general error logging
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }
}

class CustomTextField2 extends StatelessWidget {
  final String label;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextField2({
    Key? key,
    required this.label,
    this.onSaved,
    this.validator,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 12), // Reduce vertical padding
        isDense: true, // Makes the field more compact
      ),
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
