import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';

import '../controllers/alarm_ring_controller.dart';

class AlarmControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlController>(
      () => AlarmControlController(),
    );
    Get.put<HapticFeebackService>(
      HapticFeebackService(),
    );
  }
}
