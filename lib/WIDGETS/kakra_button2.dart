import 'package:flutter/material.dart';
import 'package:kakra/CORE/constants.dart';

class KakraButton2 extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;

  const KakraButton2({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        onPressed: onPressed,
        child: SizedBox(
          height: 20,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
