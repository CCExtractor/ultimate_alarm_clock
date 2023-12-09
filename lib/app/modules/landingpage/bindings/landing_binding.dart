import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/landingpage/controller/landing_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class LandingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LandingPageController>(
      LandingPageController(),
    );

    Get.put<HomeController>(
      HomeController(),
    );
    Get.put<ThemeController>(
      ThemeController(),
    );
  }
}
