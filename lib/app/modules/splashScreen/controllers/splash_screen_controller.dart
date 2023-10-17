import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), () {
      Get.offNamed('/home');
    });
    super.onInit();
  }
}
