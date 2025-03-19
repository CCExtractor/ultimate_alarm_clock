import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controllers/stopwatch_controller.dart';

class LocalNotification with WidgetsBindingObserver {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LocalNotification() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Initialize Notification
  static Future<void> initNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('notificationicon');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// Show Stopwatch Notification when app is in background
  Future<void> showStopwatchNotification() async {
    final StopwatchController stopwatchController = Get.find();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'stopwatch_channel',
      'Stopwatch',
      channelDescription: 'Controls stopwatch',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true, // Keeps the notification persistent
      onlyAlertOnce: true,
      actions: [
        AndroidNotificationAction('pause', 'Pause', showsUserInterface: true),
        AndroidNotificationAction('start', 'Start', showsUserInterface: true),
        AndroidNotificationAction('reset', 'Reset', showsUserInterface: true),
      ],
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Stopwatch Running',
      stopwatchController.result,
      details,
    );
  }

  /// Cancel the notification
  Future<void> cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }

  /// Handle Notification Tap Actions
  static void onNotificationTap(NotificationResponse response) {
    final StopwatchController stopwatchController =
        Get.put(StopwatchController(), permanent: true);

    switch (response.actionId) {
      case 'pause':
        stopwatchController.stopTimer();
        break;
      case 'start':
        stopwatchController.startTimer();
        break;
      case 'reset':
        stopwatchController.resetTime();
        break;
    }
  }

  /// Show notification when app goes to background and hide when foregrounded
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final StopwatchController stopwatchController = Get.find();

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (!stopwatchController.isTimerPaused.value) {
        showStopwatchNotification();
      }
    } else if (state == AppLifecycleState.resumed) {
      cancelNotification();
    }
  }
}
