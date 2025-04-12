import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SnoozeSettingsController extends GetxController {
  late ThemeController themeController;
  final secureStorage = SecureStorageProvider();
  final snoozeDuration = 5.obs;
  final maxSnoozeCount = 3.obs;
  @override
  void onInit() {
    super.onInit();
    themeController = Get.find<ThemeController>();
    loadSettings();
  }

  void loadSettings() {
    snoozeDuration.value = Utils.alarmModelInit.snoozeDuration;
    maxSnoozeCount.value = Utils.alarmModelInit.maxSnoozeCount;
  }

  void saveSettings() {
    updateDefaultSnoozeSettings();
    Get.back();
  }
  
  void updateDefaultSnoozeSettings() {
    Utils.alarmModelInit.snoozeDuration = snoozeDuration.value;
    Utils.alarmModelInit.maxSnoozeCount = maxSnoozeCount.value;
  }
  
  void incrementValue(RxInt value, int maxLimit) {
    if (value.value < maxLimit) {
      value.value++;
    }
  }
  
  void decrementValue(RxInt value, int minLimit) {
    if (value.value > minLimit) {
      value.value--;
    }
  }
} 