import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_text_filed.dart';
import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});
  static String id = 'resetPassword';

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  String? code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextFiled(
            hintText: 'Enter you Email',
            onChanged: (value) async {
              code = value;
            },
            obscureText: false,
            validator: null,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'send',
              ontap: () async {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: '$code',
                );
                print('sent!');
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
