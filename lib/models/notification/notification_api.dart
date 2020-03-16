import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

class NotificationApi {
  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  final Future<dynamic> Function(int, String, String, String) onDidReceiveLocalNotification;
  final Future<dynamic> Function(String) onSelectNotification;
  NotificationApi({
    Future<dynamic> Function(int, String, String, String) onDidReceiveLocalNotification,
    Future<dynamic> Function(String) onSelectNotification
  }) : this.onDidReceiveLocalNotification = onDidReceiveLocalNotification,
        this.onSelectNotification = onSelectNotification;

  Future <bool> initialize() async {
    print('init');
    var initializationSettingsAndroid =
    AndroidInitializationSettings('logo');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    print('start');
    try {
      await plugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
    } catch (e) {
      print(e);
      throw e;
    }
    print('finish');
    return true;
  }
  Future<void> display() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await plugin.show(
        0, 'Hello', 'world', platformChannelSpecifics,
        payload: 'item x');
  }
}