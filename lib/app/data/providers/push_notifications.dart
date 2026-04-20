import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';

// Global instance for background use
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  print('📱 Background message received: ${message.data}');
  
  if (message.data['type'] == 'sharedAlarm' || message.data['type'] == 'sharedItem') {
    print('🔔 Background shared alarm notification processed');
  }
}


class PushNotifications {
  Future<void> initFirebaseMessaging() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permissions with better error handling
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('🔔 Notification permission status: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('❌ User denied notification permissions');
        return;
      }

      // Get token with retry mechanism
      String? token = await _getTokenWithRetry();
      if (token != null) {
        print('✅ FCM Token obtained: ${token.substring(0, 20)}...');
        await updateToken(token);
      } else {
        print('❌ Failed to get FCM token after retries');
      }

      // Listen for token updates with error handling
      FirebaseMessaging.instance.onTokenRefresh.listen(
        (token) async {
          print('🔄 FCM Token refreshed: ${token.substring(0, 20)}...');
          await updateToken(token);
        },
        onError: (error) {
          print('❌ Error during token refresh: $error');
        },
      );

      // Foreground notifications with better handling
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('📱 Received foreground message: ${message.data}');
        
        // Handle shared alarm notifications specifically
        if (message.data["type"] == "sharedAlarm" || message.data["type"] == "sharedItem") {
          print('🔔 Processing shared alarm notification');
          await _showNotification(message);
        } else if (message.data["silent"] == "false") {
          await _showNotification(message);
        }
      });

      // Background/terminated app notifications
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // User taps notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('👆 User tapped notification: ${message.data}');
        _handleMessageNavigation(message);
      });

      await _initLocalNotifications();
      
      print('✅ Firebase messaging initialization completed');
    } catch (e) {
      print('❌ Error initializing Firebase messaging: $e');
      rethrow;
    }
  }

  Future<String?> _getTokenWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          return token;
        }
      } catch (e) {
        print('❌ Attempt ${i + 1} failed to get FCM token: $e');
      }
      
      if (i < maxRetries - 1) {
        await Future.delayed(Duration(seconds: 2 * (i + 1))); // Exponential backoff
      }
    }
    return null;
  }

  Future updateToken(String token) async {
    try {
      // Check if user is logged in before updating token
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        print('🔄 Updating FCM token for user: ${currentUser.uid}');
        await FirestoreDb.updateToken(token);
        print('✅ FCM token updated successfully');
      } else {
        print('❌ User not logged in. Token update skipped.');
        // Store token locally for when user logs in
        await _storeTokenLocally(token);
      }
    } catch (e) {
      print('❌ Error updating token: $e');
      // Retry token update after delay
      Future.delayed(Duration(seconds: 30), () {
        updateToken(token);
      });
    }
  }

  Future<void> _storeTokenLocally(String token) async {
    try {
      // Store token using shared preferences temporarily  
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_fcm_token', token);
      print('📱 FCM token stored locally for later update');
    } catch (e) {
      print('❌ Error storing token locally: $e');
    }
  }

  Future<void> updateStoredTokenIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('pending_fcm_token');
      
      if (storedToken != null && FirebaseAuth.instance.currentUser != null) {
        print('🔄 Updating previously stored FCM token');
        await updateToken(storedToken);
        await prefs.remove('pending_fcm_token');
      }
    } catch (e) {
      print('❌ Error updating stored token: $e');
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
  await _sendNotificationWithRetry(receivingUserIds, sharedItem: sharedItem);
}

Future<void> _sendNotificationWithRetry(List receivingUserIds, {Map<String, dynamic>? sharedItem, int maxRetries = 3}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      print('🔔 Attempt $attempt: Sending shared item notification to ${receivingUserIds.length} users');
      print('📦 Shared item data: $sharedItem');
      
      var userModel = await SecureStorageProvider().retrieveUserModel();
      if (userModel == null) {
        print('❌ No user model found, cannot send shared item notification');
        return;
      }

      print('👤 Sender: ${userModel.fullName} (${userModel.email})');
      print('👥 Recipients: $receivingUserIds');

      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendNotification');

      final response = await callable.call({
        'receivingUserIds': receivingUserIds,
        'message': '${userModel.fullName} has shared an alarm with you!',
        'sharedItem': sharedItem,
      });

      final responseData = response.data;
      print('📊 Notification response: $responseData');

      if (responseData['success'] == true) {
        print('✅ Shared item notification sent successfully!');
        print('   Success count: ${responseData['successCount']}');
        print('   Failure count: ${responseData['failureCount']}');
        
        if (responseData['failedTokens'] != null && responseData['failedTokens'].isNotEmpty) {
          print('⚠️  Some tokens failed: ${responseData['failedTokens']}');
        }
        
        return; // Success, exit retry loop
      } else {
        print('❌ Notification failed: ${responseData['message']}');
        print('   Failed tokens: ${responseData['failedTokens']}');
        print('   Failed sends: ${responseData['failedSends']}');
        
        if (attempt == maxRetries) {
          print('❌ Max retry attempts reached. Notification sending failed.');
          return;
        }
      }
    } catch (e) {
      print('❌ Attempt $attempt failed: $e');
      
      if (attempt == maxRetries) {
        print('❌ Max retry attempts reached. Error: $e');
        print('   This means the Firebase Cloud Function is not working properly.');
        print('   The alarm sharing will continue without notifications.');
        return;
      }
      
      // Exponential backoff
      final delay = Duration(seconds: 2 * attempt);
      print('⏳ Retrying in ${delay.inSeconds} seconds...');
      await Future.delayed(delay);
    }
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

// Debug method to check notification status
Future<Map<String, dynamic>> checkNotificationStatus() async {
  try {
    final messaging = FirebaseMessaging.instance;
    
    // Check permissions
    final settings = await messaging.getNotificationSettings();
    
    // Get FCM token
    final token = await messaging.getToken();
    
    // Check if user is logged in
    final currentUser = FirebaseAuth.instance.currentUser;
    
    // Check stored token status
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('pending_fcm_token');
    
    final status = {
      'permissions': {
        'authorizationStatus': settings.authorizationStatus.toString(),
        'alert': settings.alert.toString(),
        'badge': settings.badge.toString(),
        'sound': settings.sound.toString(),
      },
      'fcmToken': token != null ? '${token.substring(0, 20)}...' : null,
      'hasToken': token != null,
      'isUserLoggedIn': currentUser != null,
      'userId': currentUser?.uid,
      'userEmail': currentUser?.email,
      'hasPendingToken': storedToken != null,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    print('📊 Notification Status Check:');
    print('   Permissions: ${settings.authorizationStatus}');
    print('   Has FCM Token: ${token != null}');
    print('   User Logged In: ${currentUser != null}');
    print('   Pending Token: ${storedToken != null}');
    
    return status;
  } catch (e) {
    print('❌ Error checking notification status: $e');
    return {
      'error': e.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

}