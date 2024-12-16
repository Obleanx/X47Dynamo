import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakra/SERVICES/firebase_service.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';

class RegistrationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  final TextEditingController passwordController = TextEditingController();

  String? firstName;
  String? lastName;
  String? email;

  String? africanPhoneNumber;
  String? foreignPhoneNumber;
  String? gender;
  String? password;
  String? confirmPassword;
  String? errorMessage;

  bool isLoading = false;

  bool isSignUp = true;

  void setIsSignUp(bool value) {
    isSignUp = value;
    notifyListeners();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    // Check for minimum length
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    // Check for numbers
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Name cannot contain numbers';
    }
    // Check for special characters
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Name cannot contain special characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // More comprehensive email regex
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateAfricanPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    // Remove any spaces or formatting
    String cleanedValue = value.replaceAll(RegExp(r'\s+'), '');

    // Specific country code to max digit mappings
    final countryCodeRules = {
      '+234': 10, // Nigeria (10 digits after country code)
      '+233': 9, // Ghana (9 digits after country code)
      '+254': 9, // Kenya (9 digits after country code)
      '+255': 9, // Tanzania (9 digits after country code)
      '+256': 9, // Uganda (9 digits after country code)
      '+257': 8, // Burundi (8 digits after country code)
      '+258': 9, // Mozambique (9 digits after country code)
      '+260': 9, // Zambia (9 digits after country code)
      '+261': 9, // Madagascar (9 digits after country code)
      '+262': 9, // Reunion (9 digits after country code)
      '+263': 9, // Zimbabwe (9 digits after country code)
    };

    // Check if the number is only digits
    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return 'Phone number must contain only digits';
    }

    // Default to Nigerian country code if not specified in the custom TextField
    String countryCode = '+234';

    // Check if the number of digits matches the country's rule
    if (cleanedValue.length != countryCodeRules[countryCode]) {
      return 'Phone number must be ${countryCodeRules[countryCode]} digits long for ${countryCode.substring(1)} country';
    }

    return null;
  }

  String? validateForeignPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    // Remove any spaces or formatting
    String cleanedValue = value.replaceAll(RegExp(r'\s+'), '');

    // Specific country code to max digit mappings
    final countryCodeRules = {
      '+44': 10, // UK (10 digits after country code)
      '+353': 9, // Ireland (9 digits after country code)
      '+33': 9, // France (9 digits after country code)
      '+49': 10, // Germany (10 digits after country code)
      '+1': 10, // US/Canada (10 digits after country code)
    };

    // Check if the number is only digits
    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return 'Phone number must contain only digits';
    }

    // Default to UK country code if not specified in the custom TextField
    String countryCode = '+44';

    // Check if the number of digits matches the country's rule
    if (cleanedValue.length != countryCodeRules[countryCode]) {
      return 'Phone number must be ${countryCodeRules[countryCode]} digits long for ${countryCode.substring(1)} country';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 4) {
      return 'Password must be at least 8 characters long';
    }
    // Check for uppercase letters
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for lowercase letters
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    // Check for numbers
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    // Check for special characters
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      // Use the controller's text instead of password field
      return 'Passwords do not match';
    }
    return null;
  }

  bool isValidPassword(String password) {
    return password.length >= 4 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  void createFirstAccount(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Here you would typically send the data to the backend
      if (kDebugMode) {
        print('Creating account with:');
        print('First Name: $firstName');
        print('Last Name: $lastName');
        print('Email: $email');
        print('African Phone Number: $africanPhoneNumber');
        print('Foreign Phone Number: $foreignPhoneNumber');
        print('Gender: $gender');
        print('Password: $password');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
    }
  }

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (kDebugMode) {
        print('Logging in with:');
        print('Email: $email');
        print('Password: $password');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully!')),
      );
    }
  }

  Future<void> createUserAccount(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      // Save form data
      formKey.currentState!.save();

      // Create user account
      final userCredential =
          await _firebaseService.createUserWithEmailAndPassword(
        email!,
        password!,
      );

      // Send verification email
      await _firebaseService.sendEmailVerification();

      // Save user data to Firestore
      await _firebaseService.saveUserData(
        userId: userCredential.user!.uid,
        firstName: firstName!,
        lastName: lastName!,
        email: email!,
        africanPhoneNumber: africanPhoneNumber ?? '',
        foreignPhoneNumber: foreignPhoneNumber ?? '',
        gender: gender ?? '',
      );

      // Show verification dialog
      if (context.mounted) {
        await _showVerificationDialog(context, userCredential.user!.uid);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _showVerificationDialog(
      BuildContext context, String userId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verify Your Email'),
          content: const Text(
            'A verification email has been sent. Please check your email and verify your account to continue.',
          ),
          actions: [
            TextButton(
              child: const Text('I\'ve Verified'),
              onPressed: () async {
                try {
                  bool isVerified =
                      await _firebaseService.checkEmailVerification();
                  if (isVerified) {
                    await _firebaseService
                        .updateEmailVerificationStatus(userId);
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed(
                          '/home'); // Navigate to home screen
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please verify your email to continue'),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Resend Email'),
              onPressed: () async {
                try {
                  await _firebaseService.sendEmailVerification();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification email resent'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void setState(Function() param0) {
    param0();
    notifyListeners();
  }

  //this is for logining in Users after registration
  Future<void> signIn(
      BuildContext context, GlobalKey<FormState> formKey) async {
    // Validate form before proceeding
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Save form values
    formKey.currentState!.save();

    // Reset previous error
    errorMessage = null;

    // Start loading
    setState(() => isLoading = true);

    try {
      // Attempt sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email!.trim(),
        password: password!.trim(),
      );

      // Check email verification
      User? user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          // Send verification email
          await user.sendEmailVerification();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Please verify your email. Verification email sent.')),
          );
          return;
        }

        // Navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        default:
          message = 'Login failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    } finally {
      // Stop loading
      setState(() => isLoading = false);
    }
  }
}
