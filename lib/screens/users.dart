import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/app_router.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/screens/requests.dart';
import 'package:chat_app/screens/send_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chat_app/screens/login.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class UsersScreen extends StatefulWidget {
  static String id = 'usersScreen';

  UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final String? myEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 0.2.w),
          ),
        ),
        child: GNav(
          padding: EdgeInsets.only(
            bottom: 22.h,
            left: 25.w,
            right: 20.w,
            top: 20.h,
          ),
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 4.w,
          activeColor: kSecoundColor,
          iconSize: 24.sp,
          duration: Duration(milliseconds: 400),
          color: Colors.grey[600],
          tabBackgroundColor: Colors.grey[200]!,
          backgroundColor: Colors.white,
          tabs: [
            GButton(icon: Icons.home, text: 'Home',),
            GButton(icon: Icons.search, text: 'Search', ),
            GButton(icon: Icons.help, text: 'Requests'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: kSecoundColor, size: 24.sp),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(
                context,
              ).pushReplacement(sharedAxisRoute(LoginPage()));
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'SAWA Users',
          style: TextStyle(
            color: kSecoundColor,
            fontFamily: 'Pacifico',
            fontSize: 25.sp,
          ),
        ),
      ),
      body: _getSelectedPage(myEmail),
    );
  }

  Widget _getSelectedPage(String? myEmail) {
    if (_currentIndex == 1) {
      return SendRequest();
    } else if (_currentIndex == 2) {
      return Requests();
    } else if (_currentIndex == 3) {
      return Profile();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var users = snapshot.data!.docs.where((doc) {
            return doc['email'] != myEmail;
          }).toList();

          if (users.isEmpty) {
            return Center(child: Text("No other users found."));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;

              String otherUserEmail = userData['email'] ?? "No Email";

              String displayName = userData.containsKey('userName')
                  ? userData['userName']
                  : otherUserEmail.split('@')[0];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      color: const Color(0xFFF0F0F0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: kSecoundColor,
                          child: Text(
                            displayName[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                        title: Text(
                          displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kSecoundColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        subtitle: Text(
                          otherUserEmail,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: Icon(
                          Icons.send_rounded,
                          color: kSecoundColor,
                          size: 20.sp,
                        ),
                        onTap: () {
                          String roomId = generateChatId(myEmail!, otherUserEmail);
                    
                          Navigator.of(context).push(
                            sharedAxisRoute(
                              ChatScreen(),
                              arguments: {
                                'email': myEmail,
                                'roomId': roomId,
                                'otherUserName': displayName,
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        } else {
          return Center(
            child: SpinKitWave(color: kSecoundColor, size: 50.w),
          );
        }
      },
    );
  }
}
