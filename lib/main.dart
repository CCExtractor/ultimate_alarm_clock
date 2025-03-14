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
import 'package:dynamic_color/dynamic_color.dart';

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

 ThemeData _createLightTheme(ColorScheme? lightDynamic) {
  final ColorScheme lightScheme = lightDynamic ?? const ColorScheme.light();

  return ThemeData(
    colorScheme: lightScheme,
    brightness: Brightness.light,
    fontFamily: "Poppins",
    textTheme: createTextTheme(lightScheme, false),
  );
}

ThemeData _createDarkTheme(ColorScheme? darkDynamic) {
  final ColorScheme darkScheme = darkDynamic ?? const ColorScheme.dark();

  return ThemeData(
    colorScheme: darkScheme,
    brightness: Brightness.dark,
    fontFamily: "Poppins",
    textTheme: createTextTheme(darkScheme, true),
  );
}

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Obx(() {
          return GetMaterialApp(
            theme: _createLightTheme(lightDynamic),
            darkTheme: _createDarkTheme(darkDynamic),
            themeMode: Get.find<ThemeController>().currentTheme.value,
            title: 'UltiClock',
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            translations: AppTranslations(),
            locale: loc,
            fallbackLocale: const Locale('en', 'US'),
            builder: (BuildContext context, Widget? error) {
              ErrorWidget.builder = (FlutterErrorDetails? error) {
                return CustomErrorScreen(errorDetails: error!);
              };
              return error!;
            },
          );
        });
      },
    );
  }
}