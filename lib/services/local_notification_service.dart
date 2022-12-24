import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class NotificationsServices {
  // static const String darwinNotificationCategoryText = 'textCategory';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('@drawable/ic_kiwilogo');
  final IOSInitializationSettings iosInitializationSettings =
      IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

  final StreamController didReceiveLocalNotificationStream =
      StreamController.broadcast();

  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings(
  //   requestAlertPermission: false,
  //   requestBadgePermission: false,
  //   requestSoundPermission: false,
  //   onDidReceiveLocalNotification:
  //       (int id, String? title, String? body, String? payload) async {
  //     // didReceiveLocalNotificationStream.add(
  //     //   ReceivedNotification(
  //     //     id: id,
  //     //     title: title,
  //     //     body: body,
  //     //     payload: payload,
  //     //   ),
  //     // );
  //   },
  //   // notificationCategories: darwinNotificationCategories,
  // );

  static void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print("id $id");
  }

  Future<void> initialiseNotifications() async {
    tz.initializeTimeZones();

    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void onSelectNotification(String? payload) {
    print('payload $payload');
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  void sendNotifications(String title, String body) async {
    // const DarwinNotificationDetails darwinNotificationDetails =
    //     DarwinNotificationDetails(
    //   categoryIdentifier: darwinNotificationCategoryText,
    // );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
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

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
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
        androidAllowWhileIdle: true,
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

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, tzz, notificationDetails,
        androidAllowWhileIdle: true,
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

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
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
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime);
  // }

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
