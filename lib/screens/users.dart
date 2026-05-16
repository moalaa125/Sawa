import 'package:chat_app/constant.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UsersScreen extends StatelessWidget {
  static String id = 'usersScreen';

  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? myEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: StreamBuilder<QuerySnapshot>(
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
                  child: Card(
                    elevation: 0,
                    color: const Color(0xFFF0F0F0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: kSecoundColor,
                        child: Text(
                          displayName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        displayName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: kSecoundColor),
                      ),
                      subtitle: Text(otherUserEmail),
                      trailing: Icon(Icons.send_rounded, color: kSecoundColor, size: 20.sp),
                      onTap: () {
                        String roomId = generateChatId(myEmail!, otherUserEmail);

                        Navigator.pushNamed(
                          context,
                          ChatScreen.id,
                          arguments: {
                            'email': myEmail,
                            'roomId': roomId,
                            'otherUserName': displayName,
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else {
            return Center(
              child: SpinKitWave(color: kSecoundColor, size: 50.0),
            );
          }
        },
      ),
    );
  }
}