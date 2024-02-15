import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class ThemeController extends GetxController {
  var isLightMode = true.obs;
  final _secureStorageProvider = SecureStorageProvider();

  late Timer _brightnessCheckTimer;

  @override
  void onInit() {
    _loadThemeValue();
    _startBrightnessCheckTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _brightnessCheckTimer.cancel();
    super.onClose();
  }

  void _loadThemeValue() async {
    final storedTheme = await _secureStorageProvider.readThemeValue();
  final systemBrightness = Get.mediaQuery.platformBrightness;

  if (storedTheme == AppTheme.system) {
    if (systemBrightness == Brightness.light) {
      isLightMode.value = true;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      isLightMode.value = false;
      Get.changeThemeMode(ThemeMode.dark);
    }
  } else {
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
    final systemBrightness = Get.mediaQuery.platformBrightness;

    if (systemBrightness == Brightness.light) {
      isLightMode.value = true;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      isLightMode.value = false;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  void _saveThemeValuePreference() async {
    await _secureStorageProvider.writeThemeValue(
      theme: isLightMode.value ? AppTheme.light : AppTheme.dark,
    );
  }

  void toggleThemeValue(bool enabled) {
    isLightMode.value = enabled;
    _saveThemeValuePreference();
  }

  void toggleSystemTheme() {
    final systemBrightness = Get.mediaQuery.platformBrightness;
  print("System Brightness: $systemBrightness");
  _saveThemeValuePreference();

  if (systemBrightness == Brightness.light) {
    isLightMode.value = true;
    Get.changeThemeMode(ThemeMode.light);
  } else {isLightMode.value = false;
    Get.changeThemeMode(ThemeMode.dark);
  }
    _saveThemeValuePreference();
    _updateThemeFromSystemBrightness();
  }
}
