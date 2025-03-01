import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

class TimerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TimerController>(
      TimerController(),
    );


  }
}
