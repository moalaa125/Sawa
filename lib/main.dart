import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/register.dart';
import 'package:chat_app/screens/resetPassword.dart';
import 'package:chat_app/screens/users.dart';
import 'package:chat_app/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoggedIn = user != null && user.emailVerified;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: fals          routes: {
            'loginPage': (context) => LoginPage(),
            'registerPage': (context) => RegisterPage(),
            'verificationPage': (context) => VerificationScreen(),
            'chatScreen': (context) => ChatScreen(),
            'resetPassword': (context) => Resetpassword(),
            'usersScreen': (context) => UsersScreen(),
          },
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: kSecoundColor),
          ),
          initialRoute: isLoggedIn ? 'usersScreen' : 'loginPage',
        );
      },
    );
  }
}
