import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

import '../controllers/alarm_ring_ignore_controller.dart';

class AlarmControlIgnoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlIgnoreController>(
      () => AlarmControlIgnoreController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
