import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ultimate_alarm_clock/app/utils/app_logger.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static Future init() async {
    await _firebaseMessaging.requestPermission(announcement: true);
    final token = await _firebaseMessaging.getToken();
    if (token == null || token.isEmpty) {
      AppLogger.w('Push token was unavailable', tag: 'PushNotifications');
      return;
    }
    AppLogger.i('Push token fetched successfully', tag: 'PushNotifications');
  }
}
