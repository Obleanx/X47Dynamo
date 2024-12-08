import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/selers_details.dart';

// Provider Widget
class SellerDetailsProvider extends StatelessWidget {
  final String sellerEmail;

  const SellerDetailsProvider({super.key, required this.sellerEmail});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SellerDetailsViewModel(sellerEmail: sellerEmail),
      child: const SellerDetailsScreen(),
    );
  }
}

class SellerDetailsViewModel extends ChangeNotifier {
  final String sellerEmail;
  Map<String, dynamic>? _sellerData;
  bool _isLoading = true;
  String? _errorMessage;

  SellerDetailsViewModel({required this.sellerEmail}) {
    fetchSellerDetails();
  }

  Map<String, dynamic>? get sellerData => _sellerData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSellerDetails() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('sellers')
          .where('email', isEqualTo: sellerEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _sellerData = querySnapshot.docs.first.data();
      } else {
        _errorMessage = 'Seller not found';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching seller details: ${e.toString()}';
      notifyListeners();
    }
  }
}
