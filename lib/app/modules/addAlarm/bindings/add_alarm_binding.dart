import 'package:get/get.dart';

import '../controllers/add_alarm_controller.dart';

class AddAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddAlarmController>(
      AddAlarmController(),
    );
  }
}
