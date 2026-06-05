import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/custom_widgets/custom_text_filed.dart';
import 'package:chat_app/custom_widgets/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app/services/FriendRequestService.dart';

class SendRequest extends StatefulWidget {
  const SendRequest({super.key});

  @override
  State<SendRequest> createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSendRequest() async {
    final String targetEmail = _emailController.text.trim();

    if (targetEmail.isEmpty) {
      showSnackBar(context, 'please enter a valid email');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final String currentUserName =
          currentUserDoc.data()?['userName'] ?? 'Unknown';

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: targetEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        if (mounted) showSnackBar(context, 'this is not a user in the app !');
        setState(() => _isLoading = false);
        return;
      }

      if (querySnapshot.docs.length > 1) {
        if (mounted) showSnackBar(context, 'Database error: Multiple accounts found for this email!');
        setState(() => _isLoading = false);
        return;
      }

      final targetUserDoc = querySnapshot.docs.first;
      final String targetUserId = targetUserDoc.id;

      if (targetUserId == currentUser.uid) {
        if (mounted)
          showSnackBar(context, 'you cant send a friend request to yourself');
        setState(() => _isLoading = false);
        return;
      }

      final FriendRequestService requestService = FriendRequestService();
      await requestService.sendFriendRequest(
        currentUserId: currentUser.uid,
        currentUserName: currentUserName,
        targetUserId: targetUserId,
      );

      if (mounted) {
        showSnackBar(context, 'the request has been sent successfully');
        _emailController.clear();
      }
    } catch (e) {
      if (mounted) showSnackBar(context, ' $e  : Something went wrong');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Column(
              children: [
                Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF4F3F7),
                  ),
                  child: Icon(
                    CupertinoIcons.search,
                    color: kSecoundColor,
                    size: 35.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Send Request',
                  style: TextStyle(fontSize: 35.sp, fontFamily: 'amara'),
                ),
                SizedBox(height: 20.h),
                CustomTextFiled(
                  keyBoardType: TextInputType.emailAddress,
                  hintText: 'Enter freind email',
                  onChanged: null,
                  obscureText: false,
                  validator: null,
                  controller: _emailController,
                ),
                SizedBox(height: 20.h),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: 'Send', ontap: _handleSendRequest),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
