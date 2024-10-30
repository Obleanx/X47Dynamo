import 'package:flutter/material.dart';
import 'dart:ui'; // Import for BackdropFilter

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
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('lib/images/kr5.png'),
                ),
                const SizedBox(width: 5),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fola ojo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Edit your profile',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 70),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shortcuts Section
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
                  _buildSocialButton(context, 'Facebook', Icons.facebook),
                  const SizedBox(height: 20),
                  _buildSocialButton(context, 'Twitter', Icons.tiktok),
                  const SizedBox(height: 20),
                  _buildSocialButton(
                      context, 'WhatsApp', Icons.facebook_outlined),
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
      // Remove unnecessary Stack since we want the blur to cover everything
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
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
      ),
    );
  }

  Widget _buildSocialButton(
      BuildContext context, String platform, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 56, // Fixed height for consistency
      // Remove unnecessary Stack
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 24, color: Colors.blue),
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
          ),
        ),
      ),
    );
  }
}
