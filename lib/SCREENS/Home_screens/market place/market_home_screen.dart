import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakra/MODELS/product_.dart';
import 'package:kakra/WIDGETS/_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakra/SCREENS/sellers_HQ/listings.dart';
import 'package:kakra/PROVIDERS/market_place_provider.dart';
import '../../../WIDGETS/MARKET_PLACE/product_details.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakra/SCREENS/sellers_HQ/seller_hq_screen.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/backend_products.dart';
import 'package:kakra/WIDGETS/contents_filter/categories_screen.dart';

// Product Model
class Product {
  final String id;
  final String name;
  final double price;
  final String assetimage;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.assetimage,
    required this.category,
  });
}

class MarketplaceContent extends StatefulWidget {
  const MarketplaceContent({super.key, required this.userId});
  final String? userId; // Pass the specific user ID

  @override
  State<MarketplaceContent> createState() => _MarketplaceContentState();
}

class _MarketplaceContentState extends State<MarketplaceContent> {
  @override
  void initState() {
    super.initState();
    // Fetch listings when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FirebaseProductProvider>(context, listen: false)
          .fetchListings();
    });

    _sellerDetailsFuture = fetchSellerDetails();
    _sellerListingsFuture = fetchSellerListings();
  }

  late Future<Map<String, dynamic>> _sellerDetailsFuture;
  late Future<List<Map<String, dynamic>>> _sellerListingsFuture;

  Future<Map<String, dynamic>> fetchSellerDetails() async {
    final sellerSnapshot = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.userId)
        .get();

    if (!sellerSnapshot.exists) {
      throw Exception('Seller not found');
    }

    return sellerSnapshot.data()!;
  }

  Future<List<Map<String, dynamic>>> fetchSellerListings() async {
    final listingsSnapshot = await FirebaseFirestore.instance
        .collection('listings')
        .where('userId', isEqualTo: widget.userId)
        .get();

    return listingsSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomExpandableAppBar(
            title: "Marketplace",
            expandedHeight: 140.0,
            collapsedHeight: 56.0,
            automaticallyImplyLeading: true,
            onBackPressed: () => Navigator.pop(context),
            flexibleContent: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),

          // Action Buttons
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  _ActionButton(
                    icon: Icons.edit_note_outlined,
                    label: 'Become a Seller',
                    onTap: () {
                      // Navigate to seller registration
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SellerHQScreen()),
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.category_outlined,
                    label: 'Categories',
                    onTap: () {
                      // Show categories
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoriesScreen()),
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.shopping_cart_outlined,
                    label: 'My Listings',
                    onTap: () {
                      // Navigate to listings
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SellerProductListingScreen()),
                        //SellerListingView
                      );
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.sliders,
                      size: 16,
                    ),
                    onPressed: () {
                      // Show filter options
                    },
                  ),
                ],
              ),
            ),
          ),

          // Today's Items Header
          const SliverPadding(
            padding: EdgeInsets.all(10.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Today's Items",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: Consumer<FirebaseProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.listings.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (provider.error != null) {
                  return SliverToBoxAdapter(
                    child: Text('Error: ${provider.error}'),
                  );
                }

                if (provider.listings.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Text('No listings found'),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final listing = provider.listings[index];
                      return ProductCardFromFirebase(listingData: listing);
                    },
                    childCount: provider.listings.length,
                  ),
                );
              },
            ),
          ),
          // Products Grid
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = provider.products[index];
                      return ProductCard(product: product);
                    },
                    childCount: provider.products.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: const Color(0xFF2486C2),
        borderRadius: BorderRadius.circular(3.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7.0,
              vertical: 3.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 14,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
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

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                product: ViewProduct(
                  name: "iPhone 14 Pro Max (148GB, Space Black)",
                  price: 99.99,
                  description:
                      "The iPhone 14 Pro Max in Space Black redefines innovation with cutting-edge technology and unmatched style. "
                      "Packed with 148GB of storage, this flagship device ensures ample space for your photos, videos, and apps while delivering top-notch performance.\n\n"
                      "Key Features:\n"
                      "- Stunning Design: The Space Black finish exudes sophistication and elegance, making it a perfect companion for any occasion.\n"
                      "- Pro Camera System: Capture life’s moments in extraordinary detail with advanced photography and videography capabilities.\n"
                      "- Super Retina XDR Display: Enjoy vibrant, true-to-life visuals on the expansive display, perfect for gaming, streaming, and multitasking.\n"
                      "- Powerful A16 Bionic Chip: Experience unparalleled speed, efficiency, and performance for demanding tasks and everyday use.\n"
                      "- Long-lasting Battery Life: Stay connected and productive throughout the day without interruptions.\n"
                      "- 148GB Storage: Store your favorite memories, media, and files effortlessly.\n\n",
                  images: ["lib/images/kr6.png", "lib/images/kr7.png"],
                  sellerName: "Seller Name",
                  sellerJoinDate: "Jan 1, 2024",
                ),
              ),
            ),
          );
        },
        child: SizedBox(
          // Wrap Column in SizedBox to constrain height
          height: MediaQuery.of(context).size.width * 1.2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // Wrap Card with Expanded
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: Image.asset(
                      product.assetimage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '₦${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
