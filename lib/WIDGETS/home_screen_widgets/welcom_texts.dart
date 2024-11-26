import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = FirebaseAuth.instance.currentUser;
        final profileImageUrl = profileProvider.profileImageUrl;
        final firstName = profileProvider.firstName ?? '';
        final lastName = profileProvider.lastName ?? '';

        if (profileProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 30),
          child: Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    profileImageUrl != null && profileImageUrl.isNotEmpty
                        ? CachedNetworkImageProvider(profileImageUrl)
                            as ImageProvider
                        : const AssetImage('lib/images/kr5.png'),
                child: profileImageUrl == null || profileImageUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.grey[400])
                    : null,
              ),
              const SizedBox(width: 10),
              // User Name and Greeting
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${firstName.isNotEmpty ? firstName : "User"}${lastName.isNotEmpty ? " $lastName" : ""}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
