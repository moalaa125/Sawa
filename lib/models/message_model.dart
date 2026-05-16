import 'package:chat_app/constant.dart';

class MessageModel {
  final String message;
  final String id;

  MessageModel(this.message, this.id);

factory MessageModel.fromJson(Map<String, dynamic> jsonData) {
    return MessageModel(jsonData[kMessageField], jsonData['id']); 
  }
}