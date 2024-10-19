import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    this.obscureText = false,
    required this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13), // Set label text color to black
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
