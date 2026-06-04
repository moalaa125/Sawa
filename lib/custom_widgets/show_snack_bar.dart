import 'package:chat_app/constant.dart';
import 'package:flutter/material.dart';
 
 void showSnackBar(BuildContext context , String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kSecoundColor.withValues(alpha: .9),
        content: Text(message),
      ),
    );
  }