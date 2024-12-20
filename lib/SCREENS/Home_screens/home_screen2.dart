import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/category_slider.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  void setSelectedCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }
}

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CategorySlider(), // Your existing category slider
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Handle error state
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // Handle no data
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No posts available'),
                  );
                }

                // Convert snapshot to list of posts
                final posts = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'id': doc.id,
                    'avatar':
                        data['userAvatar'] ?? 'lib/images/default_avatar.png',
                    'name': data['userName'] ?? 'Anonymous',
                    'group': data['location'] ?? 'General',
                    'content': data['content'] ?? '',
                    'time': _formatTimestamp(data['timestamp']),
                    'image': data['imageUrl'],
                  };
                }).toList();

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostContainer(post: posts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Timestamp formatting method
  static String _formatTimestamp(Timestamp? timestamp) {
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
}

class PostContainer extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostContainer({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and name
          ListTile(
            leading: CircleAvatar(
              backgroundImage: _getAvatarImage(),
            ),
            title: Text(
              post['name'] ?? 'Anonymous',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post['group'] ?? 'General',
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              post['content'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Post image (if exists)
          if (post['image'] != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                post['image'],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

          // Time and interactions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  post['time'] ?? 'Unknown time',
                  style: const TextStyle(color: Colors.grey),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // Implement like functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // Implement comment functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getAvatarImage() {
    final avatar = post['avatar'];
    if (avatar == null) {
      return const AssetImage('lib/images/default_avatar.png');
    }

    if (avatar.toString().startsWith('http')) {
      return NetworkImage(avatar);
    }

    return AssetImage(avatar);
  }
}
