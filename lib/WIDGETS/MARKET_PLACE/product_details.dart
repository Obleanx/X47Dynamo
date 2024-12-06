import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakra/MODELS/product_.dart';
import 'package:kakra/PROVIDERS/seller_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/action_button.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/expandable_text.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/backend_products.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/related_products.dart';
import 'package:kakra/PROVIDERS/product_description_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ViewProduct product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductImageProvider(
          product.images.isNotEmpty ? product.images[0] : ''),
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
                  builder: (_, provider, __) => product.images.isNotEmpty
                      ? Image.network(
                          provider.currentImage,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        )
                      : const Center(child: Text('No image available')),
                ),

                // Thumbnail Images
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < product.images.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Consumer<ProductImageProvider>(
                              builder: (_, provider, __) => GestureDetector(
                                onTap: () {
                                  provider.updateImage(product.images[i]);
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: provider.currentImage ==
                                              product.images[i]
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(product.images[i]),
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
                        '£${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
                      Consumer<FirebaseProductProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  FutureBuilder<QuerySnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('sellers')

                                        // .where('email', isEqualTo: product.email) // Use dot notation
                                        .limit(1)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircleAvatar(
                                          radius: 30,
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      final sellerDocs = snapshot.data?.docs;
                                      final sellerData =
                                          sellerDocs?.isNotEmpty == true
                                              ? sellerDocs!.first.data()
                                                  as Map<String, dynamic>
                                              : null;

                                      return CircleAvatar(
                                        radius: 30,
                                        backgroundImage: sellerData?[
                                                    'profileImageUrl'] !=
                                                null
                                            ? NetworkImage(
                                                sellerData!['profileImageUrl'])
                                            : const AssetImage(
                                                    'lib/images/default_profile.jpg')
                                                as ImageProvider,
                                      );
                                    },
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
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
                              FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('sellers')
                                    // .where('email', isEqualTo: product['email'])
                                    .limit(1)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('Loading...');
                                  }

                                  final sellerDocs = snapshot.data?.docs;
                                  final sellerData =
                                      sellerDocs?.isNotEmpty == true
                                          ? sellerDocs!.first.data()
                                              as Map<String, dynamic>
                                          : null;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sellerData != null
                                            ? '${sellerData['firstName'] ?? ''} ${sellerData['lastName'] ?? ''}'
                                            : product.sellerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          'Joined on ${_formatJoinDate(sellerData?['accountCreatedAt'])}'),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
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

// Helper method to format join date
String _formatJoinDate(Timestamp? timestamp) {
  if (timestamp == null) return 'Unknown';
  final date = timestamp.toDate();
  return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
}

// Helper method to get month name
String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}
