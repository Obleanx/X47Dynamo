import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Home_screens/market%20place/market_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:kakra/providers/home_provider.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Town Square', 'Community', 'Market Place'];

    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categories.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    provider.setSelectedCategory(index);
                    // Navigate to MarketplaceHomeScreen if "Market Place" is selected
                    if (categories[index] == 'Market Place') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarketplaceContent(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: provider.selectedCategoryIndex == index
                          ? const Color(0xFF2486C2)
                          : const Color(0xFFc2e9fb),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: provider.selectedCategoryIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
