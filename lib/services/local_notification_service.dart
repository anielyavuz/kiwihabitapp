import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  static final _notifications = FlutterLocalNotificationsPlugin();
  static const String darwinNotificationCategoryPlain = 'plainCategory';
  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: darwinNotificationCategoryPlain,
      ),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);
}
