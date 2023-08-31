import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';

import '../controllers/alarm_ring_ignore_controller.dart';

class AlarmControlIgnoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlIgnoreController>(
      () => AlarmControlIgnoreController(),
    );
    Get.put<HapticFeebackService>(
      HapticFeebackService(),
    );
  }
}
