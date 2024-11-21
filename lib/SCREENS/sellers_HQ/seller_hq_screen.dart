// seller_hq_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakra/CORE/constants.dart';
import 'package:kakra/PROVIDERS/categories_provider.dart';
import 'package:kakra/PROVIDERS/seller_hq_provider.dart';
import 'package:provider/provider.dart';

class SellerHQScreen extends StatelessWidget {
  const SellerHQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SellerHQProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'New Listings',
            style: TextStyle(
                // fontWeight: FontWeight.bold,
                // color: AppColors.secondary,
                ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<SellerHQProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seller Profile Section
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('lib/images/fdp1.jpg'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paul Walker',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('listing on the Market Place'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Image Selection
                  GestureDetector(
                    onTap: () {
                      // Navigate to gallery
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_photo_alternate, size: 50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'photo ${provider.photoCount}/10 (choose your listings main photo first)',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  CustomTextFieldForSellerrs(
                    label: 'Product/Item Name',
                    onChanged: (value) =>
                        provider.updateField('productName', value),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldForSellerrs(
                    label: 'Price',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => provider.updateField('price', value),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldForSellerrs(
                    label: 'Description',
                    maxLines: 5,
                    onChanged: (value) =>
                        provider.updateField('description', value),
                    suffix: Text(
                      '${provider.description?.length ?? 0}/300',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category TextField
                  CustomTextFieldForSellerrs(
                    label: 'Category',
                    readOnly: true,
                    controller: TextEditingController(
                        text: provider.category), // Add this
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select Category'),
                          content: SizedBox(
                            width: double.maxFinite,
                            height:
                                400, // Set a fixed height for scrollable content
                            child: Consumer<CategoriesProvider>(
                              builder: (context, categoryProvider, _) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: categoryProvider.categories.length,
                                  itemBuilder: (context, index) {
                                    final category =
                                        categoryProvider.categories[index];
                                    return ExpansionTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xffcaf0f8),
                                        child: FaIcon(
                                          category.icon,
                                          color: Colors.blue,
                                          size: 16,
                                        ),
                                      ),
                                      title: Text(category.name),
                                      children: category.subCategories
                                          .map((subCategory) {
                                        return ListTile(
                                          title: Text(subCategory),
                                          onTap: () {
                                            provider.updateField(
                                                'category', subCategory);
                                            Navigator.pop(context);
                                          },
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    suffix: const Icon(Icons.arrow_drop_down),
                  ),
                  const SizedBox(height: 16),

                  // Condition TextField
                  CustomTextFieldForSellerrs(
                    label: 'Condition',
                    readOnly: true,
                    controller: TextEditingController(
                        text: provider.condition), // Add this
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: const Text(
                            'Select Condition',
                            style: TextStyle(
                              color: AppColors.secondary,
                            ),
                          ),
                          children: ['new', 'fairly used'].map((condition) {
                            return SimpleDialogOption(
                              onPressed: () {
                                provider.updateField('condition', condition);
                                Navigator.pop(context);
                              },
                              child: Text(
                                condition,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                    suffix: const Icon(Icons.arrow_drop_down),
                  ),
                  const SizedBox(height: 20),
                  // Terms Text
                  const Text(
                    "Kakra Marketplace is a place where users can responsibly buy and sell, with all listings being accurate, lawful, and fairly priced. Sellers are expected to provide clear product descriptions and communicate respectfully. Fraudulent, misleading, or inappropriate content may result in listing removal or account suspension to ensure a safe and trusted environment for everyone.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isFormValid
                          ? () {
                              // Handle submission
                            }
                          : null,
                      child: const Text('Submit Listing'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Updated CustomTextField widget that include a controller:
class CustomTextFieldForSellerrs extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const CustomTextFieldForSellerrs({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: suffix,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
