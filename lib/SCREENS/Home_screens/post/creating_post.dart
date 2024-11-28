import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kakra/PROVIDERS/home_provider.dart';
import 'package:kakra/PROVIDERS/posting_provider.dart';
import 'package:kakra/WIDGETS/kakra_button2.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// post_screen.dart
// Custom Expandable App Bar
class CustomExpandableAppBar extends StatelessWidget {
  const CustomExpandableAppBar({super.key});

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
                const CustomExpandableAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text Input Field
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
                            child: KakraButton2(
                              onPressed: postProvider.isLoading
                                  ? null
                                  : () => postProvider.createPost(),
                              isLoading: postProvider.isLoading,
                              child: Center(
                                child: postProvider.isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Create Post',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
}
