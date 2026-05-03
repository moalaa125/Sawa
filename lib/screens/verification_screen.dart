import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/show_snack_bar.dart';
import 'package:chat_app/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();

  static String id = 'verificationPage';
}

class _VerificationScreenState extends State<VerificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  resendlink() async {
    try {
      await user?.sendEmailVerification();
      showSnackBar(context, 'Verification link has been resent to your email');
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  istheuserVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      showSnackBar(context, 'Done!');
      Navigator.pushReplacementNamed(context, loginPage.id);
    } else {
      showSnackBar(context, 'Email not verified yet, please check your email and click the link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'verificaton page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: resendlink,
              child: Container(
                color: Colors.red,
                height: 30,
                width: 200,
                child: Center(child: Text('resend')),
              ),
            ),
            GestureDetector(
              onTap: () {
                istheuserVerified();
              },
              child: Container(
                color: Colors.red,
                height: 30,
                width: 200,
                child: Center(child: Text('i have been verified')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
