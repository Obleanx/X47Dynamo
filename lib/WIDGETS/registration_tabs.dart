import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:provider/provider.dart';

class RegistrationTabs extends StatelessWidget {
  const RegistrationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => provider.setIsSignUp(true),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight:
                        provider.isSignUp ? FontWeight.bold : FontWeight.normal,
                    color: provider.isSignUp ? Colors.blue : Colors.black,
                  ),
                  overflow: TextOverflow
                      .ellipsis, // This prevents overflow text from causing issues
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () => provider.setIsSignUp(false),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: !provider.isSignUp
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: !provider.isSignUp ? Colors.blue : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
