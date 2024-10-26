import 'package:flutter/material.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 30),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('lib/images/kr5.png'),
          ),
          const SizedBox(width: 10),
          Text(
            'Hi, welcome back Fola',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
