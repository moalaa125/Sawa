import 'package:chat_app/constant.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/mo.JPG'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
