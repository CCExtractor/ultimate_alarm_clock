import 'package:get/get.dart';

import '../controllers/add_or_update_alarm_controller.dart';

class AddOrUpdateAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddOrUpdateAlarmController>(
      AddOrUpdateAlarmController(),
    );
  }
}
