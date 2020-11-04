import 'package:flutter/material.dart';
import 'package:flutter_notification/local_notify_manager.dart';

class TextNotifyScreen extends StatefulWidget {
  @override
  _TextNotifyScreenState createState() => _TextNotifyScreenState();
}

class _TextNotifyScreenState extends State<TextNotifyScreen> {
  @override
  void initState() {
    super.initState();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification Received : ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload : $payload');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Notification"),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () async {
            // await localNotifyManager.showNotification(
            //     1, "Title", "Body", "New Payload");
            // await localNotifyManager.scheduleNotification(
            //     2,
            //     "Schedule Title",
            //     "Schedule Body",
            //     "Schedule  Payload",
            //     DateTime.now().add(Duration(seconds: 5)));
            // await localNotifyManager.repeateveryMinuteNotification(
            //     3, "Repeat Title", "Repeat Body", "New Payload");
            await localNotifyManager.showDailyAtTimeNotification(
                4,
                "Same Time EveryDay Title",
                "Same Time EveryDay Body",
                "Same Time EveryDay Payload",
                11,
                38,
                62);
          },
          child: Text("Send Notification"),
        ),
      ),
    );
  }
}
