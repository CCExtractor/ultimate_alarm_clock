import 'package:get/get.dart';
import '../controllers/snooze_settings_controller.dart';

class SnoozeSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnoozeSettingsController>(
      () => SnoozeSettingsController(),
    );
  }
} 