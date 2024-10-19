import 'package:flutter/material.dart';
import 'dart:ui';

class PostContainer extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostContainer({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                        child: Text(
                          '${post['name']} posted in ${post['group']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.more_vert, color: Colors.black54),
                        onPressed: () {
                          // TODO: Implement more options functionality
                        },
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
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildGlassIcon(Icons.chat_bubble_outline, () {
                            // TODO: Implement chat functionality
                          }),
                          const SizedBox(width: 10),
                          _buildGlassIcon(Icons.favorite_border, () {
                            // TODO: Implement like functionality
                          }),
                          const SizedBox(width: 10),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassIcon(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black54),
        onPressed: onPressed,
      ),
    );
  }
}
