import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';

import '../controllers/alarm_ring_ignore_controller.dart';

class AlarmControlIgnoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlIgnoreController>(
      () => AlarmControlIgnoreController(),
    );
    Get.lazyPut<HapticFeedbackController>(
      () => HapticFeedbackController(),
    );
  }
}
