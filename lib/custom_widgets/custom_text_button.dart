import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({super.key, required this.onPressed, required this.text});

  final String? text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Text('$text', style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}
