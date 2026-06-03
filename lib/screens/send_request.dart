import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/custom_widgets/custom_text_filed.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'cloud_firestore/cloud_firestore.dart';



class SendRequest extends StatelessWidget {
  const SendRequest({super.key});





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Column(
              children: [
                Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF4F3F7),
                  ),
                  child: Icon(
                    CupertinoIcons.search,
                    color: kSecoundColor,
                    size: 35.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Send Request',
                  style: TextStyle(fontSize: 35.sp, fontFamily: 'amara'),
                ),
                SizedBox(height: 20.h),
                CustomTextFiled(
                  hintText: 'Enter freind email',
                  onChanged: null,
                  obscureText: false,
                  validator: null,
                ),
                SizedBox(height: 20.h),
                CustomButton(text: 'Send'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
