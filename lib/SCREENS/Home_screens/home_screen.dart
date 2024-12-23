import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:kakra/PROVIDERS/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:kakra/SCREENS/Home_screens/Town%20square/town_square_post_container.dart';

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

// Modified _buildFirebasePosts method with better error handling
Widget _buildFirebasePosts(PostProvider2 postProvider) {
  return StreamBuilder<List<DocumentSnapshot>>(
    stream: postProvider.getPosts(),
    builder: (context, snapshot) {
      // Print debug information
      if (kDebugMode) {
        print('StreamBuilder state: ${snapshot.connectionState}');
      }
      // ignore: curly_braces_in_flow_control_structures
      if (snapshot.hasError) if (kDebugMode) {
        print('StreamBuilder error: ${snapshot.error}');
      }
      if (snapshot.hasData) {
        if (kDebugMode) {
          print('StreamBuilder data length: ${snapshot.data?.length}');
        }
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(
            'Error loading posts: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.post_add, size: 48, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'No posts available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          try {
            var postDoc = snapshot.data![index];
            var postData = postDoc.data() as Map<String, dynamic>;
            postData['postId'] = postDoc.id;

            // Ensure all required fields are present
            final processedPostData = {
              ...postData,
              'userName': postData['userName'] ?? 'Unknown User',
              'userProfilePic': postData['userProfilePic'] ?? '',
              'location': postData['location'] ?? 'Location not specified',
              'timestamp': postData['timestamp'] ?? Timestamp.now(),
              'userId': postData['userId'] ?? '', // Ensure userId is included
            };

            return PostContainer2(
              key: ValueKey(processedPostData['postId']),
              postData: processedPostData,
            );
          } catch (e) {
            if (kDebugMode) {
              print('Error building post at index $index: $e');
            }
            return const SizedBox.shrink();
          }
        },
      );
    },
  );
}
