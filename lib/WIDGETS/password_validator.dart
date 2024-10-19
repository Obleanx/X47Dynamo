import 'package:flutter/material.dart';

class PasswordValidator extends StatelessWidget {
  final String password;

  const PasswordValidator({super.key, required this.password});

  bool _hasFiveCharacters(String password) {
    return password.length >= 5;
  }

  bool _hasUpperCase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  bool _hasLowerCase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  bool _hasSpecialCharacter(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Widget _buildValidationIndicator(
      {required bool isValid, required String text}) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? Colors.green : Colors.red,
          ),
          child: Center(
            child: Icon(
              isValid ? Icons.check : Icons.close,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildValidationIndicator(
          isValid: _hasFiveCharacters(password),
          text: 'At least 5 characters',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: _hasUpperCase(password),
          text: '1 upper case letter',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: _hasLowerCase(password),
          text: '1 lower case letter',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: _hasSpecialCharacter(password),
          text: '1 special character',
        ),
      ],
    );
  }
}
