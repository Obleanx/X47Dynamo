import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/SCREENS/Auth_screens/forgot_password.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';
import 'package:kakra/WIDGETS/password_validator.dart';
import 'package:kakra/widgets/reusable_button.dart';
import 'package:provider/provider.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: Scaffold(
        appBar: AppBar(
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
            child: Consumer<RegistrationProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: provider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Image.asset('lib/images/kk4.png', height: 100),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      PasswordField(
                        label: "Password",
                        onSaved: (value) => provider.password = value,
                        validator: (value) => provider.validatePassword(value),
                        primaryPasswordController: provider.passwordController,
                      ),

                      const SizedBox(height: 20),

                      // Password Validator

                      const SizedBox(height: 20),

                      // Confirm Password Field
                      PasswordField(
                        label: "Confirm Password",
                        onSaved: (value) => provider.confirmPassword = value,
                        validator: (value) =>
                            provider.validateConfirmPassword(value),
                        isConfirmPassword: true,
                        primaryPasswordController: provider.passwordController,
                      ),

                      const SizedBox(height: 40),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: KakraButton(
                          text: "Submit",
                          onPressed: () {
                            if (provider.formKey.currentState!.validate()) {
                              provider.formKey.currentState!.save();
                              // Handle the submit action here
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password successfully set!'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
