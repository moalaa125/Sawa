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

  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  void sendMessage(String email) {
    if (controller.text.trim().isEmpty) {
      return;
    }

    messages.add({
      'messages': controller.text,
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

  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> message = [];

          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            message.add(MessageModel.fromJson(snapshot.data!.docs[i]));
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
                  'SAWA Chat',
                  style: TextStyle(
                    color: kSecoundColor,
                    fontSize: 25.sp,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,

                    itemCount: message.length,
                    itemBuilder: (context, index) {
                      return message[index].id == email
                          ? Chatbubble(
                              txtColor: Colors.white,
                              message: message[index],

                              senderOrRecevier: Alignment.centerRight,
                              paddingForBubble: EdgeInsets.only(
                                left: 20,
                                top: 16,
                                bottom: 16,
                                right: 20,
                              ),
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
                                left: 20,
                                top: 16,
                                bottom: 16,
                                right: 20,
                              ),
                              bubbleColor: Color(0XFFF0F0F0),
                              borderRadiusGeometry: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              senderOrRecevier: Alignment.centerLeft,
                              message: message[index],
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
              sendMessage(email);
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
          sendMessage(email);
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
)
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: kPrimaryColor,
            body: Center(
              child: Text(
                'There is an error try again later !',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: kPrimaryColor,
            body: Center(child: SpinKitWave(color: Colors.white, size: 50.0)),
          );
        }
      },
    );
  }
}
