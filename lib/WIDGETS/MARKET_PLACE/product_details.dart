import 'package:flutter/material.dart';
import 'package:kakra/MODELS/product_.dart';
import 'package:kakra/PROVIDERS/product_description_provider.dart';
import 'package:kakra/PROVIDERS/seller_details.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/action_button.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/expandable_text.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/recommende_products.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/related_products.dart';
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
      create: (_) =>
          ProductImageProvider(productImages[0]), // Initialize with first image
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Main Product Image
                Consumer<ProductImageProvider>(
                  builder: (_, provider, __) => Image.asset(
                    provider.currentImage,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Thumbnail Images
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      for (int i = 0; i < 4; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Consumer<ProductImageProvider>(
                            builder: (_, provider, __) => GestureDetector(
                              onTap: () {
                                provider.updateImage(productImages[i]);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: provider.currentImage ==
                                            productImages[i]
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(productImages[i]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
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
                      const SizedBox(height: 22),

                      // descibes the item the seller wants to sell from name to price and detailed description
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ExpandableText(
                        text: product.description,
                        maxLines: 4,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),

                      const Divider(height: 32),

                      // Action Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionIcon(
                            icon: Icons.message_outlined,
                            label: 'Message',
                            onTap: () {/* Handle message */},
                          ),
                          ActionIcon(
                            icon: Icons.remove_red_eye_outlined,
                            label: 'View Post',
                            onTap: () {/* Handle view */},
                          ),
                          ActionIcon(
                            icon: Icons.share_outlined,
                            label: 'Share',
                            onTap: () {/* Handle share */},
                          ),
                          ActionIcon(
                            icon: Icons.bookmark_add_outlined,
                            label: 'Save',
                            onTap: () {/* Handle save */},
                          ),
                        ],
                      ),

                      const Divider(height: 32),
                      const SizedBox(height: 25),

                      // Seller Information
                      const Text(
                        'Seller Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // details of the seller are below.
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('lib/images/mdp3.jpg'),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
// Navigate to the screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SellerDetailsProvider()),
                                  );
                                },
                                child: const Text('See Profile'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            product.sellerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Joined on ${product.sellerJoinDate}'),
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
                          imageUrl: 'lib/images/kr${index + 4}.png',
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
