import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/chatBubble.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ScrollController _controller = ScrollController();

  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  TextEditingController controller = TextEditingController();

  static String id = 'chatScreen';
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/scholar.png', scale: 2.5),
                  Text('chat', style: TextStyle(color: Colors.white)),
                ],
              ),
              backgroundColor: kPrimaryColor,
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
                              message: message[index],
                      
                              senderOrRecevier: Alignment.centerRight,
                              paddingForBubble: EdgeInsets.only(
                                left: 20,
                                top: 16,
                                bottom: 16,
                                right: 20,
                              ),
                              bubbleColor: kPrimaryColor,
                              borderRadiusGeometry: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            )
                          : Chatbubble(
                              paddingForBubble: EdgeInsets.only(
                                left: 20,
                                top: 16,
                                bottom: 16,
                                right: 20,
                              ),
                              bubbleColor: Colors.red,
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
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      messages.add({
                        'messages': data,

                        kCreatedAt: DateTime.now(),
                        'id': email,
                      });
                      controller.clear();
                      _controller.animateTo(
                        0,
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      hint: Text('Send Message .....'),
                      suffixIcon: Icon(Icons.send, color: kPrimaryColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text('Loading ....');
        }
      },
    );
  }
}
