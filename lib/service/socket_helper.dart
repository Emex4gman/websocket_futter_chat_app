import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:websocket_futter_chat_app/model/chat_message.dart';
import 'package:websocket_futter_chat_app/my_stream.dart';

enum ROOMS { COED, MALE, FEMALE, TRANS }

class SocketHelper {
  String uri = "https://75549139934d.ngrok.io";
  static SocketHelper _socketHelper;
  SocketHelper.createSocketHelperInstance();
  List<String> toPrint = ["trying to connect"];
  SocketIOManager _sockectManager;
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};
// MyStream
  get sockectManager {
    if (_sockectManager == null) {
      _sockectManager = SocketIOManager();
    }
    return _sockectManager;
  }

  //crateing a singlton sockethelper
  factory SocketHelper() {
    if (_socketHelper == null) {
      _socketHelper = SocketHelper.createSocketHelperInstance();
    }
    return _socketHelper;
  }
  Future<void> initSocket(String identifier) async {
    if (isProbablyConnected(identifier)) {
      print('alredy connectd');
      return;
    }
    _isProbablyConnected[identifier] = true;

    SocketIO socket = await sockectManager.createInstance(SocketOptions(
        //Socket IO server URI
        uri,
        nameSpace: (identifier == "default") ? "/" : "/$identifier",
        query: {
          "auth": "--SOME AUTH STRING---",
          "token": "123",
          "path": "$identifier",
          "info": "new connection from adhara-socketio",
          "timestamp": DateTime.now().toString()
        },
        // enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
        ] //Enable required transport
        ));

    socket.onConnect((data) {
      pprint("connected...");
      pprint(data);
      // sendMessage(identifier);
    });
    socket.on("message", (data) => pprint(data));
    socket.on("$identifier", (data) => pprint(data));
    socket.connect();
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    sockets[identifier] = socket;
  }

  sendMessage(identifier) {
    if (sockets[identifier] != null) {
      pprint("sending message from '$identifier'...");
      sockets[identifier].emit("$identifier", ["mole app"]);

      pprint("Message emitted from '$identifier'...");
    }
  }

  sendMessageE(identifier, MyStream stream) {
    if (sockets[identifier] != null) {
      stream.addChat(ChatMessage(message: 'mole app'));
      pprint("sending message from '$identifier'...");
      sockets[identifier].emit("$identifier", ["mole app"]);

      pprint("Message emitted from '$identifier'...");
    }
  }

  bool isProbablyConnected(String identifier) {
    return _isProbablyConnected[identifier] ?? false;
  }

  pprint(data) {
    print(data);
    // toPrint.add(data);
  }

  dispose() {
    sockets.forEach((key, value) {
      _sockectManager.clearInstance(value);
    });
  }
}
