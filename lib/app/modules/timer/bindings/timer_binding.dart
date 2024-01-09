import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

class TimerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimerController>(
      () => TimerController(),
    );

    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
