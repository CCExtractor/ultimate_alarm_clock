import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/word_builder/controllers/word_builder_controller.dart';

class WordBuilderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordBuilderController>(
      () => WordBuilderController(),
    );
  }
} 