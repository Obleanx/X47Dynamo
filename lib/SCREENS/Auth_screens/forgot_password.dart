import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/SCREENS/Auth_screens/create_account.dart';
import 'package:kakra/SCREENS/Auth_screens/create_newpassword.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';
import 'package:kakra/widgets/reusable_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                    return CustomTextField(
                      label: "Email",
                      onSaved: (value) => provider.email = value,
                      validator: (value) => provider.validateEmail(value),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Consumer<RegistrationProvider>(
                  builder: (context, provider, child) {
                    return KakraButton(
                      text: "Submit",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreatePasswordScreen()),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
