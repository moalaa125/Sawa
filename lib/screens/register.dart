import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/app_router.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/screens/verification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/custom_widgets/custom_text_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import '../custom_widgets/show_snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
   const RegisterPage({super.key});

  static String id = 'registerPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final user = FirebaseAuth.instance.currentUser;

  String? email;
  String? password;
  bool isLoading = false;
  String? userName;

  void registration() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });

        await registerationLogic();
         if (!mounted) return;

        Navigator.of(context).push(sharedAxisRoute(VerificationScreen()));

        showSnackBar(context, 'check your mail check (spam)!');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackBar(context, 'weak password');
        } else if (e.code == 'email-already-in-use') {
          showSnackBar(context, 'email already exist!');
        }
      } catch (ex) {
        showSnackBar(context, ex.toString().replaceAll('Exception: ', ''));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registerationLogic() async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get();
         if (!mounted) return;

    if (result.docs.isNotEmpty) {
      throw Exception('Username already taken!');
    }

    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'email': email,
          'userName': userName!,
          'uid': userCredential.user!.uid,
          'createdAt': DateTime.now(),
        });

    await userCredential.user!.sendEmailVerification();
  }

  GlobalKey<FormState> formKey = GlobalKey();
  String? confirmPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'SAWA Chat',
          style: TextStyle(
            color: kSecoundColor,
            fontSize: 25.sp,
            fontFamily: 'Pacifico',
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create account',
                            style: TextStyle(
                              color: kSecoundColor,
                              fontSize: 35.sp,
                              fontFamily: 'amara',
                            ),
                          ),
                          Text(
                            'Enter your details to start your journy with us.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'User name ',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                CustomTextFiled(
                  keyBoardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'wanted section';
                    } else if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                  hintText: 'User name',
                  onChanged: (data) {
                    userName = data;
                  },
                  obscureText: false,
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Email',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),

                CustomTextFiled(
                  keyBoardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'wanted section';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Enter a valid mail';
                    }
                    return null;
                  },
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                  obscureText: false,
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'password',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                CustomTextFiled(
                  onChanged: (data) {
                    password = data;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wanted section';
                    } else if (value.length < 8) {
                      return 'the password should bigger that 8 char';
                    } else if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'should contain at least number';
                    }
                    return null;
                  },
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                SizedBox(height: 3.h),
                CustomTextFiled(
                  validator: (value) {
                    confirmPass = value;
                    if (value == null || value.isEmpty) {
                      return 'Wanted section';
                    } else if (value.length < 8) {
                      return 'the password should bigger that 8 char';
                    } else if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'should contain at least number';
                    } else if (value != password) {
                      return 'Password must be same as above';
                    }
                    return null;
                  },
                  hintText: 'Re-Enter The Password',
                  onChanged: null,
                  obscureText: true,
                ),
                SizedBox(height: 30),
                Center(
                  child: isLoading
                      ? const SpinKitDancingSquare(
                          color: Colors.black,
                          size: 50.0,
                        )
                      : CustomButton(ontap: registration, text: 'Register'),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ?',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
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
