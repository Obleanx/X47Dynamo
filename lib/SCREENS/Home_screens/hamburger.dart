import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/profile.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              ),
            ),
            title: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                final user = FirebaseAuth.instance.currentUser;
                final profileImageUrl = profileProvider.profileImageUrl;
                final firstName = profileProvider.firstName ?? 'User';
                final lastName = profileProvider.lastName ?? '';

                if (profileProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                        if (kDebugMode) {
                          print('Profile section tapped');
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: profileImageUrl != null &&
                                    profileImageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(profileImageUrl)
                                : const AssetImage('lib/images/kr5.png')
                                    as ImageProvider,
                            child: profileImageUrl == null ||
                                    profileImageUrl.isEmpty
                                ? Icon(Icons.person, color: Colors.grey[400])
                                : null,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '$firstName ${lastName.isNotEmpty ? lastName : ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Edit your profile',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your shortcut',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // Image Background
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'lib/images/kk${16 + index}.png', // Dynamically references kk17.png to kk20.png
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Positioned Icon at Bottom Right
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.groups_outlined,
                                    size: 16,
                                    color: Color(0xFF2486C2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 70),
                  // Menu Items - Redesigned as grid
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildMenuItem(context, 'Town square', Icons.people),
                      _buildMenuItem(
                          context, 'Community', Icons.groups_outlined),
                      _buildMenuItem(context, 'Market square', Icons.store),
                      _buildMenuItem(context, 'Feeds', Icons.rss_feed),
                      _buildMenuItem(context, 'Saved', Icons.bookmark),
                      _buildMenuItem(context, 'Support', Icons.help),
                    ],
                  ),
                  const SizedBox(height: 44),

                  // Share Section - Redesigned to match menu items
                  const Text(
                    'Share',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                      context, 'Facebook', FontAwesomeIcons.facebook),
                  const SizedBox(height: 20),
                  // _buildSocialButton(
                  // context, 'Twitter', FontAwesomeIcons.twitter),
                  _buildSocialButton(context, 'LinkedIn',
                      FontAwesomeIcons.linkedin), // LinkedIn button
                  const SizedBox(height: 20),

                  _buildSocialButton(
                      context, 'WhatsApp', FontAwesomeIcons.whatsapp),

                  const SizedBox(height: 20),
                  _buildSocialButton(
                      context, 'X', FontAwesomeIcons.xTwitter), // Updated for X
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    return Container(
      width: (MediaQuery.of(context).size.width - 50) / 2,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color to white
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade300, // Ash-colored border
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2486C2)),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      BuildContext context, String platform, IconData icon) {
    // Map platform names to their branded colors
    final Map<String, Color> platformColors = {
      'Facebook': const Color(0xFF1877F2), // Facebook blue
      'X': Colors.black, // X branding uses black
      'WhatsApp': const Color(0xFF25D366), // WhatsApp green
      'LinkedIn': const Color(0xFF0077B5), // LinkedIn blue
    };

    // Get the color for the platform, or default to grey
    final Color iconColor = platformColors[platform] ?? Colors.grey;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 56, // Fixed height for consistency
      decoration: BoxDecoration(
        color: Colors.white, // Solid white background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300, // Ash-colored border
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 24, color: iconColor), // Icon with branded color
          const SizedBox(width: 10),
          Text(
            platform,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
