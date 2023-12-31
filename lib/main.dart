import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/languages/bindings/language_binding.dart';
import 'package:ultimate_alarm_clock/app/utils/language.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/custom_error_screen.dart';
import 'app/routes/app_pages.dart';

var storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  //multi language storage
  await initialConfig();

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
    UltimateAlarmClockApp(),
  );
}

initialConfig() async{
  await Get.putAsync(() => GetStorageProvider().init());
}

class UltimateAlarmClockApp extends StatelessWidget {
  UltimateAlarmClockApp({super.key});
  final storage = Get.find<GetStorageProvider>();

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
      locale: storage.lanCode!=null
          ? Locale(storage.lanCode!, storage.countryCode) : Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      initialBinding: LanguageBinding(),
      builder: (BuildContext context, Widget? error) {
        ErrorWidget.builder = (FlutterErrorDetails? error) {
          return CustomErrorScreen(errorDetails: error!);
        };
        return error!;
      },
    );
  }
}
