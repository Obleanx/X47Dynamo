import 'package:flutter/material.dart';

class KakraButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const KakraButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2486C2),
              Color(0xFF2BBCE7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            backgroundColor: Colors.transparent,
            elevation: 0),
        onPressed: onPressed,
        child: Text(text,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
