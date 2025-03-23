import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/citySelection/controllers/city_selection_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CitySelectionController>(
      CitySelectionController(),
    );

    
    Get.lazyPut<BottomNavigationBarController>(
      () => BottomNavigationBarController(),
    );
  }
}
