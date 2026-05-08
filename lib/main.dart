import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/register.dart';
import 'package:chat_app/screens/resetPassword.dart';
import 'package:chat_app/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'loginPage': (context) => loginPage(),
        'registerPage': (context) => RegisterPage(),
        'verificationPage': (context) => VerificationScreen(),
        'chatScreen': (context) => ChatScreen(),
        'resetPassword': (context) => Resetpassword(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: 'loginPage',
    );
  }
}
