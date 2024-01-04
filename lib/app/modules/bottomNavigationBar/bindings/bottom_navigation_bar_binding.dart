import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controller/stopwatch_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

class BottomNavigationBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TimerController>(
      TimerController(),
    );
    Get.put<StopwatchController>(
      StopwatchController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.put<HomeController>(
      HomeController(),
    );
    Get.put<ThemeController>(
      ThemeController(),
    );
    Get.put<BottomNavigationBarController>(
      BottomNavigationBarController(),
    );
  }
}
