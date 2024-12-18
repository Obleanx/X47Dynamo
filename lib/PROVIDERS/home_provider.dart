import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeProvider extends ChangeNotifier {
  // Method to fetch posts from Firestore
  Future<void> fetchPosts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      posts = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'avatar': data['userAvatar'] ?? 'lib/images/default_avatar.png',
          'name': data['userName'] ?? 'Anonymous',
          'group': data['location'] ?? 'General',
          'content': data['content'],
          'time': _formatTimestamp(data['timestamp']),
          'image': data['imageUrl'],
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  // Convert timestamp to readable format
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Just now';

    final now = DateTime.now();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h ago';
    } else {
      return '${difference.inDays} d ago';
    }
  }

  List<Map<String, dynamic>> posts = [
    {
      'avatar': 'lib/images/kk6.png',
      'name': 'Olamide bashiru',
      'group': 'Leeds group',
      'content':
          'Handcrafted by Nala creations, this vibrant jewelset celebrates African heritage',
      'time': '38min',
      'image': 'lib/images/kk7.png',
    },
    {
      'avatar': 'lib/images/kk8.png',
      'name': 'John',
      'group': 'Manchester group',
      'content': 'Exploring the rich culinary traditions of West Africa',
      'time': '1h',
      'image': 'lib/images/kk9.png',
    },
    {
      'avatar': 'lib/images/kk10.png',
      'name': 'Sarah',
      'group': 'London group',
      'content':
          'Discussing the impact of African literature on global culture',
      'time': '2h',
    },
    {
      'avatar': 'lib/images/kk8.png',
      'name': 'Sarah',
      'group': 'London group',
      'content':
          'Discussing the impact of African literature on global culture',
      'time': '2h',
    },
    {
      'avatar': 'lib/images/kk8.png',
      'name': 'John',
      'group': 'Manchester group',
      'content': 'Exploring the rich culinary traditions of West Africa',
      'time': '1h',
      'image': 'lib/images/kk11.png',
    },
    // Add more posts as needed
  ];

  final List<Map<String, dynamic>> _townSquarePosts = [
    // Your town square posts data

    {
      'avatar': 'lib/images/kk8.png',
      'group': 'Blacks in UK',
      'content': 'Happy to connect with everyone!',
      'time': '5 min ago',
      'image': 'lib/images/kk13.png',
    },
    {
      'avatar': 'lib/images/kk10.png',
      'group': 'Leeds Group',
      'content': 'Here are some amazing photos from my trip!',
      'time': '10 min ago',
      'image': 'lib/images/kk14.png',
    },
    {
      'avatar': 'lib/images/kk6.png',
      'group': 'London Group',
      'content': 'Looking forward to our next meetup!',
      'time': '20 min ago',
      'image': 'lib/images/kk7.png',
    },
  ];

  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  List<Map<String, dynamic>> get post =>
      _selectedCategoryIndex == 1 ? _townSquarePosts : posts;

  void setSelectedCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> replaceFirstPostWithLatest() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch the most recent post from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final latestPost = snapshot.docs.first.data();
        final timestamp = latestPost['timestamp'] as Timestamp?;
        final elapsedTime = timestamp != null
            ? _formatElapsedTime(timestamp.toDate())
            : 'Just now';

        // Replace the first post
        posts[0] = {
          'avatar':
              'lib/images/placeholder_avatar.png', // Default avatar if missing
          'name': latestPost['userName'] ?? 'Unknown',
          'group': latestPost['location'] ?? 'General',
          'content': latestPost['content'] ?? '',
          'time': elapsedTime,
          'image': latestPost['imageUrl'] ?? 'lib/images/placeholder_image.png',
        };
      }
    } catch (e) {
      debugPrint('Error fetching latest post: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper to format elapsed time from a timestamp
  String _formatElapsedTime(DateTime postTime) {
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
  // Add more methods as needed
}
