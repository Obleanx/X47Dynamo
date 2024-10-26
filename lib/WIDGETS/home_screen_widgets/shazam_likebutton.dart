// lib/widgets/custom_floating_button/custom_floating_button.dart
import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:provider/provider.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FloatingButtonProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.only(
              right: 15,
              bottom:
                  60), //to allign the button to the lower right of the screen
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2486C2),
                Color(0xFF2BBCE7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => provider.toggleMenu(),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
