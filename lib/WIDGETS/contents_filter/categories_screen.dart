// category_model.dart
import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/categories_provider.dart';
import 'package:kakra/WIDGETS/contents_filter/category_tile_widget.dart';
import 'package:provider/provider.dart';

class CategoryItem {
  final String name;
  final List<String> subCategories;
  final IconData icon;
  bool isExpanded;

  CategoryItem({
    required this.name,
    required this.subCategories,
    required this.icon,
    this.isExpanded = false,
  });
}

// categories_screen.dart
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoriesProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<CategoriesProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                  vertical: 8), // Add padding to the entire list
              itemCount: provider.categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16), // Add vertical spacing between items
                  child: CategoryTileWidget(
                    category: provider.categories[index],
                    onTap: () => provider.toggleCategory(index),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
