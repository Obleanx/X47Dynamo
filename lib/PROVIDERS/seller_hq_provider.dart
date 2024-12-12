import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // this method to switches the main image
  void switchMainImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      currentMainImageIndex = index;
      notifyListeners();
    }
  }

  // Reset the main image index to the first image when new images are picked
  int currentMainImageIndex = 0;

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
    if (kDebugMode) {
      print('Updating field: $field with value: $value');
    }
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

//sellers informations profile
  Future<void> createSellerProfile(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to create a seller profile'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Check if seller profile already exists
      final sellerDoc = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .get();

      if (sellerDoc.exists) {
        // Seller profile already exists, no need to create again
        return;
      }

      // Fetch user information from the users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User profile not found'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Extract user information
      final userData = userDoc.data()!;

      // Create seller profile document
      await FirebaseFirestore.instance.collection('sellers').doc(user.uid).set({
        'userId': user.uid,
        'firstName': userData['firstName'] ?? '',
        'lastName': userData['lastName'] ?? '',
        'foreignPhone': userData['foreignPhone'] ?? '',
        'location': userData['location'] ?? '',
        'profileImageUrl': userData['profileImageUrl'] ?? '',
        'sellerStatus': 'unverified', // Default status
        'accountCreatedAt': FieldValue.serverTimestamp(),
        'email': user.email ?? '',
      });

      if (kDebugMode) {
        print('Seller profile created successfully');
      } // Add this for debugging
    } catch (e) {
      if (kDebugMode) {
        print('Error creating seller profile: $e');
      } // Add this for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create seller profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> submitListing(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    if (!isFormValid) return;

    try {
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

      // Ensure seller profile exists
      await createSellerProfile(context);

      // Upload images to Firebase Storage
      List<String> imageUrls = await _uploadImages();

      // Professionally formatted description
      final formattedDescription = '''
**${productName ?? ''}** - Product Details

📦 Condition: ${condition ?? 'Not Specified'}
💰 Price: ${price ?? 'Not Specified'}

${description ?? ''}

Listing created with care on Kakra Marketplace
    ''';
      // Fetch the seller's email explicitly
      final sellerDoc = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .get();
      // Create a map of listing data to reuse
      final listingData = {
        'userId': user.uid,
        'sellerEmail': sellerDoc.data()?['email'] ??
            user.email, // Explicitly add seller email

        'sellerId': user.uid, // Explicitly add sellerId
        'sellerName':
            '${sellerDoc.data()?['firstName']} ${sellerDoc.data()?['lastName']}',
        'sellerProfileImage': sellerDoc.data()?['profileImageUrl'],

        'productName': productName,
        'price': double.parse(price!),
        'description': formattedDescription,
        'category': category,
        'condition': condition,
        'imageUrls': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Reference to the sellers collection
      final sellersRef = FirebaseFirestore.instance.collection('sellers');

      // Reference to the main listings collection
      final listingsRef = FirebaseFirestore.instance.collection('listings');

      // Create a new listing document in the main listings collection
      final mainListingDoc = await listingsRef.add(listingData);

      // Add the same listing to the seller's subcollection
      await sellersRef
          .doc(user.uid)
          .collection('listings')
          .doc(mainListingDoc.id)
          .set(listingData);

      // Set loading to false before showing success dialog
      _isLoading = false;
      notifyListeners();

      // Show success dialog and navigate
      await _showSuccessDialog(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const MarketplaceContent(
                    userId: 'userID',
                  )));
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('We could not submit your listing. Try again: $e'),
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
    notifyListeners();

    return imageUrls;
  }

  Future<void> _showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated check icon with a bit more flair
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 100,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Listing Created Successfully!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your product "$productName" is now live on Kakra Marketplace!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
