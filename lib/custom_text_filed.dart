import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  CustomTextFiled({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.obscureText,
    required this.validator,
    this.keyBoardType,
  });
  final String hintText;
  final Function(String)? onChanged;
  final bool obscureText;
  final String? Function(String?)? validator;
  TextInputType? keyBoardType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
      child: TextFormField(
        keyboardType: keyBoardType,
        validator: validator,
        style: TextStyle(color: Colors.white, fontSize: 18),
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 138, 137, 136),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),

          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
