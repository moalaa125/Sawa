import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/app_router.dart';
import 'package:chat_app/custom_widgets/custom_text_filed.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/custom_widgets/custom_text_button.dart';
import 'package:chat_app/custom_widgets/show_snack_bar.dart';
import 'package:chat_app/screens/register.dart';
import 'package:chat_app/screens/resetPassword.dart';
import 'package:chat_app/screens/users.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

  static String id = 'loginPage';
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  void signIn() async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await logIn();
        if (!mounted) return;
        if (userCredential.user!.emailVerified) {
          Navigator.of(context).push(sharedAxisRoute(UsersScreen()));
        } else {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          showSnackBar(context, 'the account does not verified!');
        }
      } on FirebaseAuthException catch (e) {
        showSnackBar(
          context,
          e.message ?? 'there is an error please try again later!',
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<UserCredential> logIn() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);

    return userCredential;
  }

  String? email;
  String? password;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Container(
                    height: 65.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: kSecoundColor,
                    ),
                    child: Icon(
                      CupertinoIcons.chat_bubble,
                      color: Colors.white,
                      size: 35.sp,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    'SAWA Chat',
                    style: TextStyle(
                      color: kSecoundColor,
                      fontSize: 30.sp,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 70.h),
                ],
              ),
            ),

            Column(
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                ),
                SizedBox(height: 30.h),
                CustomTextFiled(
                  keyBoardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'wanted section';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Enter a valid mail !';
                    }
                    return null;
                  },
                  hintText: 'Email address',
                  onChanged: (data) {
                    email = data;
                  },
                  obscureText: false,
                ),
                SizedBox(height: 2.h),
                CustomTextFiled(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'wanted section';
                    }
                    return null;
                  },
                  hintText: 'Password',
                  onChanged: (data) {
                    password = data;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: isLoading
                      ? SpinKitDancingSquare(color: Colors.black, size: 50.0.sp)
                      : CustomButton(
                          ontap: () {
                            signIn();
                          },
                          text: 'LOGIN',
                        ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: CustomTextButton(
                    textStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
                    fontWeight: FontWeight.normal,
                    text: 'Forget Password',
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(sharedAxisRoute(Resetpassword()));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dont have an account?',
                      style: TextStyle(color: Colors.black, fontSize: 18.sp),
                    ),
                    SizedBox(width: 5.w),
                    CustomTextButton(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                      ),
                      fontWeight: FontWeight.w500,
                      text: 'Sign Up',
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).push(sharedAxisRoute(RegisterPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
