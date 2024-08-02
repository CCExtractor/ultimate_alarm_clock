import 'package:get/get.dart';

import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/splashScreen/controllers/splash_screen_controller.dart';

import '../../home/controllers/home_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(
      ThemeController(),
      permanent: true,
    );
    Get.put<HomeController>(
      HomeController(),permanent: true
    );
    Get.put<SplashScreenController>(
      SplashScreenController(),
    );
  }
}
