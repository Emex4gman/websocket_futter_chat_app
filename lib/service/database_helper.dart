import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:websocket_futter_chat_app/model/user.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  DataBaseHelper.createInstance();
  static Box _fxChatBox;

  static String isLoggedInKey = "ISLOGGEDIN";
  static String userKey = "USERNAME";

  String myname;
  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper.createInstance();
    }
    return _dataBaseHelper;
  }

  Future<Box> get fxChatBox async {
    if (_fxChatBox == null) {
      _fxChatBox = await initHive();
    }
    return Hive.box('fx_chat');
  }

  Future<Box> initHive() async {
    var path = await getApplicationDocumentsDirectory();

    Hive..init(path.path);
    // ..registerAdapter(UserHiveAdapter());
    ;
    return await Hive.openBox('fx_chat');
  }

  Future<void> saveUser(Map userMap) async {
    print(userMap);
    (await this.fxChatBox).put(userKey, userMap);
  }

  Future<void> saveUserIsloggedin(bool isUserLoggedIn) async {
    (await this.fxChatBox).put(isLoggedInKey, isUserLoggedIn);
  }

  Future<void> saveUserUserName(String userName) async {
    (await this.fxChatBox).put(userKey, userName);
  }

  // get data from local
  Future<void> getUserIsloggedin() async {
    (await this.fxChatBox).get(isLoggedInKey);
  }

  // get data from local
  Future<User> getUser() async {
    Map userMap = (await this.fxChatBox).get(userKey);
    return User.fromMap(userMap);
  }
}
