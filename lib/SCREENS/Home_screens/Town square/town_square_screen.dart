import 'package:flutter/material.dart';
import 'town_square_post_container.dart';

class TownSquareScreen extends StatelessWidget {
  final List<Map<String, dynamic>> posts = [
    {
      'avatar': 'lib/images/kk8.png',
      'group': 'Blacks in UK',
      'content': 'Happy to connect with everyone!',
      'time': '5 min ago',
      'image': 'lib/images/kk17.png',
    },
    {
      'avatar': 'lib/images/kk10.png',
      'group': 'Leeds Group',
      'content': 'Here are some amazing photos from my trip!',
      'time': '10 min ago',
      'image': 'lib/images/kk11.png',
    },
    {
      'avatar': 'lib/images/kk6.png',
      'group': 'London Group',
      'content': 'Looking forward to our next meetup!',
      'time': '20 min ago',
      'image': 'lib/images/kk7.png',
    },
    // Add more posts as needed
  ];

  TownSquareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return TownSquarePostContainer(post: posts[index]);
          },
        ),
      ),
    );
  }
}
