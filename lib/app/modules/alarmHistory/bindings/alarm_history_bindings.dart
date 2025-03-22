import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmHistory/controllers/alarm_history_controller.dart';

class AlarmHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmHistoryController>(
      () => AlarmHistoryController(),
    );
  }
}