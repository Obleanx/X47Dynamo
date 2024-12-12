import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/selers_details.dart';

// Provider Widget
class SellerDetailsProvider extends StatelessWidget {
  final String sellerEmail;

  const SellerDetailsProvider({super.key, required this.sellerEmail});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SellerDetailsViewModel(sellerEmail: sellerEmail),
      child: SellerDetailsScreen(
        sellerEmail: sellerEmail,
      ),
    );
  }
}

class SellerDetailsViewModel extends ChangeNotifier {
  final String sellerEmail;
  Map<String, dynamic>? _sellerData;
  bool _isLoading = true;
  String? _errorMessage;

  SellerDetailsViewModel({required this.sellerEmail}) {}

  Map<String, dynamic>? get sellerData => _sellerData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
}
