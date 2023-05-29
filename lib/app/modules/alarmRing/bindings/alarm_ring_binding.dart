import 'package:get/get.dart';

import '../controllers/alarm_control_controller.dart';

class AlarmControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmControlController>(
      () => AlarmControlController(),
    );
  }
}
