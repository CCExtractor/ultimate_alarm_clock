import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/bindings/about_binding.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/about_view.dart';
import 'package:ultimate_alarm_clock/app/modules/splashScreen/bindings/splash_screen_binding.dart';
import 'package:ultimate_alarm_clock/app/modules/splashScreen/views/splash_screen_view.dart';

import '../modules/addOrUpdateAlarm/bindings/add_or_update_alarm_binding.dart';
import '../modules/addOrUpdateAlarm/views/add_or_update_alarm_view.dart';
import '../modules/alarmChallenge/bindings/alarm_challenge_binding.dart';
import '../modules/alarmChallenge/views/alarm_challenge_view.dart';
import '../modules/alarmRing/bindings/alarm_ring_binding.dart';
import '../modules/alarmRing/views/alarm_ring_view.dart';
import '../modules/alarmRingIgnore/bindings/alarm_ring_ignore_binding.dart';
import '../modules/alarmRingIgnore/views/alarm_ring_ignore_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_OR_UPDATE_ALARM,
      page: () => AddOrUpdateAlarmView(),
      binding: AddOrUpdateAlarmBinding(),
    ),
    GetPage(
      name: _Paths.ALARM_RING,
      page: () => AlarmControlView(),
      binding: AlarmControlBinding(),
    ),
    GetPage(
      name: _Paths.ALARM_RING_IGNORE,
      page: () => AlarmControlIgnoreView(),
      binding: AlarmControlIgnoreBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.ALARM_CHALLENGE,
      page: () => AlarmChallengeView(),
      binding: AlarmChallengeBinding(),
    ),
    //AboutView
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: AboutBinding(),
    ),

  ];
}
