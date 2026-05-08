import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/custom_text_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import '../custom_widgets/show_snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  static String id = 'registerPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final user = FirebaseAuth.instance.currentUser;

  String? email;

  String? password;

  bool isLoading = false;

  void registration() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });

        await registeration();
        isLoading = true;

        Navigator.pushNamed(context, VerificationScreen.id);

        showSnackBar(context, 'check your mail check (spam)!');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackBar(context, 'weak password');
        } else if (e.code == 'email-already-in-use') {
          showSnackBar(context, 'email already exist!');
        }
      } catch (ex) {
        showSnackBar(context, 'error!');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registeration() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    await userCredential.user!.sendEmailVerification();
  }

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Form(
        key: formKey,
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
                    'Schoolar Chat',
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
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
                SizedBox(height: 20),
                CustomTextFiled(
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
                      : CustomButton(ontap: registration, text: 'Register'),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ?',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(width: 5),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
