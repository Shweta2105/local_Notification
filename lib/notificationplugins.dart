import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class NotificationPlugins {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification> didReceivedNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializeSetting;

  NotificationPlugins._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatform();
  }

  initializePlatform() {
    var initializeAndroid = const AndroidInitializationSettings('noti_icon');
    initializeSetting = InitializationSettings(android: initializeAndroid);
  }

  static Future<void> onNotificationSelect(String? payload) async {
    print(payload);
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(
      initializeSetting,
      onSelectNotification: (String? payload) async {
        onNotificationClick(payload);
      },
    );
  }

  Future<void> showNotification() async {
    var android = AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true));
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, '<b>local check</b>', 'notification check', platform,
        payload: 'Test payload');
  }

  Future<void> scheduleNotification() async {
    var scheduleDateTime = DateTime.now().add(Duration(seconds: 5));
    var android = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 2',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.schedule(
        0, 'local check', 'notification check', scheduleDateTime, platform,
        payload: 'Test payload');
  }

  Future<void> showNotificationWithAttachment() async {
    var attachment = await _downloadAndSaveFile(
        'https://via.placeholder.com/120x80', 'attachment.jpg');
    var pictureStyleInfo = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachment),
      contentTitle: "image attached",
      htmlFormatContentTitle: true,
    );
    var android = AndroidNotificationDetails('CHANNEL_ID 2', 'CHANNEL_NAME 2',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: pictureStyleInfo);
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, 'image check', 'body with attachment', platform,
        payload: 'Test payload');
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> repeatNotification() async {
    var android = AndroidNotificationDetails('CHANNEL_ID 3', 'CHANNEL_NAME 3',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true));
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        '<b>local check</b>',
        'notification check',
        RepeatInterval.everyMinute,
        platform,
        payload: 'Test payload');
  }

  Future<void> showDailyAtTime() async {
    var time = Time(11, 40, 0);
    var android = AndroidNotificationDetails('CHANNEL_ID 4', 'CHANNEL_NAME 4',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true));
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        '<b>local check at ${time.hour}:${time.minute}</b>',
        'notification check',
        time,
        platform,
        payload: 'Test payload');
  }

  Future<void> showWeeklyDayTime() async {
    var time = Time(11, 56, 0);
    var android = AndroidNotificationDetails('CHANNEL_ID 5', 'CHANNEL_NAME 5',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true));
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        5,
        '<b>local check at ${time.hour}:${time.minute}</b>',
        'notification check',
        Day.saturday,
        time,
        platform,
        payload: 'Test payload');
  }

  Future<int> getPendingNotification() async {
    List<PendingNotificationRequest> pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pending.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(5);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

NotificationPlugins notificationPlugins = NotificationPlugins._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
