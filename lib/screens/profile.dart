import 'dart:io';
import 'package:chat_app/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      File imageFile = File(pickedFile.path);

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles')
          .child('${user.uid}.jpg');

      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore user document
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'profileImage': downloadUrl},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          String userName = "Loading...";
          String? profileImageUrl;

          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            userName = data['userName'] ?? 'No Name';
            profileImageUrl = data.containsKey('profileImage')
                ? data['profileImage']
                : null;
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 60.r,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage('assets/images/mo.JPG')
                                as ImageProvider,
                    ),
                    CircleAvatar(
                      backgroundColor: kSecoundColor,
                      radius: 20.r,
                      child: IconButton(
                        icon: _isUploading
                            ? SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                        onPressed: _isUploading ? null : _pickAndUploadImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Center(
                child: Text(
                  user?.email ?? "No Email",
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
              ),
              SizedBox(height: 40.h),
              _buildProfileOption(Icons.person, 'Edit Profile', () {}),
              _buildProfileOption(Icons.lock, 'Change Password', () {}),
              _buildProfileOption(Icons.settings, 'App Settings', () {}),
              _buildProfileOption(Icons.logout, 'Logout', () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('loginPage');
              }, isDestructive: true),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      color: const Color(0xFFF0F0F0),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : kSecoundColor,
          size: 24.sp,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
