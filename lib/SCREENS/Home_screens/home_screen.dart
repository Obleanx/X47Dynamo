import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navigation.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/category_slider.dart';
import 'package:kakra/SCREENS/Home_screens/custom_appbar.dart';
import 'package:kakra/SCREENS/Home_screens/post_containers.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/shazam_likebutton.dart';
import 'package:kakra/WIDGETS/home_screen_widgets/welcom_texts.dart';
import 'package:provider/provider.dart';
import 'package:kakra/providers/home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserGreeting(),
              const CategorySlider(),
              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.posts.length,
                    itemBuilder: (context, index) {
                      return PostContainer(post: provider.posts[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
        floatingActionButton: const CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
