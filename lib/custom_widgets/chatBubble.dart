import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
 const Chatbubble({
    super.key,
    required this.paddingForBubble,
    required this.bubbleColor,
    required this.borderRadiusGeometry,
    required this.txt,
    required this.senderOrRecevier,
  });

  final EdgeInsetsGeometry? paddingForBubble;
  final Color? bubbleColor;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final String? txt;
  final AlignmentGeometry senderOrRecevier;

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
          '$txt',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
