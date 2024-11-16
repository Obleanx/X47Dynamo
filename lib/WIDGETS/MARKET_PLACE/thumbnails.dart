import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/product_description_provider.dart';
import 'package:provider/provider.dart';

// Reusable Widgets

class ProductImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const ProductImageThumbnail({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductImageProvider>(
      builder: (context, provider, _) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: provider.currentImage == imageUrl
                  ? Colors.blue
                  : Colors.transparent,
              width: 2,
            ),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
