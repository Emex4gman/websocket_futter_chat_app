import 'package:flutter/material.dart';
import 'package:websocket_futter_chat_app/screens/chat_screen.dart';
import 'package:websocket_futter_chat_app/screens/create_account.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = '';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: //Example(),
          CreateAccount(),
    );
  }
}
