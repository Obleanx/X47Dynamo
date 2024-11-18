import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakra/CORE/constants.dart';
import 'package:kakra/WIDGETS/contents_filter/categories_screen.dart';

// category_tile_widget.dart
class CategoryTileWidget extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap;

  const CategoryTileWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xffcaf0f8),
            radius: 16,
            child: FaIcon(
              category.icon,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          title: Text(
            category.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            category.isExpanded
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_right_outlined,
          ),
          onTap: onTap,
        ),
        if (category.isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: category.subCategories.map((subCategory) {
                return TextButton(
                  onPressed: () {
                    // Handle subcategory selection
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subCategory,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
