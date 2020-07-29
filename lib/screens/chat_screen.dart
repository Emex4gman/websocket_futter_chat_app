import 'package:flutter/material.dart';
import 'package:websocket_futter_chat_app/model/chat_message.dart';
import 'package:websocket_futter_chat_app/service/my_stream.dart';
import 'package:websocket_futter_chat_app/service/database_helper.dart';
import 'package:websocket_futter_chat_app/service/socket_helper.dart';

enum ROOMS { COED, MALE, FEMALE, TRANS }
const String URI = "http://localhost:2000";

class ChatScreen extends StatefulWidget {
  final String title;
  ChatScreen({Key key, this.title = 'WebSocket Chat'}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatScreen> {
  MyStream _myStream = MyStream();
  DataBaseHelper _dataBaseHelper = DataBaseHelper();
  final SocketHelper _socketHelper = SocketHelper();
  TextEditingController _controller = TextEditingController();
  String identifier = ""; //socket room identifier
  String identifier2 = ""; //socket room identifier
  @override
  void initState() {
    super.initState();
    joinChatRoom(_dataBaseHelper.user.gender.toLowerCase());
  }

  joinChatRoom(String room) async {
    _myStream.createStream(room);
    _myStream.createStream('coed');
    setState(() {
      identifier = _dataBaseHelper.user.gender.toLowerCase();
      identifier2 = "coed";
    });
    await _socketHelper.initSocket(
        identifier: room, streamContoller: _myStream);
    await _socketHelper.initSocket(
        identifier: 'coed', streamContoller: _myStream);
    _myStream.loadChatsWithIdentifyer(room);
    _myStream.loadChatsWithIdentifyer('coed');
  }

  @override
  Widget build(BuildContext context) {
    print(_socketHelper.sockets);
    print(_myStream.chatList);
    print(_myStream.chatRooms);
    // print();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () async {
                                // await _socketHelper.initSocket('coed');
                                if (_controller.text.isNotEmpty) {
                                  _socketHelper.sendMessageE(
                                      identifier: identifier,
                                      stream: _myStream,
                                      message: _controller.text);
                                  _controller.text = "";
                                }
                                // _myStream.addChat(ChatMessage(message: 'data'));
                              },
                              color: Colors.red,
                              child: Text('Message Admin Group'))
                        ],
                      ),
                    ),
                    Form(
                      child: TextFormField(
                        controller: _controller,
                        decoration:
                            InputDecoration(labelText: 'Send a message'),
                      ),
                    ),
                    StreamBuilder(
                      stream: _myStream.streamContollers[identifier].stream,
                      builder:
                          (context, AsyncSnapshot<List<ChatMessage>> snapshot) {
                        return snapshot.hasData
                            ? Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                        '${snapshot.data[index].message}');
                                  },
                                ),
                              )
                            : Expanded(child: Container());
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () async {
                                // await _socketHelper.initSocket('coed');
                                if (_controller.text.isNotEmpty) {
                                  _socketHelper.sendMessageE(
                                      identifier: identifier2,
                                      stream: _myStream,
                                      message: _controller.text);
                                  _controller.text = "";
                                }
                                // _myStream.addChat(ChatMessage(message: 'data'));
                              },
                              color: Colors.red,
                              child: Text('Message Code Group'))
                        ],
                      ),
                    ),
                    Form(
                      child: TextFormField(
                        controller: _controller,
                        decoration:
                            InputDecoration(labelText: 'Send a message'),
                      ),
                    ),
                    StreamBuilder(
                      stream: _myStream.streamContollers[identifier2].stream,
                      builder:
                          (context, AsyncSnapshot<List<ChatMessage>> snapshot) {
                        return snapshot.hasData
                            ? Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                        '${snapshot.data[index].message} -');
                                  },
                                ),
                              )
                            : Expanded(child: Container());
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      _socketHelper.sendMessageE(
          identifier: _dataBaseHelper.user.gender.toLowerCase(),
          stream: _myStream,
          message: _controller.text);
      _controller.text = "";
    }
  }

  @override
  void dispose() {
    // _myStream.dispoas();
    // _socketHelper.dispose();
    super.dispose();
  }
}
