import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controllers/stopwatch_controller.dart';

class StopwatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StopwatchController>(
      StopwatchController(),
    );
  }
}
