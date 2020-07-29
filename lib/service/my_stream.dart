import 'dart:async';

import 'package:websocket_futter_chat_app/model/chat_message.dart';

class MyStream {
  static MyStream _myStream;
  MyStream.createInstance();
  //singlton Mystream class
  factory MyStream() {
    if (_myStream == null) {
      _myStream = MyStream.createInstance();
    }
    return _myStream;
  }
  List<ChatMessage> chatList = [];
  Map<String, List<ChatMessage>> chatRooms = {};
  Map<String, StreamController<List<ChatMessage>>> streamContollers = {};
  Map<String, bool> _isProbablyActive = {};
  bool isProbablyConnected(String identifier) {
    return _isProbablyActive[identifier] ?? false;
  }

//creating different strems for different room
  createStream(String identifier) {
    if (isProbablyConnected(identifier)) {
      print('Stream is already active');
      return;
    }
    _isProbablyActive[identifier] = true;
    StreamController<List<ChatMessage>> controller =
        new StreamController<List<ChatMessage>>.broadcast();
    streamContollers[identifier] = controller;
    chatRooms[identifier] = [];
  }

//load chat different chats based on the identifier
  loadChatsWithIdentifyer(String identifier) {
    streamContollers[identifier].sink.add(chatRooms[identifier]);
  }

  addChatWithIdentifyer({String identifier, ChatMessage value}) {
    chatRooms[identifier].add(value);
    loadChatsWithIdentifyer(identifier);
  }

  dispose() {
    streamContollers.forEach((key, value) {
      value.close();
    });
  }
}
