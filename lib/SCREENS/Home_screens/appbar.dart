import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Home_screens/hamburger.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/blur_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Hamburger()),
          );
        },
      ),
      title: Center(child: Image.asset('lib/images/kk4.png', height: 95)),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 25, color: Colors.black),
          onPressed: () {
            // TODO: Implement search functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {
            // TODO: Implement notifications functionality
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
