import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:kakra/WIDGETS/pop_scaffold.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blueGrey,
      showUnselectedLabels: true,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.home_outlined,
              color: Colors.blueGrey,
              size: 20,
            ),
          ),
          activeIcon: const Icon(Icons.home, color: Colors.blue, size: 30),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.add_circle_outline_outlined,
              color: Colors.blueGrey,
              size: 20,
            ),
          ),
          activeIcon:
              const Icon(Icons.add_circle, color: Colors.green, size: 30),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.message_outlined,
              color: Colors.blueGrey,
              size: 20,
            ),
          ),
          activeIcon: const Icon(Icons.message, color: Colors.orange, size: 30),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.person_2_outlined,
              color: Colors.blueGrey,
              size: 20,
            ),
          ),
          activeIcon: const Icon(Icons.person, color: Colors.purple, size: 30),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            // Navigate to Home
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            // Show Create Modal
            _showCreateModal(context);
            break;
          case 2:
            // Navigate to Messages
            Navigator.pushNamed(context, '/messages');
            break;
          case 3:
            // Navigate to Profile
            Navigator.pushNamed(context, '/profile');
            break;
          default:
            break;
        }
      },
    );
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
            const CreateModal(), // Use the reusable modal widget here
          ],
        );
      },
    );
  }
}
