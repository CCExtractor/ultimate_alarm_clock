import 'package:get/get.dart';

import '../controllers/alarm_control_ignore_controller.dart';

class AlarmControlIgnoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlIgnoreController>(
      () => AlarmControlIgnoreController(),
    );
  }
}
