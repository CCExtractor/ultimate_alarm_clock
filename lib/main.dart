import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/language.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/custom_error_screen.dart';
import 'app/routes/app_pages.dart';
Locale? loc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//To clear that flutter is ready to run.

  await Firebase.initializeApp();//Initialize firebase
  await Get.putAsync(() => GetStorageProvider().init());
  final storage=Get.find<GetStorageProvider>();
  loc = await storage.readLocale();

  AudioPlayer.global.setAudioContext(
    const AudioContext(
      android: AudioContextAndroid(
        audioMode: AndroidAudioMode.ringtone,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.alarm,
        audioFocus: AndroidAudioFocus.gainTransient,
      ),
    ),
  );//For audio players we have to set AudioContext player  globally or player specific depends on developer.

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,// to set orientation of mobile app up
    DeviceOrientation.portraitDown,// to set orientation of mobile app down
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    UltimateAlarmClockApp(),
  );
}

class UltimateAlarmClockApp extends StatelessWidget {
  UltimateAlarmClockApp({super.key});
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
      fallbackLocale: Locale('en', 'US',),
      builder: (BuildContext context, Widget? error) {
        ErrorWidget.builder = (FlutterErrorDetails? error) {
          return CustomErrorScreen(errorDetails: error!);
        };
        return error!;
      },
    );
  }
}
