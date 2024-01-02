import 'package:get/get.dart';

import '../controllers/language_controller.dart';

class LanguageBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(LanguageController());
  }
}
