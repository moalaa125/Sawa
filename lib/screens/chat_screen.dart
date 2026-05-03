import 'package:chat_app/constant.dart';
import 'package:chat_app/custom_widgets/chatBubble.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static String id = 'chatScreen';
  @override
  Widget build(BuildContext context) {
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
              itemBuilder: (context, index) {
                return Chatbubble(
                  senderOrRecevier: Alignment.centerLeft,
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
                    bottomRight: Radius.circular(20),
                  ),

                  txt: 'hello',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 18),
              decoration: InputDecoration(
                hint: Text('Send Message .....'),
                suffixIcon: Icon(Icons.send , color: kPrimaryColor,),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide( color: Colors.black),
                ),
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}
