import 'package:flutter/material.dart';
import 'package:kakra/MODELS/product_.dart';
import 'package:kakra/PROVIDERS/product_description_provider.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/action_button.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/recommende_products.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/related_products.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/thumbnails.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ViewProduct product; // Updated class name

  ProductDetailsScreen({
    super.key,
    required this.product,
  });

  final List<String> productImages =
      List.generate(7, (index) => 'lib/images/kr${index + 4}.png');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductImageProvider()..updateImage(product.images.first),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Main Product Image
                Consumer<ProductImageProvider>(
                  builder: (context, imageProvider, _) => Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageProvider.currentImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Thumbnail Images
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: product.images
                        .map((image) => ProductImageThumbnail(
                              imageUrl: image,
                              onTap: () => context
                                  .read<ProductImageProvider>()
                                  .updateImage(image),
                            ))
                        .toList(),
                  ),
                ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(product.description),
                      const Divider(height: 32),

                      // Action Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionIcon(
                            icon: Icons.message,
                            label: 'Message',
                            onTap: () {/* Handle message */},
                          ),
                          ActionIcon(
                            icon: Icons.remove_red_eye,
                            label: 'View Post',
                            onTap: () {/* Handle view */},
                          ),
                          ActionIcon(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: () {/* Handle share */},
                          ),
                          ActionIcon(
                            icon: Icons.bookmark,
                            label: 'Save',
                            onTap: () {/* Handle save */},
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      // Seller Information
                      const Text(
                        'Seller Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage('seller_image_url'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.sellerName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Joined on ${product.sellerJoinDate}'),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {/* Navigate to seller profile */},
                            child: const Text('See Profile'),
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      // More from Seller
                      const Text(
                        'Check out more from this seller',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3, // Number of related products
                        itemBuilder: (context, index) => RelatedProductItem(
                          imageUrl: 'product_image_url',
                          name: 'Related Product ${index + 1}',
                          price: 99.99,
                          onTap: () {/* Navigate to product */},
                        ),
                      ),

                      const Divider(height: 32),

                      // Recommended Products
                      const Text(
                        'Recommended Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5, // Number of recommended products
                          itemBuilder: (context, index) =>
                              RecommendedProductCard(
                            imageUrl: productImages[index],
                            name: 'Recommended Product ${index + 1}',
                            price: 149.99,
                            onTap: () {/* Navigate to product */},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
