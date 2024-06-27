import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class ThemeController extends GetxController {
  final _secureStorageProvider = SecureStorageProvider();

  @override
  void onInit() {
    _loadThemeValue();
    super.onInit();
  }

  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  void switchTheme() {
    currentTheme.value = currentTheme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void _loadThemeValue() async {
    currentTheme.value =
        await _secureStorageProvider.readThemeValue() == AppTheme.light
            ? ThemeMode.light
            : ThemeMode.dark;
    Get.changeThemeMode(currentTheme.value);
  }

  void _saveThemeValuePreference() async {
    await _secureStorageProvider.writeThemeValue(
      theme: currentTheme.value == ThemeMode.light
          ? AppTheme.light
          : AppTheme.dark,
    );
  }

  void toggleThemeValue(bool enabled) {
    currentTheme.value = enabled ? ThemeMode.light : ThemeMode.dark;
    _saveThemeValuePreference();
  }
}
