import 'package:flutter/material.dart';


const kPrimaryColor =  Colors.white ; 
const kSecoundColor =  Color(0xFF06355C) ; 
const kMessagesCollection = 'messages';
const kMessageField = 'messages';  
const kCreatedAt = 'createdAt';

String generateChatId(String email1, String email2) {
  List<String> emails = [email1, email2];
  emails.sort(); 
  return "${emails[0]}_${emails[1]}";
}
