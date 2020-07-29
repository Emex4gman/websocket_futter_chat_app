import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:websocket_futter_chat_app/model/chat_message.dart';
import 'package:websocket_futter_chat_app/service/my_stream.dart';

enum ROOMS { COED, MALE, FEMALE, TRANS }

class SocketHelper {
  String uri = "https://d3ddc88e1607.ngrok.io";
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
  Future<void> initSocket({String identifier, MyStream streamContoller}) async {
    if (isProbablyConnected(identifier)) {
      print('Socket is already connected');
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
        enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
        ] //Enable required transport
        ));

    socket.onConnect((data) {
      print("connected...");
    });
    socket.on("home", (data) => print(data));
    socket.on("$identifier", (data) {
      streamContoller.addChatWithIdentifyer(
          identifier: identifier, value: ChatMessage(message: data));
    });
    socket.connect();
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    sockets[identifier] = socket;
  }

  sendMessageE({String identifier, MyStream stream, String message}) {
    if (sockets[identifier] != null) {
      sockets[identifier].emit("$identifier", [message]);
    }
  }

  handerr(error, namespcae) {
    print('$namespcae: ${error.toString()}');
  }

  bool isProbablyConnected(String identifier) {
    return _isProbablyConnected[identifier] ?? false;
  }

  pprint(data) {
    print(data);
  }

  dispose() {
    sockets.forEach((key, value) {
      _sockectManager.clearInstance(value);
    });
  }
}
