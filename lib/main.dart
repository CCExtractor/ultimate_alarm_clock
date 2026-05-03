import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/push_notifications.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/language.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/custom_error_screen.dart';
import 'package:ultimate_alarm_clock/app/utils/shared_alarm_logger.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';

Locale? loc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
  }
  
  try {
    await PushNotifications().initFirebaseMessaging();
  } catch (e) {
    debugPrint('❌ Push notifications initialization failed: $e');
  }
  
  try {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  } catch (e) {
    debugPrint('❌ Permission request failed: $e');
  }


  await Get.putAsync(() => GetStorageProvider().init());

  final storage = Get.find<GetStorageProvider>();
  loc = await storage.readLocale();

  Get.put(ThemeController());

  AudioPlayer.global.setAudioContext(
    const AudioContext(
      android: AudioContextAndroid(
        audioMode: AndroidAudioMode.ringtone,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.alarm,
        audioFocus: AndroidAudioFocus.gainTransient,
      ),
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Check for pending shared alarms from background/terminated FCM messages.
  // We schedule this after the first frame so GetX navigation is ready.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkPendingSharedAlarms();
  });

  runApp(
    const UltimateAlarmClockApp(),
  );
}

/// Checks for any shared alarm notifications that arrived while the app was
/// in background or killed. If any are found, navigates to the notifications
/// page so the user can accept or decline them.
Future<void> _checkPendingSharedAlarms() async {
  try {
    final pendingCount = await PushNotifications.getPendingSharedAlarmCount();
    if (pendingCount > 0) {
      SharedAlarmLogger.log('PENDING_ALARMS_ON_STARTUP', details: {
        'count': pendingCount,
      });
      // Wait for the splash screen to finish before navigating
      await Future.delayed(const Duration(seconds: 3));
      Get.toNamed('/notifications');
    }
  } catch (e) {
    debugPrint('❌ Error checking pending shared alarms on startup: $e');
  }
}


class UltimateAlarmClockApp extends StatelessWidget {
  const UltimateAlarmClockApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: kLightThemeData,
      darkTheme: kThemeData,
      themeMode: ThemeMode.system,
      title: 'UltiClock',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: loc,
      fallbackLocale: Locale('en', 'US'),
      builder: (BuildContext context, Widget? error) {
        ErrorWidget.builder = (FlutterErrorDetails? error) {
          return CustomErrorScreen(errorDetails: error!);
        };
        return error!;
      },
    );
  }
}
