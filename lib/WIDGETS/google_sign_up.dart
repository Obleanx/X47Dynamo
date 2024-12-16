import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleSignUpButton extends StatelessWidget {
  const GoogleSignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Colors.blue, // G
                Colors.red, // o
                Colors.yellow, // o
                Colors.blue, // g
                Colors.green, // l
                Colors.red, // e
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const FaIcon(
            FontAwesomeIcons.google,
            size: 24,
            color: Colors.white, // Base color to apply gradient
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "Sign up with Google",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
