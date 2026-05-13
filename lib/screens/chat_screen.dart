import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/chatBubble.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chatScreen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ScrollController _controller = ScrollController();
  TextEditingController controller = TextEditingController();

  
  void sendMessage(String email, CollectionReference messagesRef) {
    if (controller.text.trim().isEmpty) {
      return;
    }

    messagesRef.add({
      kMessageField: controller.text,
      kCreatedAt: DateTime.now(),
      'id': email,
    });

    controller.clear();

    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String email = arguments['email'];
    String roomId = arguments['roomId'];
    String otherUserName = arguments['otherUserName'] ?? 'Chat';

    CollectionReference messages = firestore
        .collection('chats')
        .doc(roomId)
        .collection(kMessagesCollection);

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messageList = [];

          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.black,
              elevation: 1,
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              title: Hero(  
                tag: 'nameAnimation',
                child: Text(
                  otherUserName,   
                  style: TextStyle(
                    color: kSecoundColor,
                    fontSize: 22.sp,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: messageList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 60.sp,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No messages yet, say hello! 👋',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            return messageList[index].id == email
                                ? Chatbubble(
                                    txtColor: Colors.white,
                                    message: messageList[index],
                                    senderOrRecevier: Alignment.centerRight,
                                    paddingForBubble: EdgeInsets.only(
                                        left: 20, top: 16, bottom: 16, right: 20),
                                    bubbleColor: Color(0XFF06355C),
                                    borderRadiusGeometry: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  )
                                : Chatbubble(
                                    txtColor: Colors.black,
                                    paddingForBubble: EdgeInsets.only(
                                        left: 20, top: 16, bottom: 16, right: 20),
                                    bubbleColor: Color(0XFFF0F0F0),
                                    borderRadiusGeometry: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    senderOrRecevier: Alignment.centerLeft,
                                    message: messageList[index],
                                  );
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0XFFF0F0F0),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: TextField(
                            controller: controller,
                            onSubmitted: (_) {
                              sendMessage(email, messages); // باصينا الـ reference هنا
                            },
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 18.h,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () {
                          sendMessage(email, messages); // باصينا الـ reference هنا
                        },
                        child: Container(
                          height: 58.h,
                          width: 58.w,
                          decoration: BoxDecoration(
                            color: const Color(0XFF06355C),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: kPrimaryColor,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
            backgroundColor: kPrimaryColor,
            body: Center(
              child: SpinKitWave(color: kSecoundColor, size: 50.0),
            ),
          );
        }
      },
    );
  }
}