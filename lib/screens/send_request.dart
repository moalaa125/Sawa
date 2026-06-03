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
      showSnackBar(context, 'الرجاء إدخال البريد الإلكتروني أولاً');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. جلب بيانات المستخدم الحالي (الراسل) من الـ Firebase Auth والـ Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // جلب اسم المستخدم الحالي من مستنده في Firestore (تأكد أن حقل الاسم اسمه 'name' أو 'username' لديك)
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final String currentUserName =
          currentUserDoc.data()?['name'] ?? 'Unknown';

      // 2. البحث عن الصديق (المستقبل) في Firestore باستخدام الإيميل المكتوب
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: targetEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        if (mounted)
          showSnackBar(context, 'هذا البريد الإلكتروني غير مسجل بالتطبيق');
        setState(() => _isLoading = false);
        return;
      }

      // الحصول على مستند الصديق
      final targetUserDoc = querySnapshot.docs.first;
      final String targetUserId = targetUserDoc.id;

      // منع المستخدم من إرسال طلب صداقة لنفسه
      if (targetUserId == currentUser.uid) {
        if (mounted) showSnackBar(context, 'لا يمكنك إرسال طلب صداقة لنفسك!');
        setState(() => _isLoading = false);
        return;
      }

      // 3. استدعاء الدالة الخاصة بك لإرسال الطلب عبر الـ Service
      final FriendRequestService requestService = FriendRequestService();
      await requestService.sendFriendRequest(
        currentUserId: currentUser.uid,
        currentUserName: currentUserName,
        targetUserId: targetUserId,
      );

      if (mounted) {
        showSnackBar(context, 'تم إرسال طلب الصداقة بنجاح!');
        _emailController.clear(); // مسح الخانة بعد النجاح
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'حدث خطأ ما: $e');
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
      backgroundColor: kPrimaryColor,
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
                  hintText: 'Enter freind email',
                  onChanged: null,
                  obscureText: false,
                  validator: null,
                  controller: _emailController,
                ),
                SizedBox(height: 20.h),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: 'Send' , ontap: _handleSendRequest),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
