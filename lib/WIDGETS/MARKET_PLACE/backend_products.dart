import 'package:flutter/material.dart';
import 'package:kakra/MODELS/product_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/product_details.dart';

class ProductCardFromFirebase extends StatelessWidget {
  final Map<String, dynamic> listingData;

  const ProductCardFromFirebase({
    super.key,
    required this.listingData,
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
                  name: listingData['productName'] ?? 'Unknown Product',
                  price: listingData['price'] ?? 0.0,
                  description:
                      listingData['description'] ?? 'No description available',
                  images: List<String>.from(listingData['imageUrls'] ?? []),
                  sellerName: listingData['sellerName'] ?? 'Unknown Seller',
                  sellerJoinDate:
                      _formatJoinDate(listingData['sellerJoinDate']),
                  sellerId: listingData['sellerId'], // Add this
                  sellerEmail: listingData['sellerEmail'],
                ),
              ),
            ),
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 1.2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: CachedNetworkImage(
                      imageUrl:
                          (listingData['imageUrls'] as List?)?.isNotEmpty ==
                                  true
                              ? listingData['imageUrls'][0]
                              : '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline),
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
                      listingData['productName'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '₦${listingData['price']?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      listingData['category'] ?? 'No Category',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
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

class FirebaseProductProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _listings = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get listings => _listings;
  Map<String, Map<String, dynamic>> _sellerCache = {}; // Add a seller cache

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchListings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      // First, collect all unique user IDs
      final userIds = querySnapshot.docs.map((doc) => doc['userId']).toSet();

      // Fetch seller information for all unique users in one go
      final sellerSnapshots = await Future.wait(userIds.map((userId) =>
          FirebaseFirestore.instance.collection('sellers').doc(userId).get()));

      // Create a map of seller information for quick lookup
      _sellerCache = {
        for (var snapshot in sellerSnapshots) snapshot.id: snapshot.data() ?? {}
      };
      _listings = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
          'sellerId': data['sellerId'],
          'sellerInfo': _sellerCache[data['sellerId']] ?? {},
        };
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch listings: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Optional: Method to clear cache if needed
  void clearCache() {
    _sellerCache.clear();
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
