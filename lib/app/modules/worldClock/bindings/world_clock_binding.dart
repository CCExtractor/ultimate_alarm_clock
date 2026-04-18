import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/worldClock/controllers/world_clock_controller.dart';

class WorldClockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorldClockController>(() => WorldClockController());
  }
}
