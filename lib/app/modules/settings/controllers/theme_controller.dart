import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class ThemeController extends GetxController {
  final _secureStorageProvider = SecureStorageProvider();
  Brightness platformBrightness = Brightness.dark;
  bool isSystemTheme = false;

  @override
  void onInit() {
    _loadThemeValue();
    super.onInit();
  }

  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  Rx<Color> primaryColor = kprimaryColor.obs;
  Rx<Color> secondaryColor = kLightSecondaryColor.obs;
  Rx<Color> primaryBackgroundColor = kLightPrimaryBackgroundColor.obs;
  Rx<Color> secondaryBackgroundColor = kLightSecondaryBackgroundColor.obs;
  Rx<Color> primaryTextColor = kLightPrimaryTextColor.obs;
  Rx<Color> secondaryTextColor = kLightSecondaryTextColor.obs;
  Rx<Color> primaryDisabledTextColor = kLightPrimaryDisabledTextColor.obs;

  void updateThemeColors() {
    if (currentTheme.value == ThemeMode.light) {
      primaryColor.value = kprimaryColor;
      secondaryColor.value = kLightSecondaryColor;
      primaryBackgroundColor.value = kLightPrimaryBackgroundColor;
      secondaryBackgroundColor.value = kLightSecondaryBackgroundColor;
      primaryTextColor.value = kLightPrimaryTextColor;
      secondaryTextColor.value = kLightSecondaryTextColor;
      primaryDisabledTextColor.value = kLightPrimaryDisabledTextColor;
    } else {
      primaryColor.value = kprimaryColor;
      secondaryColor.value = ksecondaryColor;
      primaryBackgroundColor.value = kprimaryBackgroundColor;
      secondaryBackgroundColor.value = ksecondaryBackgroundColor;
      primaryTextColor.value = kprimaryTextColor;
      secondaryTextColor.value = ksecondaryTextColor;
      primaryDisabledTextColor.value = kprimaryDisabledTextColor;
    }
  }

  void _loadThemeValue() async {
    AppTheme theme = await _secureStorageProvider.readThemeValue();
    currentTheme.value = getCurrentTheme(theme == AppTheme.light ? ThemeMode.light
        : theme == AppTheme.dark ? ThemeMode.dark
        : ThemeMode.system,
    );
    updateThemeColors();
    Get.changeThemeMode(currentTheme.value);
  }

  void _saveThemeValuePreference() async {
    await _secureStorageProvider.writeThemeValue(
      theme: isSystemTheme ? AppTheme.system
          : currentTheme.value == ThemeMode.light ? AppTheme.light
          : AppTheme.dark,
    );
  }

  void toggleThemeValue(ThemeMode mode) {
    currentTheme.value = getCurrentTheme(mode);
    updateThemeColors();
    _saveThemeValuePreference();
    Get.changeThemeMode(currentTheme.value);
  }

  getCurrentTheme(ThemeMode mode){
    ThemeMode theme;
    if (mode == ThemeMode.system){
      isSystemTheme = true;
      platformBrightness = Get.mediaQuery.platformBrightness;
      theme = platformBrightness == Brightness.light ? ThemeMode.light
          : ThemeMode.dark;
    }else{
      isSystemTheme = false;
      theme = mode;
    }
    return theme;
  }
}
