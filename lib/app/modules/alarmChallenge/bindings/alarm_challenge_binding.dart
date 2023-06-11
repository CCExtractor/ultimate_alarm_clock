import 'package:get/get.dart';

import '../controllers/alarm_challenge_controller.dart';

class AlarmChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmChallengeController>(
      () => AlarmChallengeController(),
    );
  }
}
