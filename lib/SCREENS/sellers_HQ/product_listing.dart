import 'package:flutter/material.dart';
import 'package:kakra/CORE/constants.dart';
import 'package:kakra/PROVIDERS/ListingProvider.dart';
import 'package:kakra/WIDGETS/reusable_button.dart';
import 'package:provider/provider.dart';

class SellerListingView extends StatefulWidget {
  const SellerListingView({super.key});

  @override
  State<SellerListingView> createState() => _SellerListingViewState();
}

class _SellerListingViewState extends State<SellerListingView> {
  final List<String> images = [
    'lib/images/kr8.png',
    'lib/images/kr9.png',
    'lib/images/kr10.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListingProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'View Listing',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<ListingProvider>(
              builder: (context, provider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 250,
                          child: PageView.builder(
                            onPageChanged: provider.setImageIndex,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(images[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              images.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: provider.currentImageIndex == index
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Product Details
                    const Text(
                      'Shoe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '₦25,000',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    if (provider.isSold)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'SOLD',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    // Assuming you have a KakraButton defined in your custom widgets
                    SizedBox(
                      width: double.infinity,
                      child: KakraButton(
                        text:
                            provider.isSold ? 'Unmark as Sold' : 'Mark as Sold',
                        onPressed: provider.toggleSold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle message seller
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        child: const Text('Message Seller'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCircleIcon(Icons.share, 'Save'),
                        _buildCircleIcon(Icons.edit, 'Edit'),
                        _buildCircleIcon(Icons.delete, 'Delete'),
                        _buildCircleIcon(Icons.add, 'Add'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Product Details
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Condition:', 'New'),
                    _buildDetailRow('Category:', 'Fashion & Accessories'),
                    const SizedBox(height: 24),

                    // Market Insights
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Market Insight',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: provider.setSelectedDays,
                          itemBuilder: (context) => [
                            '3 days',
                            '5 days',
                            '7 days',
                            "2weeks",
                            "1 month"
                          ].map((days) {
                            return PopupMenuItem(
                              value: days,
                              child: Text(days),
                            );
                          }).toList(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'last ${provider.selectedDays}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Insights Stats
                    _buildInsightRow(Icons.remove_red_eye, 'Post Views', '245'),
                    _buildInsightRow(Icons.share, 'Shares', '12'),
                    _buildInsightRow(Icons.bookmark, 'Saves', '34'),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
