import 'package:get/get.dart';

import '../controllers/update_alarm_controller.dart';

class UpdateAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateAlarmController>(
      () => UpdateAlarmController(),
    );
  }
}
