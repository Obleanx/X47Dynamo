import 'package:flutter/material.dart';

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
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2486C2),
            Color(0xFF2BBCE7),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading == true
            ? const CircularProgressIndicator(color: Colors.white)
            : child,
      ),
    );
  }
}
