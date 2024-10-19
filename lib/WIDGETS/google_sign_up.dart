import 'package:flutter/material.dart';

class GoogleSignUpButton extends StatelessWidget {
  const GoogleSignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('lib/images/gglogo.png', height: 24),
        const SizedBox(width: 10),
        const Text("Sign up with Google"),
      ],
    );
  }
}
