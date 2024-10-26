import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/shazam_buttton_provider.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/bottom_navigation.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/blur_screen.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/category_slider.dart';
import 'package:kakra/SCREENS/Home_screens/custom_appbar.dart';
import 'package:kakra/SCREENS/Home_screens/post_containers.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/shazam_likebutton.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/welcom_texts.dart';
import 'package:provider/provider.dart';
import 'package:kakra/providers/home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => FloatingButtonProvider()),
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
                                  return PostContainer(
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
