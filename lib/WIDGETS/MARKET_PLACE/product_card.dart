import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Home_screens/market%20place/market_home_screen.dart';

// Product Card Widget
class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: Image.asset(
                  product.assetimage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '₦${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Constants
class AppColors {
  static const Color primary = Color(0xFF2486C2);
  static const Color secondary = Color(0xFF2BBCE7);
}

// Reusable Product Card Widget
class ProductCard2 extends StatelessWidget {
  final dynamic productData;
  final VoidCallback onTap;

  const ProductCard2({
    super.key,
    required this.productData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // More comprehensive image URL detection
    String? imageUrl;
    if (productData is Map) {
      imageUrl = productData['imageUrl'] ??
          productData['image'] ??
          productData['productImage'] ??
          productData['productImageUrl'] ??
          productData['imageURL'] ?? // Added additional variations
          productData['img'];
    }

    // If no image URL is found, use a network default or local asset
    imageUrl ??= 'https://via.placeholder.com/150'; // Placeholder image
    // OR use local asset: 'lib/images/default_product.png'

    String name = productData is Map
        ? (productData['productName'] ?? 'Unknown Product')
        : 'Unknown Product';

    double price = productData is Map
        ? (double.tryParse(productData['price']?.toString() ?? '0.0') ?? 0.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              image: DecorationImage(
                image: imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl)
                    : AssetImage(imageUrl) as ImageProvider,
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('Error loading image: $exception');
                },
              ),
              color: Colors.grey[200], // Fallback background color
            ),
            child: imageUrl.startsWith('http')
                ? null
                : Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[400],
                      size: 40,
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
