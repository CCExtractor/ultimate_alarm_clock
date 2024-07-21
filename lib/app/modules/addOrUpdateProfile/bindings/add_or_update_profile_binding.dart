import 'package:get/get.dart';

import '../controllers/add_or_update_profile_controller.dart';

class AddOrUpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddOrUpdateProfileController>(
      () => AddOrUpdateProfileController(),
    );
  }
}
