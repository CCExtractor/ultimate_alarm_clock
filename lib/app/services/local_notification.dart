import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const String channelId = '1';
  static const String channelDescription = 'Channel Description';
  static const String channelName = 'high_important_channel';

  Future<void> init() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static void showLocalNotification({
    String? title,
    String? value,
  }) async {
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    int notificationId = 1;

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin
        .show(
          notificationId,
          title,
          value,
          platformChannelSpecifics,
        )
        .whenComplete(() => log('notification sent successfully'))
        .catchError((e) => log('error $e'));
  }

  static Future<void> showNotificationWithChronometer(
    var when,
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      onlyAlertOnce: true,
      silent: true,
      ongoing: true,
      importance: Importance.min,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      platformChannelSpecifics,
    );
  }

}
