import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:socket_and_push/model/chat_message.dart';
import 'package:socket_and_push/my_stream.dart';

class ChatScreen extends StatefulWidget {
  final String title;

  ChatScreen({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatScreen> {
  MyStream _myStream = MyStream();
  TextEditingController _controller = TextEditingController();
  SocketIOManager manager = SocketIOManager();
  SocketOptions options = SocketOptions('https://ba56a839d68c.ngrok.io',
      transports: [Transports.WEB_SOCKET]);
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
    homeSocket.onConnectError(handerr);
    homeSocket.onError(handerr);
  }

  handerr(error) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
    manager.clearInstance(homeSocket);
    super.dispose();
  }
}
