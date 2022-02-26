import 'package:flutter/material.dart';
import 'package:notification/notificationplugins.dart';

class LocalNotification extends StatefulWidget {
  const LocalNotification({Key? key}) : super(key: key);

  @override
  _LocalNotificationState createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    notificationPlugins.setListenerForLowerVersions(onNotificationClick);
    notificationPlugins.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("local Notification"),
      ),
      body: Center(
        child: FlatButton(
            onPressed: () async {
              //await notificationPlugins.showNotification();
              //await notificationPlugins.scheduleNotification();
              //await notificationPlugins.showNotificationWithAttachment();
              //await notificationPlugins.repeatNotification();
              // await notificationPlugins.showDailyAtTime();
              await notificationPlugins.showWeeklyDayTime();
              count = await notificationPlugins.getPendingNotification();
              print(count);
              await notificationPlugins.cancelNotification();
              print(count);
            },
            child: Text("Send notification $count")),
      ),
    );
  }

  onNotificationInLowerVersions(receivedNotification) {}

  onNotificationClick(payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }
}
