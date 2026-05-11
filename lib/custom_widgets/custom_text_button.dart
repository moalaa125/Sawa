import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.fontWeight,
  });

  final String? text;
  final void Function()? onPressed;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Text(
        '$text',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}