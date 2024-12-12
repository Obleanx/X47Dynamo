import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:kakra/CORE/constants.dart';
import '../../PROVIDERS/profile_provider.dart';
import 'package:kakra/PROVIDERS/seller_hq_provider.dart';
import 'package:kakra/PROVIDERS/categories_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellerHQScreen extends StatefulWidget {
  const SellerHQScreen({super.key});

  @override
  State<SellerHQScreen> createState() => _SellerHQScreenState();
}

class _SellerHQScreenState extends State<SellerHQScreen> {
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
          title: const Text('New Listings'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<SellerHQProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seller Profile Section
                  Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      final profileImageUrl = profileProvider.profileImageUrl;
                      final firstName = profileProvider.firstName ?? 'User';
                      final lastName = profileProvider.lastName ?? '';
                      final fullName =
                          '$firstName ${lastName.isNotEmpty ? lastName : ''}'
                              .trim();

                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: profileImageUrl != null &&
                                    profileImageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(profileImageUrl)
                                : const AssetImage('lib/images/kr5.png')
                                    as ImageProvider,
                            child: profileImageUrl == null ||
                                    profileImageUrl.isEmpty
                                ? Icon(Icons.person, color: Colors.grey[400])
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('listing on the Market Place'),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Image Selection Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Image Container
                      Consumer<SellerHQProvider>(
                        builder: (context, provider, child) {
                          return GestureDetector(
                            onTap: () => provider.pickImages(context),
                            child: Container(
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: provider.pickedImages.isEmpty
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate,
                                            size: 50),
                                        Text('Select Product Images')
                                      ],
                                    )
                                  : Image.file(
                                      File(provider
                                          .pickedImages[
                                              provider.currentMainImageIndex]
                                          .path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),

                      // Image Thumbnails Row
                      Consumer<SellerHQProvider>(
                        builder: (context, provider, child) {
                          return provider.pickedImages.isNotEmpty
                              ? SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: provider.pickedImages.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () =>
                                            provider.switchMainImage(index),
                                        child: Container(
                                          width: 50,
                                          height: 40,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: index ==
                                                      provider
                                                          .currentMainImageIndex
                                                  ? Colors.blue
                                                  : Colors.grey,
                                              width: index ==
                                                      provider
                                                          .currentMainImageIndex
                                                  ? 2
                                                  : 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Image.file(
                                            File(provider
                                                .pickedImages[index].path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),

                      Consumer<SellerHQProvider>(
                        builder: (context, provider, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Photos ${provider.pickedImages.length}/10 (choose your listings main photo first)',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Keep existing text fields with enhanced validation
                  const SizedBox(height: 24),
                  CustomTextFieldForSellers(
                    label: 'Product/Item Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product name is required';
                      }
                      if (value.length < 3) {
                        return 'Product name must be at least 3 characters';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        provider.updateField('productName', value),
                  ),

                  // Category TextField
                  const SizedBox(height: 16),
                  CustomTextFieldForSellers(
                    label: 'Price',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                    onChanged: (value) => provider.updateField('price', value),
                  ),

                  const SizedBox(height: 16),

                  // Category TextField
                  Consumer<SellerHQProvider>(
                    builder: (context, provider, child) {
                      return CustomTextFieldForSellers(
                        label: 'Category',
                        readOnly: true,
                        controller:
                            TextEditingController(text: provider.category),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Select Category'),
                              content: SizedBox(
                                width: double.maxFinite,
                                height: 400,
                                child: Consumer<CategoriesProvider>(
                                  builder: (context, categoryProvider, _) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          categoryProvider.categories.length,
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
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  CustomTextFieldForSellers(
                    label: 'Description',
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      if (value.length < 20) {
                        return 'Description must be at least 20 characters';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        provider.updateField('description', value),
                    suffix: Text(
                      '${provider.description?.length ?? 0}/300',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Condition TextField
                  Consumer<SellerHQProvider>(
                    builder: (context, provider, child) {
                      return CustomTextFieldForSellers(
                        label: 'Condition',
                        readOnly: true,
                        controller:
                            TextEditingController(text: provider.condition),
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
                                    provider.updateField(
                                        'condition', condition);
                                    Navigator.pop(context);
                                  },
                                  child: Text(condition),
                                );
                              }).toList(),
                            ),
                          );
                        },
                        suffix: const Icon(Icons.arrow_drop_down),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Terms Text
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Kakra Marketplace is a place where users can responsibly buy and sell, with all listings being accurate, lawful, and fairly priced. Sellers are expected to provide clear product descriptions and communicate respectfully. Fraudulent, misleading, or inappropriate content may result in listing removal or account suspension to ensure a safe and trusted environment for everyone.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Consumer<SellerHQProvider>(
                    builder: (context, provider, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: provider.isFormValid
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.6),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: provider.isFormValid
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            foregroundColor: provider.isFormValid
                                ? Colors.white
                                : Colors.grey.shade600,
                            elevation: provider.isFormValid ? 5 : 1,
                          ),
                          onPressed: provider.isFormValid
                              ? () {
                                  if (kDebugMode) {
                                    print('Submitting listing');
                                  }
                                  provider.submitListing(context);
                                }
                              : null,
                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text('Submit Listing'),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldForSellers extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final TextEditingController? controller; // Add this line

  const CustomTextFieldForSellers({
    super.key,
    required this.label,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.suffix,
    this.controller, // Add this line
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
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, // Use the controller here
          validator: validator,
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
            errorStyle: const TextStyle(color: Colors.red),
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
