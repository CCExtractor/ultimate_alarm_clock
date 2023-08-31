import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';

import '../controllers/alarm_challenge_controller.dart';

class AlarmChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmChallengeController>(
      () => AlarmChallengeController(),
    );
    Get.put<HapticFeebackService>(
      HapticFeebackService(),
    );
  }
}
