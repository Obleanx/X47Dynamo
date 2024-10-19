import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Terms of Service',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
        SizedBox(
          width: 110,
          child: Divider(height: 5),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            'By signing in or create an account you have agreed to Kakra\'s terms and services',
            style: TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
