import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationsServices {
  // Singleton
  static final NotificationsServices _instance = NotificationsServices._internal();
  factory NotificationsServices() => _instance;
  NotificationsServices._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('@drawable/ic_kiwilogo');
  final DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true);

  Future<void> initialiseNotifications() async {
    tzdata.initializeTimeZones();
    final currentTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));

    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null && response.payload!.isNotEmpty) {
        onNotificationClick.add(response.payload);
      }
    });
  }

  /// Schedules a daily repeating notification at the given [time].
  /// Uses [id] to allow cancellation later (cancelNotification(id)).
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'kiwi_daily',
        'Daily Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels a previously scheduled notification by [id].
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  void sendNotifications(String title, String body) async {
    // const DarwinNotificationDetails darwinNotificationDetails =
    //     DarwinNotificationDetails(
    //   categoryIdentifier: darwinNotificationCategoryText,
    // );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  void sendScheduledNotifications(
      int id, String title, String body, int seconds) async {
    // const DarwinNotificationDetails darwinNotificationDetails =
    //     DarwinNotificationDetails(
    //   categoryIdentifier: darwinNotificationCategoryText,
    // );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(
          Duration(seconds: seconds),
        ),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void sendScheduledNotifications2(
      int id, String title, String body, var tzz) async {
    // const DarwinNotificationDetails darwinNotificationDetails =
    //     DarwinNotificationDetails(
    //   categoryIdentifier: darwinNotificationCategoryText,
    // );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, tzz, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void sendPayloadNotifications(
      int id, String title, String body, String payload) async {
    // const DarwinNotificationDetails darwinNotificationDetails =
    //     DarwinNotificationDetails(
    //   categoryIdentifier: darwinNotificationCategoryText,
    // );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await _flutterLocalNotificationsPlugin
        .show(id, title, body, notificationDetails, payload: payload);
  }

  // void ScheduleNotifications(String title, String body) async {
  //   var scheduledTime = DateTime.now().add(Duration(seconds: 10));
  //   AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails('channelId', 'channelName',
  //           importance: Importance.max, priority: Priority.high);
  //   NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   await _flutterLocalNotificationsPlugin.periodicallyShow(
  //       0, title, body, RepeatInterval.everyMinute, notificationDetails);
  // }

  // void specificTimeNotification(
  //     String title, String body, int id, int duration) async {
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tz.TZDateTime.now(tz.local).add(Duration(seconds: duration)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails('channel id', 'channel name',
  //               importance: Importance.max,
  //               priority: Priority.high,
  //               channelDescription: 'channel description')),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime);
  // }

  void stopOneNotificationWithID(int _id) async {
    _flutterLocalNotificationsPlugin.cancel(_id);
  }

  void stopNotifications() async {
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}



// class LocalNotificationService {
//   LocalNotificationService();

//   static final _notifications = FlutterLocalNotificationsPlugin();
//   static const String darwinNotificationCategoryPlain = 'plainCategory';
//   static Future _notificationDetails() async {
//     return NotificationDetails(
//       android: AndroidNotificationDetails('channel id', 'channel name',
//           channelDescription: 'channel description',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker'),
//       iOS: DarwinNotificationDetails(
//         categoryIdentifier: darwinNotificationCategoryPlain,
//       ),
//     );
//   }

//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       _notifications.show(id, title, body, await _notificationDetails(),
//           payload: payload);
// }
