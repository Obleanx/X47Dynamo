import 'package:flutter/material.dart';
import 'dart:ui';

class TownSquarePostContainer extends StatelessWidget {
  final Map<String, dynamic> post;

  const TownSquarePostContainer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(post['avatar']),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['group'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post['content'],
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.black54),
                      const SizedBox(width: 5),
                      Text(post['time'],
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                  if (post.containsKey('image')) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(post['image'], fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            _buildGlassIcon(Icons.chat_bubble_outline, () {
                              // TODO: Implement chat functionality
                            }),
                            const SizedBox(width: 30),
                            _buildGlassIcon(Icons.favorite_border, () {
                              // TODO: Implement like functionality
                            }),
                            const SizedBox(width: 40),
                            _buildGlassIcon(Icons.flag_outlined, () {
                              // TODO: Implement flag functionality
                            }),
                          ],
                        ),
                        _buildGlassIcon(Icons.share, () {
                          // TODO: Implement share functionality
                        }),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildGlassIcon(IconData icon, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: IconButton(
      icon: Icon(icon, size: 20, color: Colors.black54),
      onPressed: onPressed,
    ),
  );
}
