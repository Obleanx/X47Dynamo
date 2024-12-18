import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:kakra/providers/home_provider.dart';
import 'Town square/town_square_post_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kakra/SCREENS/Home_screens/appbar.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:kakra/SCREENS/Home_screens/post_containers.dart';
import 'package:kakra/SCREENS/Displaying_POsts/post+provider2.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/blur_screen.dart';
import 'package:kakra/SCREENS/Displaying_POsts/post_container2.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/welcom_texts.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/category_slider.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/shazam_likebutton.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => FloatingButtonProvider()),
        ChangeNotifierProvider(
            create: (_) => PostProvider2()), // Ensure this is provided
      ],
      child: Consumer<FloatingButtonProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: const CustomAppBar(),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const UserGreeting(),
                          const CategorySlider(),
                          // Firebase Posts
                          Consumer<PostProvider2>(
                            builder: (context, postProvider, child) {
                              return _buildFirebasePosts(postProvider);
                            },
                          ),
                          Consumer<HomeProvider>(
                            builder: (context, homeProvider, child) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: homeProvider.posts.length,
                                itemBuilder: (context, index) {
                                  return homeProvider.selectedCategoryIndex == 1
                                      ? TownSquarePostContainer(
                                          post: homeProvider.posts[index])
                                      : PostContainer(
                                          post: homeProvider.posts[index]);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: const CustomBottomNavBar(),
                floatingActionButton: const CustomFloatingActionButton(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked,
              ),
              if (provider.isMenuOpen)
                const Positioned.fill(
                  child: MenuOverlay(),
                ),
            ],
          );
        },
      ),
    );
  }
}

// Modify your _buildFirebasePosts method to include dynamic profile image fetching
Widget _buildFirebasePosts(PostProvider2 postProvider) {
  return FutureBuilder<Stream<QuerySnapshot>>(
    future: postProvider.getLocationPrioritizedPosts(),
    builder: (context, locationStreamSnapshot) {
      if (locationStreamSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (locationStreamSnapshot.hasError) {
        return Center(child: Text('Error: ${locationStreamSnapshot.error}'));
      }

      if (!locationStreamSnapshot.hasData) {
        return const Center(child: Text('Failed to load posts'));
      }

      return StreamBuilder<QuerySnapshot>(
        stream: locationStreamSnapshot.data,
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postSnapshot.hasError) {
            return Center(child: Text('Error: ${postSnapshot.error}'));
          }

          if (!postSnapshot.hasData || postSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: postSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var postData =
                  postSnapshot.data!.docs[index].data() as Map<String, dynamic>;
              postData['postId'] = postSnapshot.data!.docs[index].id;

              return FutureBuilder<String?>(
                future: fetchUserProfileImage(postData['userId']),
                builder: (context, profileImageSnapshot) {
                  if (profileImageSnapshot.hasData &&
                      profileImageSnapshot.data != null) {
                    postData['userProfilePic'] = profileImageSnapshot.data;
                  }

                  if (kDebugMode) {
                    print('Post Data: $postData');
                  }

                  return PostContainer2(
                    key: ValueKey(postData['postId']),
                    postData: {
                      ...postData,
                      'userName': postData['userName'] ?? 'Unknown User',
                      'userProfilePic': postData['userProfilePic'] ?? '',
                      'location':
                          postData['location'] ?? 'Location not specified'
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

Future<String?> fetchUserProfileImage(String userId) async {
  try {
    // Reference to the profile pictures directory in Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('$userId.jpg');

    // Try to get the download URL
    final downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching profile image for user $userId: $e');
    }
    return null;
  }
}
