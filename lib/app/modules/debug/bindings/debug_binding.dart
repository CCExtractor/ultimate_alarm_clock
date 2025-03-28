import 'package:get/get.dart';
import '../controllers/debug_controller.dart';

class DebugBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DebugController>(
      () => DebugController(),
    );
  }
}