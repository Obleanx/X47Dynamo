import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kakra/WIDGETS/reusable_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kakra/WIDGETS/contents_filter/filter.dart';
import 'package:kakra/WIDGETS/MARKET_PLACE/product_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerDetailsScreen extends StatefulWidget {
  final String sellerEmail;

  const SellerDetailsScreen({super.key, required this.sellerEmail});

  @override
  State<SellerDetailsScreen> createState() => _SellerDetailsScreenState();
}

class _SellerDetailsScreenState extends State<SellerDetailsScreen> {
  // Helper method to format date
  String _formatJoinDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';

    final DateTime joinDate = timestamp.toDate();
    return '${joinDate.day} ${_getMonthName(joinDate.month)} ${joinDate.year}';
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
  //image picker and fetcher method

  Future<void> _updateBackgroundImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        // Upload to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('seller_backgrounds')
            .child('${widget.sellerEmail}_background.jpg');

        await storageRef.putFile(File(croppedFile.path));
        final downloadURL = await storageRef.getDownloadURL();

        // Update Firestore document
        await FirebaseFirestore.instance
            .collection('sellers')
            .where('email', isEqualTo: widget.sellerEmail)
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.first.reference
                .update({'backgroundImageUrl': downloadURL});
          }
        });

        setState(() {
          // Trigger rebuild to show new background
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('sellers')
                .where('email', isEqualTo: widget.sellerEmail)
                .limit(1)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Seller not found'));
              }

              final sellerData =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Bar
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Expanded(
                                  child: Text(
                                    "${sellerData['firstName']}'s Details", // Using double quotes
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 48), // Placeholder for alignment
                              ],
                            ),
                          ),

                          // Profile Banner and Avatar
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: _updateBackgroundImage,
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: sellerData['backgroundImageUrl'] !=
                                              null
                                          ? NetworkImage(
                                              sellerData['backgroundImageUrl'])
                                          : const AssetImage(
                                                  'lib/images/kk14.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -50,
                                left: 20,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        sellerData['profileImageUrl'] != null
                                            ? NetworkImage(
                                                sellerData['profileImageUrl'])
                                            : const AssetImage(
                                                'lib/images/fdp7.jpg'),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Seller Info
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${sellerData['firstName']} ${sellerData['lastName']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Joined on ${_formatJoinDate(sellerData['accountCreatedAt'])}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'About me',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 13),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: SvgPicture.string(
                                        '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <path fill="#2486C2" d="M22.5 12.5c0-1.58-.875-2.95-2.148-3.6.154-.435.238-.905.238-1.4 0-2.21-1.71-3.998-3.818-3.998-.47 0-.92.084-1.336.25C14.818 2.415 13.51 1.5 12 1.5s-2.816.917-3.437 2.25c-.415-.165-.866-.25-1.336-.25-2.11 0-3.818 1.79-3.818 4 0 .494.083.964.237 1.4-1.272.65-2.147 2.018-2.147 3.6 0 1.495.782 2.798 1.942 3.486-.02.17-.032.34-.032.514 0 2.21 1.708 4 3.818 4 .47 0 .92-.086 1.335-.25.62 1.334 1.926 2.25 3.437 2.25 1.512 0 2.818-.916 3.437-2.25.415.163.865.248 1.336.248 2.11 0 3.818-1.79 3.818-4 0-.174-.012-.344-.033-.513 1.158-.687 1.943-1.99 1.943-3.484zm-6.616-3.334l-4.334 6.5c-.145.217-.382.334-.625.334-.143 0-.288-.04-.416-.126l-.115-.094-2.415-2.415c-.293-.293-.293-.768 0-1.06s.768-.294 1.06 0l1.77 1.767 3.825-5.74c.23-.345.696-.436 1.04-.207.346.23.44.696.21 1.04z"/>
            </svg>''',
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    const Text(
                                      'Verified',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(sellerData['location'] ??
                                        'Location not specified'),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Divider(),

                          // Listings Section
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "See ${sellerData['firstName']}'s Listings",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.sliders,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      _showCreateModal(
                                          context); // Directly show the modal
                                    }),
                              ],
                            ),
                          ),

                          // Product Grid - Fetch Seller's Listings
                          FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('listings')
                                .where('sellerEmail',
                                    isEqualTo: widget.sellerEmail)
                                .get(),
                            builder: (context, listingsSnapshot) {
                              if (listingsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!listingsSnapshot.hasData ||
                                  listingsSnapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('No listings found'));
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio:
                                      0.65, // Reduced to allow more space for text
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                itemCount: listingsSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final listing =
                                      listingsSnapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;

                                  // Extract the image URL safely
                                  String? imageUrl = '';
                                  if (listing['imageUrls'] != null &&
                                      listing['imageUrls'] is List &&
                                      (listing['imageUrls'] as List)
                                          .isNotEmpty) {
                                    imageUrl =
                                        (listing['imageUrls'] as List).first;
                                  }

                                  // Build each product item
                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Product Image
                                            AspectRatio(
                                              aspectRatio: 1, // Square image
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  image: DecorationImage(
                                                    image: imageUrl != null &&
                                                            imageUrl.isNotEmpty
                                                        ? NetworkImage(imageUrl)
                                                        : const AssetImage(
                                                                'lib/images/default_image.png')
                                                            as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Product Name
                                                  Text(
                                                    listing['productName'] ??
                                                        'Unknown Product',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),

                                                  const SizedBox(
                                                      height:
                                                          2), // Small space between name and price

                                                  // Product Price
                                                  Text(
                                                    '₦ ${(listing['price'] ?? 0.0).toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: KakraButton(
                          text: 'Message seller',
                          onPressed: () {
                            // _showCreateModal(context); // Directly show the modal
                          },
                        )),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

void _showCreateModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true, // Enables outside-tap dismissal
    backgroundColor: Colors.transparent, // Transparent to show blur effect
    builder: (context) {
      return Stack(
        children: [
          // Background Blur
          GestureDetector(
            onTap: () =>
                Navigator.pop(context), // Tapping outside closes the modal
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),
          // Modal Content
          const CreateModal2(), // Use the reusable modal widget here
        ],
      );
    },
  );
}
