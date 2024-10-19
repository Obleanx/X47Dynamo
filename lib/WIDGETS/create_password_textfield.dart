// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ConfirmPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isVisible;
  final Function() toggleVisibility;

  const ConfirmPasswordTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.isVisible,
    required this.toggleVisibility,
  });

  @override
  _ConfirmPasswordTextFieldState createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: widget.controller,
          obscureText: !widget.isVisible,
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
            labelText: "Confirm Password",
            border: OutlineInputBorder(),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: Icon(
              widget.isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: widget.toggleVisibility,
          ),
        ),
      ],
    );
  }
}
