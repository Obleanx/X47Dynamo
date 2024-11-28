import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:kakra/SCREENS/Displaying_POsts/post+provider2.dart';
import 'package:kakra/SCREENS/Displaying_POsts/post_container2.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/bottom_navigation.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/blur_screen.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/category_slider.dart';
import 'package:kakra/SCREENS/Home_screens/appbar.dart';
import 'package:kakra/SCREENS/Home_screens/post_containers.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/shazam_likebutton.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/welcom_texts.dart';
import 'package:provider/provider.dart';
import 'package:kakra/providers/home_provider.dart';
import 'Town square/town_square_post_container.dart';

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
                          // Firebase Posts
                          Consumer<PostProvider2>(
                            builder: (context, postProvider, child) {
                              return _buildFirebasePosts(postProvider);
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
  return StreamBuilder<QuerySnapshot>(
    stream: postProvider.getPosts(),
    builder: (context, snapshot) {
      // Loading State
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Error State
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }

      // No Posts State
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text('No posts yet'),
        );
      }

      // Posts List
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var postData =
              snapshot.data!.docs[index].data() as Map<String, dynamic>;
          postData['postId'] = snapshot.data!.docs[index].id;

          return PostContainer2(
            key: ValueKey(postData['postId']),
            postData: postData,
          );
        },
      );
    },
  );
}
