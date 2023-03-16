import 'package:get/get.dart';

import '../controllers/add_alarm_controller.dart';

class AddAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAlarmController>(
      () => AddAlarmController(),
    );
  }
}
