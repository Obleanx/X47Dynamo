import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Handle form submission
      if (kDebugMode) {
        print('Form Data: $_formData');
      }
    }
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
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle photo change
                        },
                        child: const Text('Change Photo'),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          // Handle become seller action
                        },
                        child: const Text(
                          'Become a Seller',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2BBCE7)),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                    onPressed: _saveForm,
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
