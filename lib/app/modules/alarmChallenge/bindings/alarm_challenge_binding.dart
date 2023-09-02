import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';

import '../controllers/alarm_challenge_controller.dart';

class AlarmChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmChallengeController>(
      () => AlarmChallengeController(),
    );
    Get.lazyPut<HapticFeedbackController>(
      () => HapticFeedbackController(),
    );
  }
}
