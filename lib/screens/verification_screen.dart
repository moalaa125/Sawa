import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/custom_widgets/custom_text_button.dart';
import 'package:chat_app/custom_widgets/show_snack_bar.dart';
import 'package:chat_app/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  static String id = 'verificationPage';

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = false;

  Future<void> resendLink() async {
    try {
      setState(() {
        isLoading = true;
      });

      await user?.sendEmailVerification();

      showSnackBar(context, 'Verification link has been resent to your email');
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> isTheUserVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      showSnackBar(context, 'Email verified successfully!');

      Navigator.pushReplacementNamed(context, loginPage.id);
    } else {
      showSnackBar(context, 'Email not verified yet, please check your inbox');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        title: Hero(
          tag: 'nameAnimation',
          child: Material(
            color: Colors.transparent,
            child: Text(
              'SAWA Chat',
              style: TextStyle(
                color: kSecoundColor,
                fontSize: 25.sp,
                fontFamily: 'Pacifico',
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
            children: [
              Column(
                children: [
                  Container(
                    height: 110.h,
                    width: 110.w,
          
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF4F3F7),
                    ),
          
                    child: Icon(
                      CupertinoIcons.mail,
                      color: kSecoundColor,
                      size: 40.sp,
                    ),
                  ),
          
                  SizedBox(height: 35.h),
          
                  Text(
                    'Check your inbox\n',
                    textAlign: TextAlign.center,
          
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 34.sp,
                      fontFamily: 'amara',
                    ),
                  ),
          
                  Text(
                    'We sent a verification link to your email.\n Please click the link to confirm\n your account and continue\n to SAWA Chat.',
                    textAlign: TextAlign.center,
          
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
          
              Column(
                children: [
                  isLoading
                      ? SizedBox(
                          height: 56.h,
          
                          child: Center(
                            child: SpinKitDancingSquare(
                              color: Colors.black,
                              size: 50.0.sp,
                            ),
                          ),
                        )
                      : CustomButton(
                          ontap: () {
                            isTheUserVerified();
                          },
          
                          text: 'I,ve verified,continue',
                        ),
          
                  SizedBox(height: 5.h),
          
                  CustomTextButton(
                    onPressed: () {
                      resendLink();
                    },
          
                    text: 'RESEND LINK',
          
                    textStyle: TextStyle(color: kSecoundColor, fontSize: 16.sp),
                  ),
          
                  SizedBox(height: 30.h),
          
              
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
