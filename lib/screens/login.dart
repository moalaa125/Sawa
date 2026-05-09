import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_text_filed.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/custom_widgets/custom_text_button.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/custom_widgets/show_snack_bar.dart';
import 'package:chat_app/screens/register.dart';
import 'package:chat_app/screens/resetPassword.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();

  static String id = 'loginPage';
}

class _loginPageState extends State<loginPage> {
  bool isLoading = false;
  void signIn() async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await logIn();
        if (userCredential.user!.emailVerified) {
          Navigator.pushNamed(context, ChatScreen.id);
          showSnackBar(context, 'you loggied in sucssfully !');
        } else {
          await FirebaseAuth.instance.signOut();
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
                  SizedBox(height: 70),
                  Hero(
                    tag: 'logo',
                    child: Image.asset('assets/images/scholar.png'),
                  ),
                  Text(
                    'SAWA Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
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
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                  obscureText: false,
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? const SpinKitDancingSquare(
                          color: Colors.white,
                          size: 50.0,
                        )
                      : CustomButton(
                          ontap: () {
                            signIn();
                          },
                          text: 'Login  ',
                        ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dont have an account?',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(width: 5),
                    CustomTextButton(
                      text: 'Sign Up',
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                    ),
                  ],
                ),
                Center(
                  child: CustomTextButton(
                    text: 'Reset Password',
                    onPressed: () {
                      Navigator.pushNamed(context, Resetpassword.id);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
