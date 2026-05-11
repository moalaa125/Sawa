import 'package:chat_app/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.text, this.ontap});

  final String? text;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: kSecoundColor,
        ),
        width: 335.w,
        height: 50.h,
        child: Center(
          child: Text(
            '$text',
            style: TextStyle(
              fontSize: 20.sp, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}