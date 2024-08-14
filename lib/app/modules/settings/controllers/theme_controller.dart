import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class ThemeController extends GetxController {
  final _secureStorageProvider = SecureStorageProvider();

  @override
  void onInit() {
    _loadThemeValue();
    updateThemeColors();
    super.onInit();
  }

  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  void switchTheme() {
    currentTheme.value = currentTheme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    updateThemeColors();
  }

  Rx<Color> primaryColor = kprimaryColor.obs;
  Rx<Color> secondaryColor = kLightSecondaryColor.obs;
  Rx<Color> primaryBackgroundColor = kLightPrimaryBackgroundColor.obs;
  Rx<Color> secondaryBackgroundColor = kLightSecondaryBackgroundColor.obs;
  Rx<Color> primaryTextColor = kLightPrimaryTextColor.obs;
  Rx<Color> secondaryTextColor = kLightSecondaryTextColor.obs;
  Rx<Color> primaryDisabledTextColor = kLightPrimaryDisabledTextColor.obs;

  void updateThemeColors() {
    primaryColor.value =
    currentTheme.value == ThemeMode.light ? kprimaryColor : kprimaryColor;
    secondaryColor.value = currentTheme.value == ThemeMode.light
        ? kLightSecondaryColor
        : ksecondaryColor;
    primaryBackgroundColor.value = currentTheme.value == ThemeMode.light
        ? kLightPrimaryBackgroundColor
        : kprimaryBackgroundColor;
    secondaryBackgroundColor.value = currentTheme.value == ThemeMode.light
        ? kLightSecondaryBackgroundColor
        : ksecondaryBackgroundColor;
    primaryTextColor.value = currentTheme.value == ThemeMode.light
        ? kLightPrimaryTextColor
        : kprimaryTextColor;
    secondaryTextColor.value = currentTheme.value == ThemeMode.light
        ? kLightSecondaryTextColor
        : ksecondaryTextColor;
    primaryDisabledTextColor.value = currentTheme.value == ThemeMode.light
        ? kLightPrimaryDisabledTextColor
        : kprimaryDisabledTextColor;
  }

  void _loadThemeValue() async {
    currentTheme.value =
        await _secureStorageProvider.readThemeValue() == AppTheme.light
            ? ThemeMode.light
            : ThemeMode.dark;
    updateThemeColors();
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
    updateThemeColors();
    _saveThemeValuePreference();
  }
}
