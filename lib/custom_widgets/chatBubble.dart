import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
 const Chatbubble({
    super.key,
    required this.paddingForBubble,
    required this.bubbleColor,
    required this.borderRadiusGeometry,
    // required this.txt,
    required this.senderOrRecevier,
    required this.message,
    required this.txtColor,
  });

  final EdgeInsetsGeometry? paddingForBubble;
  final Color? bubbleColor;
  final BorderRadiusGeometry? borderRadiusGeometry;
  // final String? txt;
  final AlignmentGeometry senderOrRecevier;
  final MessageModel message ;
  final Color? txtColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: senderOrRecevier,
      child: Container(
        padding: paddingForBubble,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadiusGeometry,
        ),
        child: Text(
          message.message,
          style: TextStyle(color: txtColor, fontSize: 18),
        ),
      ),
    );
  }
}
