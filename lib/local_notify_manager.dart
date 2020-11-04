import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification/repeat.dart';

import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
    tz.initializeDatabase([]);
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  void initializePlatform() {
    var initSettingAndorid =
        AndroidInitializationSettings('app_notification_icon');
    var initSettingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceiveNotification notification = ReceiveNotification(
            id: id, title: title, body: body, payload: payload);
        didReceiveLocalNotificationSubject.add(notification);
      },
    );
    initSetting = InitializationSettings(
        android: initSettingAndorid, iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    var androidChannel = AndroidNotificationDetails(
      "channelId 1", "channelName 1", "channelDescription 1",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // add if need
      // sound: RawResourceAndroidNotificationSound('notification_sound'),
      // icon: 'icon_notification_replace',
      // largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 5000,
      enableLights: true,
    );
    var iosChannel =
        IOSNotificationDetails(/*sound: 'notification_sound.mp3',*/);
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannel,
      payload: payload,
    );
  }

// İstenilen süre eklenerek
  Future<void> scheduleNotification(int id, String title, String body,
      String payload, DateTime dateTime) async {
    var androidChannel = AndroidNotificationDetails(
        "channelId 2", "channelName 2", "channelDescription 2",
        importance: Importance.max, priority: Priority.high, playSound: true);
    var iosChannel =
        IOSNotificationDetails(/*sound: 'notification_sound.mp3',*/);

    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      platformChannel,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

// Dakikada bir
  Future<void> repeateveryMinuteNotification(
      int id, String title, String body, String payload) async {
    var androidChannel = AndroidNotificationDetails(
        "channelId 3", "channelName 3", "channelDescription 3",
        importance: Importance.max, priority: Priority.high, playSound: true);
    var iosChannel =
        IOSNotificationDetails(/*sound: 'notification_sound.mp3',*/);
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      platformChannel,
      payload: payload,
    );
  }

// Hergün
  Future<void> showDailyAtTimeNotification(
      int id, String title, String body, String payload, int hour,
      [int minite = 0, int second = 0]) async {
    var androidChannel = AndroidNotificationDetails(
        "channelId 4", "channelName 4", "channelDescription 4",
        importance: Importance.max, priority: Priority.high, playSound: true);
    var iosChannel =
        IOSNotificationDetails(/*sound: 'notification_sound.mp3',*/);
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      Repeat.nextInstanceOfTime(hour, minite, second),
      platformChannel,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceiveNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}
