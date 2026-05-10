import 'package:chat_app/constant.dart';

class MessageModel {
  final String message;
  final String id;

  MessageModel(this.message, this.id);

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(jsonData[kMessagesCollection], jsonData['id']);
  }
}
