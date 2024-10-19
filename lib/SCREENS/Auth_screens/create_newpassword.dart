import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/SCREENS/Auth_screens/forgot_password.dart';
import 'package:kakra/WIDGETS/create_password_textfield.dart';
import 'package:kakra/WIDGETS/password_textfield.dart';
import 'package:kakra/WIDGETS/password_validator.dart';
import 'package:kakra/widgets/reusable_button.dart';
import 'package:provider/provider.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  String _password = '';
  String _confirmPassword = '';
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Image.asset('lib/images/kk4.png', height: 100),
                ),
                const SizedBox(height: 20),

                // Password Text Field
                PasswordTextField(
                  controller: _passwordController,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  label: "Password",
                ),
                // Password Validator
                const SizedBox(height: 20),
                PasswordValidator(password: _password),
                const SizedBox(height: 19),
                // Confirm Password Text Field
                ConfirmPasswordTextField(
                  controller: _confirmPasswordController,
                  onChanged: (value) {
                    setState(() {
                      _confirmPassword = value;
                    });
                  },
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: KakraButton(
                    text: "Submit",
                    onPressed: () {
                      // Handle the submit action here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
