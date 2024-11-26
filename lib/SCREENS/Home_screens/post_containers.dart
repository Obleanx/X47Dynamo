import 'package:flutter/material.dart';
import 'dart:ui';

class PostContainer extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostContainer({super.key, required this.post});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

int _likeCount = 0;
bool _isLiked = false;

class _PostContainerState extends State<PostContainer> {
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
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(widget.post['avatar']),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${widget.post['name']} posted in ${widget.post['group']}',
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
                    widget.post['content'],
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.black54),
                      const SizedBox(width: 5),
                      Text(widget.post['time'],
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                  if (widget.post.containsKey('image')) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          Image.asset(widget.post['image'], fit: BoxFit.cover),
                    ),
                  ],
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
                          _buildGlassIcon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            () {
                              setState(() {
                                _isLiked = !_isLiked;
                                _likeCount =
                                    _isLiked ? _likeCount + 1 : _likeCount - 1;
                              });
                            },
                          ),
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
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: icon == Icons.favorite
              ? (_isLiked ? Colors.red : Colors.black54)
              : Colors.black54,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
