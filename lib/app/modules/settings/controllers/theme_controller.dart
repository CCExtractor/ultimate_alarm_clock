import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class ThemeController extends GetxController {
  var isLightMode = true.obs;
  final _secureStorageProvider = SecureStorageProvider();

  @override
  void onInit() {
    _loadThemeValue();
    super.onInit();
  }

  void _loadThemeValue() async {
    isLightMode.value =
        await _secureStorageProvider.readThemeValue() == AppTheme.light;
    Get.changeThemeMode(isLightMode.value ? ThemeMode.light : ThemeMode.dark);
  }

  void _saveThemeValuePreference() async {
    await _secureStorageProvider.writeThemeValue(
        theme: isLightMode.value ? AppTheme.light : AppTheme.dark,);
  }

  void toggleThemeValue(bool enabled) {
    isLightMode.value = enabled;
    _saveThemeValuePreference();
  }
}
