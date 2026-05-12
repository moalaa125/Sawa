import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/custom_text_button.dart';
import 'package:chat_app/custom_widgets/custom_text_filed.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/custom_widgets/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:email_validator/email_validator.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});
  static String id = 'resetPassword';

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  bool isLoading = false;
  String? code;

  GlobalKey<FormState> formkey = GlobalKey();

  sendLinkToResetPassword() async {
    if (!formkey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: code!);

      showSnackBar(context, 'The link was sent to you!');

      Navigator.pop(context);
      showSnackBar(context, 'cahnge your password and come to login again!');
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Hero(
          tag: 'nameAnimation',
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
      backgroundColor: kPrimaryColor,
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            SizedBox(height: 70.h),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF4F3F7),
                      ),
                      child: Icon(
                        CupertinoIcons.arrow_counterclockwise,
                        color: kSecoundColor,
                        size: 35.sp,
                      ),
                    ),
                    Text(
                      'Forget Password?',
                      style: TextStyle(fontSize: 35, fontFamily: 'amara'),
                    ),
                    Text(
                      'Enter your email to receive a\n password reset link',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    CustomTextFiled(
                      keyBoardType: TextInputType.emailAddress,
                      hintText: 'Enter you Email',
                      onChanged: (value) async {
                        code = value;
                      },
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email!';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Enter a valid mail !';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading
                          ? SpinKitDancingSquare(
                              color: Colors.white,
                              size: 50.0,
                            )
                          : CustomButton(
                              text: 'send',
                              ontap: () {
                                sendLinkToResetPassword();
                              },
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.arrow_left,
                          color: kSecoundColor,
                          size: 18.sp,
                        ),
                        SizedBox(width: 5),
                        CustomTextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'BACK TO LOGIN',
                          textStyle: TextStyle(color: Color(0xFF0D60A8)),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
