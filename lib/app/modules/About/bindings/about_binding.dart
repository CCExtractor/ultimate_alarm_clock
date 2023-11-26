import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/about/controller/about_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class AboutBinding extends Bindings {
  @override
  void dependencies() {
     Get.put<AboutController>(
      AboutController(),
    );
    Get.put<ThemeController>(
      ThemeController(),
    );
  }
}
