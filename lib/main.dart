import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

import 'package:ultimate_alarm_clock/app/utils/language.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/custom_error_screen.dart';
import 'app/routes/app_pages.dart';

Locale? loc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await Firebase.initializeApp();

  await Get.putAsync(() => GetStorageProvider().init());

  final storage = Get.find<GetStorageProvider>();
  loc = await storage.readLocale();

  final ThemeController themeController = Get.put(ThemeController());

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
  runApp(
    const UltimateAlarmClockApp(),
  );
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


class CreateAlarmScreen extends StatelessWidget {
  const CreateAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Alarm")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Action to create an alarm
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50), // Fixed size
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Reduced padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Smooth button edges
            ),
            backgroundColor: Colors.blue, // Change color if needed
          ),
          child: const Text(
            "Create Alarm",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Adjust text style
          ),
        ),
      ),
    );
  }
}