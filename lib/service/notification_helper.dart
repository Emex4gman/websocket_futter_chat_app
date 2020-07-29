import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notify {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  static Notify _notify;
  Notify.createInstance();
  // factory Notify() {
  //   if (_notify == null) {
  //     _notify = Notify.createInstance();
  //   }
  //   return _notify;
  // }

  Notify.getInstance() {
    if (_notify == null) {
      _notify = Notify.createInstance();
      initialization();
    }
  }

  initialization() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          _onSelectNotification(payload),
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await notifications.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future _onSelectNotification(String payload) async => null;

  NotificationDetails get _ongoing {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: true,
    );
    final iosNotificationDetails = IOSNotificationDetails();
    return NotificationDetails(
        androidPlatformChannelSpecifics, iosNotificationDetails);
  }

  NotificationDetails get noSound {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'silent channel id',
        'silent channel name',
        'silent channel description',
        playSound: false);
    final iosNotificationDetails = IOSNotificationDetails(presentSound: false);
    return NotificationDetails(
        androidPlatformChannelSpecifics, iosNotificationDetails);
  }

  Future showNotification(
      {@required String title, @required String body, int id = 0}) async {
    await notifications.show(id, title, body, _ongoing);
  }
}
