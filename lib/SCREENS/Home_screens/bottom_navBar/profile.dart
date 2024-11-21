import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/sellers_HQ/seller_hq_screen.dart';
import 'package:kakra/SERVICES/media_services.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final MediaService _mediaService = MediaService();

  File? _profileImage;
  String? _profileImageUrl;
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
          setState(() {
            _profileImageUrl = userDoc.data()?['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update(_formData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  void _onChangeProfilePicture() {
    _mediaService.showImageSourceBottomSheet(
      context: context,
      onImageSelected: (File? image) async {
        if (image != null) {
          // Upload image to Firebase Storage
          final uploadedImageUrl = await _mediaService.uploadImage(
            imageFile: image,
            context: context,
          );

          // Update user profile in Firestore
          if (uploadedImageUrl != null) {
            try {
              final user = _auth.currentUser;
              if (user != null) {
                await _firestore.collection('users').doc(user.uid).update({
                  'profileImageUrl': uploadedImageUrl,
                });

                setState(() {
                  _profileImage = image;
                  _profileImageUrl = uploadedImageUrl;
                });
              }
            } catch (e) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error updating profile picture: $e')),
              );
            }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section
                Center(
                  child: Column(
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
                          child: _profileImageUrl != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_profileImageUrl!),
                                  radius: 50,
                                )
                              : _profileImage != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          FileImage(_profileImage!),
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
                      TextButton(
                        onPressed: _onChangeProfilePicture,
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
                  onSaved: (value) => _formData['africanPhone'] = value ?? '',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Foreign Phone Number',
                  onSaved: (value) => _formData['foreignPhone'] = value ?? '',
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
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
      ),
    );
  }
}
