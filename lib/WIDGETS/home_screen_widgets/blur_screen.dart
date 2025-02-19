import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:kakra/SCREENS/Home_screens/Town%20square/town_square_screen.dart';
import 'package:kakra/SCREENS/Home_screens/market%20place/market_home_screen.dart';

class MenuOverlay extends StatelessWidget {
  const MenuOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background tap detector
          GestureDetector(
            onTap: () {
              Provider.of<FloatingButtonProvider>(context, listen: false)
                  .toggleMenu();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ),
          // Menu items
          Positioned(
            bottom: 60,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildMenuItem(
                    icon: Icons.groups_outlined,
                    label: 'Community',
                    iconColor: const Color(0xFF2486C2),
                    onTap: () {
                      print('Community tapped');
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Town Square',
                    iconColor: const Color(0xFF2486C2),
                    onTap: () {
                      // Add your Town Square functionality here //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TownSquareScreen()),
                      );
                      if (kDebugMode) {
                        print('Town Square tapped');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Market Place',
                    iconColor: const Color(0xFF2486C2),
                    onTap: () {
                      // Add your Market Place functionality here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MarketplaceContent(
                                  userId: 'userID',
                                )),
                      );
                      if (kDebugMode) {
                        print('Market Place tapped');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
