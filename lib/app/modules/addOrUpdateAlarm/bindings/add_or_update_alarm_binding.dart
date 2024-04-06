import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/alarm_input_time_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import '../controllers/add_or_update_alarm_controller.dart';

class AddOrUpdateAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddOrUpdateAlarmController>(
      AddOrUpdateAlarmController(),
    );
    Get.put<HomeController>(
      HomeController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<AlarmInputTimeController>(
      () => AlarmInputTimeController(),
    );
    Get.lazyPut<BottomNavigationBarController>(
      () => BottomNavigationBarController(),
    );
  }
}
