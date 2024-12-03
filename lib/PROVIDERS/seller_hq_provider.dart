import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kakra/SCREENS/Home_screens/market%20place/market_home_screen.dart';

class SellerHQProvider extends ChangeNotifier {
  List<XFile> pickedImages = [];
  String? productName;
  String? price;
  String? description;
  String? category;
  String? condition;

  // Add this method to switch the main image
  void switchMainImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      currentMainImageIndex = index;
      notifyListeners();
    }
  }

  // Reset the main image index to the first image when new images are picked
  int currentMainImageIndex = 0;
  @override
  notifyListeners();

  Future<void> pickImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (images.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least 4 images'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (images.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 10 images allowed'),
          backgroundColor: Colors.red,
        ),
      );
      pickedImages = images.sublist(0, 10);
    } else {
      pickedImages = images;
    }
    notifyListeners();
  }

  void updateField(String field, String value) {
    switch (field) {
      case 'productName':
        productName = value;
        break;
      case 'price':
        price = value;
        break;
      case 'description':
        description = value;
        break;
      case 'category':
        category = value;
        break;
      case 'condition':
        condition = value;
        break;
    }
    notifyListeners();
  }

  bool get isFormValid {
    return productName != null &&
        productName!.length >= 3 &&
        price != null &&
        double.tryParse(price!) != null &&
        double.parse(price!) > 0 &&
        description != null &&
        description!.length >= 20 &&
        category != null &&
        condition != null &&
        pickedImages.length >= 4 &&
        pickedImages.length <= 10;
  }

  Future<void> submitListing(BuildContext context) async {
    if (!isFormValid) return;

    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = await _uploadImages();

      // Create listing document in Firestore
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to create a listing'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Professionally formatted description
      final formattedDescription = '''
**${productName ?? ''}** - Product Details

📦 Condition: ${condition ?? 'Not Specified'}
💰 Price: ${price ?? 'Not Specified'}

${description ?? ''}

Listing created with care on Kakra Marketplace
      ''';

      await FirebaseFirestore.instance.collection('listings').add({
        'userId': user.uid,
        'productName': productName,
        'price': double.parse(price!),
        'description': formattedDescription,
        'category': category,
        'condition': condition,
        'imageUrls': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success dialog
      await _showSuccessDialog(context);

      // Navigate to Marketplace
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MarketplaceContent()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('we could not submit your listings try again: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<String>> _uploadImages() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final storageRef = FirebaseStorage.instance.ref();
    List<String> imageUrls = [];

    for (var image in pickedImages) {
      // Use the user's UID in the path
      final imageRef = storageRef.child(
          'listings/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${image.name}');

      // Use putFile with File
      await imageRef.putFile(File(image.path));

      final imageUrl = await imageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<void> _showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Listing Created Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              'Your product "$productName" is now live on Kakra Marketplace!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
