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
    // Extract image URL with fallback
    String? imageUrl;
    try {
      if (productData['imageUrls'] is List &&
          (productData['imageUrls'] as List).isNotEmpty) {
        imageUrl = (productData['imageUrls'] as List)[0];
      }
    } catch (e) {
      print('Error extracting image URL: $e');
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: imageUrl != null
                      ? CachedNetworkImageProvider(imageUrl)
                      : const AssetImage('lib/images/default_image.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: imageUrl == null
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 50,
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 8),

            // Product Name
            Text(
              productData['productName'] ?? 'Unknown Product',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Product Price
            Text(
              'GHS ${(productData['price'] ?? 0.0).toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
