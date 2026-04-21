import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/pomodoro_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

class TimerBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TimerController>()) {
      Get.put<TimerController>(
        TimerController(),
      );
    }
    if (!Get.isRegistered<PomodoroController>()) {
      Get.put<PomodoroController>(
        PomodoroController(),
      );
    }
  }
}
