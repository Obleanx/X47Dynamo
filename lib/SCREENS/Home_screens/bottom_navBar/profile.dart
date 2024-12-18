import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakra/SERVICES/media_services.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';
import 'package:kakra/WIDGETS/profile_textfields.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:kakra/PROVIDERS/profile_update_provider.dart';
import 'package:kakra/SCREENS/sellers_HQ/seller_hq_screen.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

// Update ProfileScreen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final MediaService _mediaService = MediaService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _provider = UserProfileProvider();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final provider = Provider.of<ProfileProvider>(context, listen: false);
          provider.setProfileImageUrl(userDoc.data()?['profileImageUrl']);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }

  void _onChangeProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }

    _mediaService.showImageSourceDialog(
      context: context,
      onImageSelected: (File? image) async {
        if (image != null) {
          try {
            // Upload the new profile picture
            final uploadedImageUrl = await _mediaService.uploadImage(
              imageFile: image,
              context: context,
            );

            if (uploadedImageUrl != null) {
              // Update profile picture in 'users' collection
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'profileImageUrl': uploadedImageUrl});

              // Update profile picture in all posts made by the user
              final userPosts = FirebaseFirestore.instance
                  .collection('posts')
                  .where('userId', isEqualTo: user.uid);

              final postsSnapshot = await userPosts.get();

              for (var post in postsSnapshot.docs) {
                await post.reference
                    .update({'userProfilePic': uploadedImageUrl});
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile picture updated!')),
              );
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error updating profile picture: $e');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating profile picture: $e')),
            );
          }
        }
      },
    );
  }

  // Use the UserProfileProvider you defined
  late UserProfileProvider _provider;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _provider.saveUserProfile(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);

    return ChangeNotifierProvider<UserProfileProvider>(
      create: (_) => UserProfileProvider(),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Edit Your Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Consumer<ProfileProvider>(builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _onChangeProfilePicture,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: provider.profileImageUrl != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                provider.profileImageUrl!),
                                            radius: 50,
                                          )
                                        : const CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                if (provider.isLoading)
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            TextButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : _onChangeProfilePicture,
                              child: const Text('Change Photo'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SellerHQScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Become a Seller',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2BBCE7),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                      // Personal Information Fields
                      ProfileTextField(
                        label: 'First Name',
                        providerKey:
                            'firstName', // Specify the key in the provider
                        isRequired: true,
                        validator: (value) => Provider.of<UserProfileProvider>(
                                context,
                                listen: false)
                            .validateName(value, isRequired: true),
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        label: 'Last Name',
                        providerKey: 'lastName',
                        isRequired: true,
                        validator: (value) => Provider.of<UserProfileProvider>(
                                context,
                                listen: false)
                            .validateName(value, isRequired: true),
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        label: 'Email Address',
                        providerKey: 'email',
                        isRequired: true,
                        validator: (value) => Provider.of<UserProfileProvider>(
                                context,
                                listen: false)
                            .validateEmail(value),
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        label: 'African Phone Number',
                        providerKey: 'africanPhone',
                        validator: (value) => Provider.of<UserProfileProvider>(
                                context,
                                listen: false)
                            .validatePhoneNumber(value, isRequired: true),
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        label: 'Foreign Phone Number',
                        providerKey: 'foreignPhone',
                        validator: (value) => Provider.of<UserProfileProvider>(
                                context,
                                listen: false)
                            .validatePhoneNumber(value),
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        label: 'Professional Background',
                        providerKey: 'background',
                        validator: (value) =>
                            null, // Optional field, no validation needed
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        label: 'Gender',
                        providerKey: 'gender',
                        validator: (value) =>
                            null, // Optional field, no validation needed
                      ),
                      const SizedBox(height: 24),

                      // Other Information Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Center(
                          child: Text(
                            'Other Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'Language',
                        providerKey: 'language',
                      ),

                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'Current Location',
                        providerKey: 'location',
                      ),
                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'State/Region you reside',
                        providerKey: 'state',
                      ),
                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'Country',
                        providerKey: 'country',
                      ),
                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'Permanent Address',
                        providerKey: 'permanentAddress',
                      ),
                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'HomeTown in Africa (country & state)',
                        providerKey: 'hometown',
                      ),
                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'Interests',
                        providerKey: 'interests',
                      ),
                      const SizedBox(height: 16),
                      const ProfileTextField(
                        label: 'Skills',
                        providerKey: 'skills',
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      Consumer<UserProfileProvider>(
                        builder: (context, provider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        final success = await provider
                                            .saveUserProfile(context);
                                        if (success) {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                              child: provider.isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Save Profile'),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}
