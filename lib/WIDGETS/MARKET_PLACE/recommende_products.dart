import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class RecommendedProductCard extends StatelessWidget {
  final Map<String, dynamic> productData;
  final VoidCallback onTap;

  const RecommendedProductCard({
    super.key,
    required this.productData,
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
                  image: CachedNetworkImageProvider(
                    (productData['imageUrls'] as List?)?.isNotEmpty == true 
                        ? productData['imageUrls'][0] 
                        : '',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              productData['productName'] ?? 'Unknown Product', 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
            Text('\$${(productData['price'] ?? 0.0).toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}