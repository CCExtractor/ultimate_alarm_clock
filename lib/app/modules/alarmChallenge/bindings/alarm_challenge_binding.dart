import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/controllers/alarm_challenge_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';

class AlarmChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmChallengeController>(
      () => AlarmChallengeController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
