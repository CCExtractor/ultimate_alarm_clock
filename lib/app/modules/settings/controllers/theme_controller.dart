import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'dart:developer' as dev;

class ThemeController extends GetxController {
  var isLightMode = true.obs;
  final _secureStorageProvider = SecureStorageProvider();

  late Timer _brightnessCheckTimer;
  bool isSystemModeActive = false;

  @override
  void onInit() {
    _loadThemeValue();
    super.onInit();
  }

  @override
  void onClose() {
    // _brightnessCheckTimer.cancel();
    super.onClose();
  }

  void _loadThemeValue() async {
    final storedTheme = await _secureStorageProvider.readThemeValue();
    dev.log(storedTheme.toString());
    if (storedTheme == AppTheme.system) {
      _startBrightnessCheckTimer();
      final systemBrightness = Get.mediaQuery.platformBrightness;
      isSystemModeActive = true;
      if (systemBrightness == Brightness.light) {
        isLightMode.value = true;
        Get.changeThemeMode(ThemeMode.light);
        onClose();
      } else {
        isLightMode.value = false;
        Get.changeThemeMode(ThemeMode.dark);
        onClose();
      }
    } else {
      onClose();
      isLightMode.value = storedTheme == AppTheme.light;
      Get.changeThemeMode(isLightMode.value ? ThemeMode.light : ThemeMode.dark);
    }
  }

  void _startBrightnessCheckTimer() {
    _brightnessCheckTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _updateThemeFromSystemBrightness();
    });
  }

  void _updateThemeFromSystemBrightness() {
    if (isSystemModeActive) {
      final systemBrightness = Get.mediaQuery.platformBrightness;

      if (systemBrightness == Brightness.light) {
        isLightMode.value = true;
        Get.changeThemeMode(ThemeMode.light);
      } else {
        isLightMode.value = false;
        Get.changeThemeMode(ThemeMode.dark);
      }
    }
  }

  void _saveThemeValuePreference({required AppTheme theme}) async {
    await _secureStorageProvider.writeThemeValue(theme: theme);
  }

  void toggleThemeValue(bool enabled) {
    isSystemModeActive = false;
    isLightMode.value = enabled;
    _saveThemeValuePreference(
        theme: isLightMode.value ? AppTheme.light : AppTheme.dark);
    onClose();
  }

  void toggleSystemTheme() {
    isSystemModeActive = true;
    _startBrightnessCheckTimer();
    final systemBrightness = Get.mediaQuery.platformBrightness;
    print("System Brightness: $systemBrightness");

    Get.changeThemeMode(ThemeMode.system);
    _saveThemeValuePreference(theme: AppTheme.system);

    if (systemBrightness == Brightness.light) {
      isLightMode.value = true;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      isLightMode.value = false;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }
}
