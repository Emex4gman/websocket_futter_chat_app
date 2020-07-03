import 'package:intl/intl.dart';

class ChatMessage {
  String message;
  String messageId;
  String time = DateTime.now().toIso8601String();
  String senderId;

  ChatMessage({this.message, this.messageId = '1', this.senderId = 'emeka'});
}

class ChatRoom {
  String chatRoomName;
  String chatRoomId;
  List<ChatMessage> chatMassages;
  ChatRoom({this.chatRoomName, this.chatRoomId = '1', this.chatMassages});
}
