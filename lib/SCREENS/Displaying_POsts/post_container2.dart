import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostContainer2 extends StatefulWidget {
  final Map<String, dynamic> postData;

  const PostContainer2({super.key, required this.postData});

  @override
  State<PostContainer2> createState() => _PostContainer2State();
}

class _PostContainer2State extends State<PostContainer2> {
  bool _isLiked = false;
  int _likeCount = 0;
  String? _userLocation;

  @override
  void initState() {
    super.initState();
    _fetchLikeStatus();
    _fetchUserLocation();
  }

  // Fetch location from Firebase (or another source)
  Future<void> _fetchUserLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          _userLocation = userDoc[
              'location']; // Assuming location field exists in Firestore
        });
      } catch (e) {
        print('Error fetching user location: $e');
      }
    }
  }

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
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header
                  _buildUserHeader(context),

                  // Post Content
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.postData['content'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  // Post Metadata
                  _buildPostMetadata(context),

                  // Post Image (if exists)
                  if (widget.postData['imageUrl'] != null) _buildPostImage(),
                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // User Header with Profile Image
  Widget _buildUserHeader(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = FirebaseAuth.instance.currentUser;
        final profileImageUrl = profileProvider.profileImageUrl;
        final location =
            _userLocation ?? 'Unknown Location'; // Use _userLocation here

        if (profileProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              backgroundImage: profileImageUrl != null &&
                      profileImageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(profileImageUrl) as ImageProvider
                  : const AssetImage('lib/images/kr5.png'),
              child: profileImageUrl == null || profileImageUrl.isEmpty
                  ? Icon(Icons.person, color: Colors.grey[400])
                  : null,
            ),
            const SizedBox(width: 10),
            // User Name (e.g., FirstName LastName)
            // User Name and Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profileProvider.firstName ?? ''} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  location, // Display user's location
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPostImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: widget.postData['imageUrl'],
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildPostMetadata(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 16),
          const SizedBox(width: 5),
          Text(
            _formatTimestamp(widget.postData['timestamp']),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            // Comment Button
            _buildGlassIconButton(
              icon: Icons.comment_outlined,
              onPressed: () {
                // TODO: Implement comment functionality
              },
            ),
            const SizedBox(width: 30),
            // Like Button
            _buildLikeButton(context),
            const SizedBox(width: 30),
            // Flag Button
            _buildGlassIconButton(
              icon: Icons.flag_outlined,
              onPressed: () {
                // TODO: Implement flag functionality
              },
            ),
          ],
        ),
        const SizedBox(width: 30),

        // Share Button
        _buildGlassIconButton(
          icon: Icons.share,
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
      ],
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      child: IconButton(
        icon: Icon(icon, color: Colors.black54, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : null,
            ),
            onPressed: _toggleLike,
          ),
          const SizedBox(width: 1),
          Text(
            '$_likeCount',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown time';

    final now = DateTime.now();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  Future<void> _fetchLikeStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      // Fetch the post document
      final postDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postData['postId'])
          .get();

      // Check if the current user has liked the post
      final likedByField = postDoc.data()?['likedBy'] as List? ?? [];

      setState(() {
        _isLiked = likedByField.contains(currentUser.uid);
        _likeCount = postDoc.data()?['likes'] ?? 0;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching like status: $e');
      }
    }
  }

  Future<void> _toggleLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postData['postId']);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the latest post data
        final postSnapshot = await transaction.get(postRef);

        // Ensure data exists
        if (!postSnapshot.exists) return;

        // Get current likedBy list or create an empty list
        final likedBy =
            List<String>.from(postSnapshot.data()?['likedBy'] ?? []);
        int currentLikes = postSnapshot.data()?['likes'] ?? 0;

        if (likedBy.contains(currentUser.uid)) {
          // User already liked, so unlike
          likedBy.remove(currentUser.uid);
          currentLikes--;
        } else {
          // User hasn't liked, so like
          likedBy.add(currentUser.uid);
          currentLikes++;
        }

        // Update the document
        transaction.update(postRef, {
          'likedBy': likedBy,
          'likes': currentLikes,
        });

        // Update local state
        setState(() {
          _isLiked = likedBy.contains(currentUser.uid);
          _likeCount = currentLikes;
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling like: $e');
      }
    }
  }
}
