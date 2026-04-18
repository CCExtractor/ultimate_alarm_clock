import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controllers/stopwatch_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/worldClock/controllers/world_clock_controller.dart';

class BottomNavigationBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationBarController>(
      () => BottomNavigationBarController(),
    );

    Get.lazyPut<StopwatchController>(
      () => StopwatchController(),
    );
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    Get.lazyPut<WorldClockController>(() => WorldClockController());
  }
}
