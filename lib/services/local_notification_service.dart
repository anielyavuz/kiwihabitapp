import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:timezone/timezone.dart' as tz;

class NotificationsServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('logo');

  void initialiseNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotifications(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  void ScheduleNotifications(String title, String body) async {
    var scheduledTime = DateTime.now().add(Duration(seconds: 10));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0, title, body, RepeatInterval.everyMinute, notificationDetails);
  }

  void specificTimeNotification(
      String title, String body, int id, int duration) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: duration)),
        const NotificationDetails(
            android: AndroidNotificationDetails('channel id', 'channel name',
                importance: Importance.max,
                priority: Priority.high,
                channelDescription: 'channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void stopNotifications() async {
    _flutterLocalNotificationsPlugin.cancel(0);
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
