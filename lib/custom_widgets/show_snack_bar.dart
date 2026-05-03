import 'package:flutter/material.dart';
 
 void showSnackBar(BuildContext context , String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 91, 144, 187),
        content: Text(message),
      ),
    );
  }