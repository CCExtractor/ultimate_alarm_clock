import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';

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
    Get.lazyPut<HapticFeedbackController>(
      () => HapticFeedbackController(),
    );
  }
}
