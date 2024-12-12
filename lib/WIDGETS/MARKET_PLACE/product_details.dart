import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:kakra/MODELS/product_.dart';
import 'package:kakra/PROVIDERS/seller_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/action_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/expandable_text.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/backend_products.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/related_products.dart';
import 'package:kakra/PROVIDERS/product_description_provider.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/recommende_products.dart';

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
                                        .where('email',
                                            isEqualTo: product.sellerEmail)
                                        .limit(1)
                                        .get(),
                                    builder: (context, snapshot) {
                                      // Debugging print statements
                                      if (kDebugMode) {
                                        print(
                                            'Product Seller Email: ${product.sellerEmail}');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.docs.isEmpty) {
                                        print(
                                            'No seller found for email: ${product.sellerEmail}');
                                        return const CircleAvatar(
                                          radius: 30,
                                          child: Text('No Seller'),
                                        );
                                      }

                                      // Additional debugging
                                      final sellerDocs = snapshot.data!.docs;
                                      sellerDocs.forEach((doc) {
                                        print('Found Seller Document:');
                                        print('Seller Email: ${doc['email']}');
                                        print(
                                            'Full Seller Data: ${doc.data()}');
                                      });

                                      final sellerData = sellerDocs.first.data()
                                          as Map<String, dynamic>;

                                      return CircleAvatar(
                                        radius: 30,
                                        backgroundImage: sellerData[
                                                    'profileImageUrl'] !=
                                                null
                                            ? NetworkImage(
                                                sellerData['profileImageUrl'])
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
                                              SellerDetailsProvider(
                                            sellerEmail: product.sellerEmail ??
                                                'Unknown Email',
                                          ),
                                        ),
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
                                    .where('email',
                                        isEqualTo: product.sellerEmail)
                                    .limit(1)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('Loading...');
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.sellerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                            'Seller information unavailable'),
                                      ],
                                    );
                                  }

                                  final sellerDoc = snapshot.data!.docs.first;
                                  final sellerData =
                                      sellerDoc.data() as Map<String, dynamic>;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${sellerData['firstName'] ?? ''} ${sellerData['lastName'] ?? ''}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Joined on ${_formatJoinDate(sellerData['accountCreatedAt'])}',
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),

                      const Divider(height: 32),

                      // More from Seller
                      const Text(
                        'Check out more from this seller',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

// Fetch seller's listings based on their Firestore document
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('sellers')
                            .where('email', isEqualTo: product.sellerEmail)
                            .limit(1)
                            .get(),
                        builder: (context, sellerSnapshot) {
                          if (sellerSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!sellerSnapshot.hasData ||
                              sellerSnapshot.data!.docs.isEmpty) {
                            return const Text(
                                'No listings available for this seller.');
                          }

                          final sellerDoc = sellerSnapshot.data!.docs.first;
                          final sellerId = sellerDoc.id;

                          // Fetch specific listings from the seller's subdocument
                          return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('sellers')
                                .doc(sellerId)
                                .collection('listings')
                                .get(),
                            builder: (context, listingSnapshot) {
                              if (listingSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (!listingSnapshot.hasData ||
                                  listingSnapshot.data!.docs.isEmpty) {
                                return const Text(
                                    'This seller has no listings.');
                              }

                              final listings = listingSnapshot.data!.docs;

                              // Build the ListView from the seller's specific listings
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listings.length,
                                itemBuilder: (context, index) {
                                  final listing = listings[index].data()
                                      as Map<String, dynamic>;

                                  // Safe image URL extraction
                                  String? imageUrl;
                                  try {
                                    if (listing['imageUrls'] is List &&
                                        (listing['imageUrls'] as List)
                                            .isNotEmpty) {
                                      imageUrl =
                                          (listing['imageUrls'] as List)[0];
                                    }
                                  } catch (e) {
                                    if (kDebugMode) {
                                      print('Error extracting image URL: $e');
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                              product: ViewProduct(
                                                name: listing['productName'] ??
                                                    'Unknown Product',
                                                price: listing['price'] ?? 0.0,
                                                description: listing[
                                                        'description'] ??
                                                    'No description available',
                                                images: List<String>.from(
                                                    listing['imageUrls'] ?? []),
                                                sellerName:
                                                    listing['sellerName'] ??
                                                        'Unknown Seller',
                                                sellerJoinDate: _formatJoinDate(
                                                    listing['timestamp'] ??
                                                        Timestamp.now()),
                                                sellerId:
                                                    listing['sellerId'] ?? '',
                                                sellerEmail:
                                                    listing['sellerEmail'] ??
                                                        '',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Image Container
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageUrl != null
                                                    ? CachedNetworkImageProvider(
                                                        imageUrl)
                                                    : const AssetImage(
                                                            'lib/images/default_image.png')
                                                        as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          // Product Details (Outside the Image Container)
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                  top: 10.0,
                                                  bottom: 20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Product Name
                                                  Text(
                                                    listing['productName'] ??
                                                        'No Name',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),

                                                  // Price
                                                  Text(
                                                    '£ ${(listing['price'] ?? 0.0).toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 83, 165, 85),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  // Category
                                                  Text(
                                                    listing['category'] ??
                                                        'No Category',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),

                      // Recommended Products
                      _buildRecommendedProducts(),

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

Widget _buildRecommendedProducts() {
  return Consumer<FirebaseProductProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (provider.listings.isEmpty) {
        return const Center(
          child: Text('No recommended products found.'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 32),

          const Text(
            'Recommended Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal List of Recommended Products
          SizedBox(
            height: 250, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.listings.length,
              itemBuilder: (context, index) {
                final listing = provider.listings[index];

                // Extract image URL safely
                String? imageUrl;
                try {
                  if (listing['imageUrls'] is List &&
                      (listing['imageUrls'] as List).isNotEmpty) {
                    imageUrl = (listing['imageUrls'] as List)[0];
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print('Error extracting image URL: $e');
                  }
                }

                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: ViewProduct(
                              name: listing['productName'] ?? 'Unknown Product',
                              price: listing['price'] ?? 0.0,
                              description: listing['description'] ??
                                  'No description available',
                              images:
                                  List<String>.from(listing['imageUrls'] ?? []),
                              sellerName:
                                  listing['sellerName'] ?? 'Unknown Seller',
                              sellerJoinDate: _formatJoinDate(
                                  listing['timestamp'] ?? Timestamp.now()),
                              sellerId: listing['sellerId'] ?? '',
                              sellerEmail: listing['sellerEmail'] ?? '',
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: imageUrl != null
                                  ? CachedNetworkImageProvider(imageUrl)
                                  : const AssetImage(
                                      'lib/images/default_image.png',
                                    ) as ImageProvider,
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
                          listing['productName'] ?? 'Unknown Product',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Product Price
                        Text(
                          '£ ${(listing['price'] ?? 0.0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 83, 165, 85),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
