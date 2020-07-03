import 'package:flutter/material.dart';
import 'package:socket_and_push/screens/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Chat';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: ChatScreen(
        title: title,
      ),
    );
  }
}
