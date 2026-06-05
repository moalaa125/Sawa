import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFiled extends StatelessWidget {
  CustomTextFiled({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.obscureText,
    required this.validator,
    this.keyBoardType,
    this.controller,
    // this.textAboveField,
  });

  final String hintText;
  final Function(String)? onChanged;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  // final String? textAboveField;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16.r);
    final borderSide = BorderSide.none;

    return Padding(
      padding: EdgeInsets.only(left: 15.w, top: 10.h, right: 15.w, bottom: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
     
          TextFormField(
            keyboardAppearance: Brightness.light,
            controller: controller,
            keyboardType: keyBoardType,
            validator: validator,
            style: TextStyle(color: Colors.black, fontSize: 15.sp),
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              contentPadding: EdgeInsets.symmetric(
                vertical: 13.h,
                horizontal: 20.w,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: borderSide,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: borderSide,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
