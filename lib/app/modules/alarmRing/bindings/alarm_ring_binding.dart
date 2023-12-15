import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/bindings/add_or_update_alarm_binding.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';

import '../controllers/alarm_ring_controller.dart';

class AlarmControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlController>(
      () => AlarmControlController(),
    );
    Get.lazyPut<AddOrUpdateAlarmController>(
      () => AddOrUpdateAlarmController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
