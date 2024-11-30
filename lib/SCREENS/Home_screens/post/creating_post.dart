import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kakra/CORE/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kakra/WIDGETS/kakra_button2.dart';
import 'package:kakra/PROVIDERS/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakra/PROVIDERS/posting_provider.dart';

// post_screen.dart
// Custom Expandable App Bar

class CustomExpandableAppBar extends StatelessWidget {
  CustomExpandableAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 45),
            const Center(
              child: Text(
                'Create Post',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCreationScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  PostCreationScreen({super.key});

  //gets the users current location and adds it to the backennd
  Future<String?> _getCurrentLocation() async {
    try {
      // Request location permissions
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;

      // Get current position
      Position position = await Geolocator.getCurrentPosition();

      // Use geocoding to get readable address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String locationString =
            '${place.locality}, ${place.administrativeArea}';

        // Save location to Firestore for the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'location': locationString,
            'lastLocationUpdated': FieldValue.serverTimestamp(),
          });
        }

        return locationString;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
      return null;
    }
  }

  Future<void> _pickImage(
      BuildContext context, PostProvider provider, bool fromGallery) async {
    final XFile? image = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);

    if (image != null) {
      // Crop the image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        provider.setImagePath(croppedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: Scaffold(
        body: Consumer<PostProvider>(
          builder: (context, postProvider, child) {
            return Column(
              children: [
                CustomExpandableAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text Input Field for post contents.
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            maxLines: 5,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "What's on your mind?",
                            ),
                            onChanged: postProvider.setContent,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Camera and Gallery Icons
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _pickImage(context, postProvider, false),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  // color: Colors.grey.withOpacity(0.2),//
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.grey),
                              ),
                            ),
                            //const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () =>
                                  _pickImage(context, postProvider, true),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  //color: Colors.grey.withOpacity(0.2)//,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.photo_library,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Location
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FutureBuilder<String?>(
                              future: _getCurrentLocation(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Fetching location...');
                                }
                                if (snapshot.hasData) {
                                  postProvider.setLocation(snapshot.data!);
                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(color: Colors.grey),
                                  );
                                }
                                return const Text('Location unavailable');
                              },
                            ),
                          ],
                        ),

                        // Selected Image Preview
                        // Selected Image Preview with Remove Button
                        if (postProvider.imagePath != null) ...[
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(
                                        File(postProvider.imagePath!)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    // Remove the image
                                    postProvider.setImagePath(null);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        // Create Post Button
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: postProvider.isLoading
                                    ? null // Disable button while loading
                                    : () async {
                                        if (postProvider.content
                                            .trim()
                                            .isEmpty) {
                                          // Show dialog if content is empty
                                          showContentRequiredDialog(context);
                                        } else {
                                          // Call createPost and navigate to home
                                          await postProvider.createPost(
                                              context, context);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 10),
                                  backgroundColor: postProvider.isLoading
                                      ? Colors.grey
                                      : AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(200,
                                      50), // Set a fixed minimum width and height
                                ),
                                child: postProvider.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Create Post',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Show Validation Dialog
  void showContentRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/images/kk4.png', // Ensure this asset exists
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Oops! Something\'s Missing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'You need to write something before creating a post. Share your thoughts, feelings, or an update!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Got It',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
