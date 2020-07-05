import 'dart:async';

import 'package:websocket_futter_chat_app/model/chat_message.dart';

class MyStream {
  static StreamController<String> controller =
      StreamController<String>.broadcast();

  List<ChatMessage> chatList = [];
  static StreamController<List<ChatMessage>> chatController =
      StreamController<List<ChatMessage>>.broadcast();
  Stream mysStream = controller.stream;
  Stream<List<ChatMessage>> chatStream = chatController.stream;
  // StreamSubscription<double> streamSubscription = mysStream.listen((value) {
  //   print('Value from controller: $value');
  // });
  addChat(ChatMessage value) {
    chatList.add(value);
    chatController.add(chatList);
  }

  add(value) {
    controller.add(value);
  }

  dispoas() {
    chatController.close();
    controller.close();
  }
}
