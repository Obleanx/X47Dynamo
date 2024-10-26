import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.blueGrey,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_outlined,
              color: Colors.blueGrey,
            ),
            label: 'Create'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.message_outlined,
              color: Colors.blueGrey,
            ),
            label: 'Messages'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_outlined,
              color: Colors.blueGrey,
            ),
            label: 'Profile'),
      ],
      onTap: (index) {
        // TODO: Implement navigation functionality
      },
    );
  }
}
