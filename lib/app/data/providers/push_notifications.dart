import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static Future init() async {
    await _firebaseMessaging.requestPermission(announcement: true);
    final token = await _firebaseMessaging.getToken();
    print('token - $token');
  }
}
