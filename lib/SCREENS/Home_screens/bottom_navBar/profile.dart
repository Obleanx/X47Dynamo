import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:kakra/SCREENS/sellers_HQ/seller_hq_screen.dart';
import 'package:kakra/SERVICES/media_services.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';
import 'package:provider/provider.dart';

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
            final uploadedImageUrl = await _mediaService.uploadImage(
              imageFile: image,
              context: context,
            );

            if (uploadedImageUrl != null) {
              // Update Firestore with new image URL
              await _firestore
                  .collection('users')
                  .doc(user.uid)
                  .update({'profileImageUrl': uploadedImageUrl});
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error in _onChangeProfilePicture: $e');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating profile picture: $e')),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  builder: (context) => const SellerHQScreen(),
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
                    CustomTextField(
                      label: 'First Name',
                      onSaved: (value) => _formData['firstName'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Last Name',
                      onSaved: (value) => _formData['lastName'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Email Address',
                      onSaved: (value) => _formData['email'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'African Phone Number',
                      onSaved: (value) =>
                          _formData['africanPhone'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Foreign Phone Number',
                      onSaved: (value) =>
                          _formData['foreignPhone'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Professional Background',
                      onSaved: (value) => _formData['background'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Gender',
                      onSaved: (value) => _formData['gender'] = value ?? '',
                    ),
                    const SizedBox(height: 24),

                    // Other Information Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Center(
                        child: Text(
                          'Other Information',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Language',
                      onSaved: (value) => _formData['language'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Current Location',
                      onSaved: (value) => _formData['location'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Your current HomeTown in Africa',
                      onSaved: (value) => _formData['location'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Interests',
                      onSaved: (value) => _formData['interests'] = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Skills',
                      onSaved: (value) => _formData['skills'] = value ?? '',
                    ),
                    const SizedBox(height: 24),

                    // Save Button for storing the user data in the database.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState
                                ?.save(); // Save all form field values
                            try {
                              // Show loading indicator
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Saving your information...')),
                              );

                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                throw Exception(
                                    'User not authenticated. Please log in again.');
                              }

                              // Save to Firestoredatabase, please be care full here
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .set({
                                'firstName': _formData['firstName'] ?? '',
                                'lastName': _formData['lastName'] ?? '',
                                'email': _formData['email'] ?? '',
                                'africanPhone': _formData['africanPhone'] ?? '',
                                'foreignPhone': _formData['foreignPhone'] ?? '',
                                'background': _formData['background'] ?? '',
                                'gender': _formData['gender'] ?? '',
                                'language': _formData['language'] ?? '',
                                'location': _formData['location'] ?? '',
                                'homeTown': _formData['homeTown'] ?? '',
                                'interests': _formData['interests'] ?? '',
                                'skills': _formData['skills'] ?? '',
                                'updatedAt': FieldValue
                                    .serverTimestamp(), // Add timestamp
                              });

                              // Success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Information saved successfully!')),
                              );
                            } catch (e) {
                              // Error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to save information: $e')),
                              );
                            }
                          } else {
                            // Validation error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please fill out all required fields.')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2BBCE7),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
