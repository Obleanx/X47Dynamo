import 'package:flutter/material.dart';

class RecommendedProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final VoidCallback onTap;

  const RecommendedProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imageUrl), // Changed to AssetImage
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('\$${price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
