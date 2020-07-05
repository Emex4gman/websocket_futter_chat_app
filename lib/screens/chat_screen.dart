import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:websocket_futter_chat_app/model/chat_message.dart';
import 'package:websocket_futter_chat_app/my_stream.dart';
import 'package:websocket_futter_chat_app/service/socket_helper.dart';

enum ROOMS { COED, MALE, FEMALE, TRANS }
const String URI = "https://75549139934d.ngrok.io";

class ChatScreen extends StatefulWidget {
  final String title;

  ChatScreen({Key key, this.title = 'WebSocket Chat'}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatScreen> {
  MyStream _myStream = MyStream();
  final SocketHelper _socketHelper = SocketHelper();
  TextEditingController _controller = TextEditingController();
  SocketIOManager manager = SocketIOManager();
  SocketOptions options = SocketOptions(URI, query: {
    "auth": "--SOME AUTH STRING---",
    "token": "123",
    "info": "new connection from adhara-socketio",
    "timestamp": DateTime.now().toString()
  }, transports: [
    Transports.WEB_SOCKET,
    // Transports.POLLING
  ]);
  SocketIO homeSocket;

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    homeSocket = await manager.createInstance(options);
    homeSocket.onConnect((data) {});
    homeSocket.on("home", (data) async {});
    homeSocket.on("message", (data) async {
      _myStream.addChat(ChatMessage(message: data));
    });
    homeSocket.connect();
    homeSocket.onConnectError((e) => handerr(e, "onConnectError"));
    homeSocket.onError((e) => handerr(e, "onError"));
  }

  handerr(error, namespcae) {
    print('$namespcae: ${error.toString()}');
    manager.clearInstance(homeSocket);
  }

  @override
  Widget build(BuildContext context) {
    print(_socketHelper.sockets);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                        _socketHelper.sendMessageE('coed', _myStream);
                        // _myStream.addChat(ChatMessage(message: 'data'));
                      },
                      color: Colors.red,
                      child: Text('connetc to CoEd'))
                ],
              ),
            ),
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: _myStream.chatStream,
              builder: (context, AsyncSnapshot<List<ChatMessage>> snapshot) {
                return snapshot.hasData
                    ? Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Text(
                                '${snapshot.data[index].message} - ${snapshot.data[index].time}');
                          },
                        ),
                      )
                    : Expanded(child: Container());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      homeSocket.emit('message', [_controller.text]);
      _controller.text = "";
    }
  }

  @override
  void dispose() {
    _myStream.dispoas();
    _socketHelper.dispose();
    manager.clearInstance(homeSocket);
    super.dispose();
  }
}
