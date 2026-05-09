import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_text_filed.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/custom_widgets/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: kPrimaryColor,
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.35),
            Center(
              child: Column(
                children: [
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
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? SpinKitDancingSquare(color: Colors.white, size: 50.0)
                        : CustomButton(
                            text: 'send',
                            ontap: () {
                              sendLinkToResetPassword();
                            },
                          ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
