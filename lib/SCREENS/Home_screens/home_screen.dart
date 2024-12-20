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

Widget _buildFirebasePosts(PostProvider2 postProvider) {
  return StreamBuilder<List<DocumentSnapshot>>(
    stream: postProvider.getPosts(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No posts yet'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          var postData = snapshot.data![index].data() as Map<String, dynamic>;
          postData['postId'] = snapshot.data![index].id;

          return PostContainer2(
            key: ValueKey(postData['postId']),
            postData: {
              ...postData,
              'userName': postData['userName'] ?? 'Unknown User',
              'userProfilePic': postData['userProfilePic'] ?? '',
              'location': postData['location'] ?? 'Location not specified'
            },
          );
        },
      );
    },
  );
}
