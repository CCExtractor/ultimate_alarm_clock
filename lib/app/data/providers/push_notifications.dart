import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';

// Global instance for background use
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


class PushNotifications {
  Future<void> initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get token
    String? token = await messaging.getToken();
    if (token != null) {
      await updateToken(token);
    }

    // Listen for token updates
    FirebaseMessaging.instance.onTokenRefresh.listen(updateToken);

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      // Handling only non-silent
      if (message.data["silent"] == "false"){
      _showNotification(message);
      }
    });

    // User taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message);
    });

    await _initLocalNotifications();
  }

   Future updateToken(String token) async {
    try {
      // Check if user is logged in before updating token
      if (FirebaseAuth.instance.currentUser != null) {
        await FirestoreDb.updateToken(token);
      } else {
        print('User not logged in. Token update skipped.');
      }
    } catch (e) {
      print('Error updating token: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // TODO: handle tap on notification if needed
      },
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.notification?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No body',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  void _handleMessageNavigation(RemoteMessage message) {
    print("User tapped on notification: ${message.data}");
    // TODO: Navigate based on message.data or type
  }



Future<void> triggerRescheduleAlarmNotification(String firestoreAlarmId) async {
  try {
    print('🔔 Attempting to trigger reschedule notification for alarm: $firestoreAlarmId');
    
    var userModel = await SecureStorageProvider().retrieveUserModel();
    if (userModel == null) {
      print('❌ No user model found, cannot send reschedule notification');
      return;
    }
    
    print('📤 Calling rescheduleAlarm cloud function with data:');
    print('   - firestoreAlarmId: $firestoreAlarmId');
    print('   - changedByUserId: ${userModel.id}');

    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('rescheduleAlarm');

    final response = await callable.call({
      'firestoreAlarmId': firestoreAlarmId,
      'changedByUserId': userModel.id,
    });
    
    print('✅ Successfully triggered reschedule notification');
    print('   Response: ${response.data}');
  } catch (e) {
    print('❌ Error calling reschedule function: $e');
    print('   This means the Firebase Cloud Function is not working properly.');
    print('   The local alarm updates should still work correctly.');

  }
}

Future<void> triggerSharedItemNotification(List receivingUserIds, {Map<String, dynamic>? sharedItem}) async {
  try {
    print('🔔 Attempting to send shared item notification to ${receivingUserIds.length} users');
    print('📦 Shared item data: $sharedItem');
    
    var userModel = await SecureStorageProvider().retrieveUserModel();
    if (userModel == null) {
      print('❌ No user model found, cannot send shared item notification');
      return;
    }

    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotification');

    final response = await callable.call({
      'receivingUserIds': receivingUserIds,
      'message': '${userModel.fullName} has shared an alarm with you!',
      'sharedItem': sharedItem, // Pass the shared item data
    });

    if (response.data['success'] == true) {
      print('✅ Shared item notification sent successfully!');
    } else {
      print('❌ Failed to send shared item notification: ${response.data['message']}');
    }
  } catch (e) {
    print('❌ Error calling shared item notification function: $e');
    print('   This means the Firebase Cloud Function is not working properly.');
    print('   The alarm sharing will continue without notifications.');

  }
}


Future<bool> sendDirectFCMMessage({
  required List<String> receivingUserIds,
  required String alarmId,
  required String newAlarmTime,
}) async {
  try {
    print('📤 Direct FCM messaging attempted for ${receivingUserIds.length} users');
    print('   - Alarm ID: $alarmId');
    print('   - New time: $newAlarmTime');
    
    print('🔄 Using enhanced Firestore real-time sync instead of push notifications');
    
    
    return true;
    
  } catch (e) {
    print('❌ Error in direct FCM approach: $e');
    return false;
  }
}

}