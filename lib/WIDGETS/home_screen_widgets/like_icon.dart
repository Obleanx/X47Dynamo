import 'package:flutter/material.dart';

int _likeCount = 0;
bool _isLiked = false;

Widget _buildLikeIcon(IconData icon, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: IconButton(
      icon: Icon(
        icon,
        size: 20,
        color: _isLiked ? Colors.red : Colors.black54,
      ),
      onPressed: () {
        onPressed();
        setState(() {
          _isLiked = !_isLiked;
          _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
        });
      },
    ),
  );
}

void setState(VoidCallback fn) {
  // Update the UI with the new state
  fn();
}

Widget build(BuildContext context) {
  return _buildLikeIcon(
    _isLiked ? Icons.favorite : Icons.favorite_border,
    () {
      // Implement like functionality
    },
  );
}
