import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SnoozeSettingsController extends GetxController {
  late ThemeController themeController;
  final secureStorage = SecureStorageProvider();
  
  // Default snooze duration for new alarms
  final snoozeDuration = 5.obs;
  
  // Default max snooze count for new alarms
  final maxSnoozeCount = 3.obs;

  @override
  void onInit() {
    super.onInit();
    themeController = Get.find<ThemeController>();
    
    // Load saved settings or use defaults
    loadSettings();
  }

  void loadSettings() {
    // For now, use the values from Utils.alarmModelInit as defaults
    snoozeDuration.value = Utils.alarmModelInit.snoozeDuration;
    maxSnoozeCount.value = Utils.alarmModelInit.maxSnoozeCount;
  }

  void saveSettings() {
    // Update default values in the application
    updateDefaultSnoozeSettings();
    Get.back();
  }
  
  void updateDefaultSnoozeSettings() {
    // Update the defaults in Utils.alarmModelInit
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