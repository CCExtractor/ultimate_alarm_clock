import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/about_view.dart';

class AboutController extends GetxController {
  final RxBool isAboutExpanded = true.obs;

  void toggleAboutExpansion() {
    isAboutExpanded.value = !isAboutExpanded.value;
  }

  void navigateToAboutView() {
    Get.to(() => AboutView());
  }
}
