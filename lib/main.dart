import 'package:flutter/foundation.dart';
import 'package:socket_and_push/notification_helper.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel: IOWebSocketChannel.connect('ws://deb883b2.ngrok.io'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Notify notify = Notify.getInstance();
  TextEditingController _controller = TextEditingController();
  SocketIOManager manager = SocketIOManager();
  String text = '';
  SocketOptions options =
      SocketOptions('https://deb883b2.ngrok.io', nameSpace: '/admin',
          // enableLogging: true,
          transports: [Transports.WEB_SOCKET /*, Transports.POLLING*/]);
  SocketIO socket;
  @override
  void initState() {
    super.initState();
    start();

    // initSocket("buy");
  }

  start() async {
    socket = await manager.createInstance(options);

    socket.onConnect((data) {
      print("connected...");
      print(data);
      //socket.emit("message", ["Hello world!"]);
    });
    socket.on("admin", (data) async {
      print("admin");
      print(data);
      await notify.showNotification(
          title: data['message'],
          body:
              """A new  ${data['data']['type']} trade with  ${data['data']['name']}. Amount: N${data['data']['ammount']} """,
          id: 2);
      // setState(() {
      //   text = data.toString();
      // });
    });

    socket.connect();
    socket.onConnectError(handerr);
    socket.onError(handerr);
  }

  handerr(error) {
    // print(error.toString());
  }

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
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            ),
            Text(text.toString()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() async {
    print('object');
    // socket.on('buy', (data) {
    //   print(data);
    // });
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    manager.clearInstance(socket);
    super.dispose();
  }
}
