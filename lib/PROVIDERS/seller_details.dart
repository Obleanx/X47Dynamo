import 'package:flutter/material.dart';
import 'package:kakra/MODELS/product_.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/selers_details.dart';
import 'package:provider/provider.dart';

// Provider Widget
class SellerDetailsProvider extends StatelessWidget {
  const SellerDetailsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SellerDetailsViewModel(),
      child: const SellerDetailsScreen(),
    );
  }
}
