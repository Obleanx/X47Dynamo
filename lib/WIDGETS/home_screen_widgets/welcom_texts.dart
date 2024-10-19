import 'package:flutter/material.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/user_avatar.png'),
          ),
          const SizedBox(width: 10),
          Text(
            'Hi, welcome back Fola',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
