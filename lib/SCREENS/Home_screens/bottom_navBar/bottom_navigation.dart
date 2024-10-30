import 'package:flutter/material.dart';

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
            // Navigate to Create
            Navigator.pushNamed(context, '/create');
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
}
