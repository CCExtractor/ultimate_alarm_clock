import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';

import '../controllers/alarm_ring_controller.dart';

class AlarmControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlController>(
      () => AlarmControlController(),
    );
    Get.lazyPut<HapticFeedbackController>(
      () => HapticFeedbackController(),
    );
  }
}
