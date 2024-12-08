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

      _listings = await Future.wait(querySnapshot.docs.map((doc) async {
        // Fetch seller information for each listing
        final sellerSnapshot = await FirebaseFirestore.instance
            .collection('sellers')
            .doc(doc['userId'])
            .get();

        return {
          'id': doc.id,
          ...doc.data(),
          'userId': doc['userId'],
          'sellerInfo': sellerSnapshot.data() ?? {},
        };
      }).toList());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch listings: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Optional: Add method to load more listings
  Future<void> loadMoreListings(DocumentSnapshot? lastDocument) async {
    try {
      if (lastDocument == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();

      final newListings = querySnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      _listings.addAll(newListings);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load more listings: ${e.toString()}';
      notifyListeners();
    }
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
