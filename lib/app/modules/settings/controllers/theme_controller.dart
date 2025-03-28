import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:dynamic_color/dynamic_color.dart';

class ThemeController extends GetxController {
  final _secureStorageProvider = SecureStorageProvider();
  
  // Dynamic color schemes
  Rx<ColorScheme?> lightDynamicScheme = Rx<ColorScheme?>(null);
  Rx<ColorScheme?> darkDynamicScheme = Rx<ColorScheme?>(null);
  
  // Current theme mode
  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;
  
  // Observable theme colors
  Rx<Color> primaryColor = kprimaryColor.obs;
  Rx<Color> secondaryColor = kLightSecondaryColor.obs;
  Rx<Color> primaryBackgroundColor = kLightPrimaryBackgroundColor.obs;
  Rx<Color> secondaryBackgroundColor = kLightSecondaryBackgroundColor.obs;
  Rx<Color> primaryTextColor = kLightPrimaryTextColor.obs;
  Rx<Color> secondaryTextColor = kLightSecondaryTextColor.obs;
  Rx<Color> primaryDisabledTextColor = kLightPrimaryDisabledTextColor.obs;

  /// Toggle theme based on theme mode

  void toggleTheme(ThemeMode themeMode) {
    currentTheme.value = themeMode;
    update(); // Notify GetX to rebuild UI
  }

  @override
  void onInit() {
    _loadThemeValue();
    _initializeDynamicColors();
    super.onInit();
  }

  /// Initialize dynamic colors based on device theme
  void _initializeDynamicColors() async {
    // Get dynamic color schemes if available
    final dynamicColors = await DynamicColorPlugin.getCorePalette();
    
    if (dynamicColors != null) {
      // Create light and dark schemes from dynamic colors
      lightDynamicScheme.value = ColorScheme.fromSeed(
        seedColor: Color(dynamicColors.primary.get(50)),
        brightness: Brightness.light,
      ).harmonized();
      
      darkDynamicScheme.value = ColorScheme.fromSeed(
        seedColor: Color(dynamicColors.primary.get(50)),
        brightness: Brightness.dark,
      ).harmonized();
    }
    
    // Update theme colors after dynamic colors are loaded
    updateThemeColors();
  }

  /// Switch between light and dark theme
  void switchTheme() {
    currentTheme.value = currentTheme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    updateThemeColors();
    _saveThemeValuePreference();
    Get.changeThemeMode(currentTheme.value);
  }

  /// Update theme colors based on current theme mode and dynamic colors
  void updateThemeColors() {
    final ColorScheme? activeScheme = currentTheme.value == ThemeMode.light
        ? lightDynamicScheme.value
        : darkDynamicScheme.value;

    if (activeScheme != null) {
      // Use dynamic colors if available
      bool isDarkTheme = activeScheme.brightness == Brightness.dark;
      primaryColor.value = activeScheme.primary;
      secondaryColor.value = activeScheme.secondary;
      primaryBackgroundColor.value = activeScheme.surface;
      secondaryBackgroundColor.value = activeScheme.surfaceVariant;
      primaryTextColor.value = activeScheme.onSurface;
      secondaryTextColor.value = isDarkTheme ? Colors.black87 : Colors.white70;
      primaryDisabledTextColor.value = activeScheme.onSurface.withOpacity(0.38);
    } else {
      // Fall back to predefined colors
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
        secondaryColor.value = getSecondaryColorTheme();
        primaryBackgroundColor.value = kprimaryBackgroundColor;
        secondaryBackgroundColor.value = ksecondaryBackgroundColor;
        primaryTextColor.value = kprimaryTextColor;
        secondaryTextColor.value = ksecondaryTextColor;
        primaryDisabledTextColor.value = kprimaryDisabledTextColor;
      }
    }
  }

  /// Load saved theme from secure storage
  void _loadThemeValue() async {
    currentTheme.value =
        await _secureStorageProvider.readThemeValue() == AppTheme.light
            ? ThemeMode.light
            : ThemeMode.dark;
           
    updateThemeColors();
    Get.changeThemeMode(currentTheme.value);
  }

  /// Save theme value to secure storage
  void _saveThemeValuePreference() async {
    await _secureStorageProvider.writeThemeValue(
      theme: currentTheme.value == ThemeMode.light
          ? AppTheme.light
          : AppTheme.dark,
    );
  }

  /// Toggle theme based on switch value
  void toggleThemeValue(bool enabled) {
    currentTheme.value = enabled ? ThemeMode.light : ThemeMode.dark;
    updateThemeColors();
    _saveThemeValuePreference();
    Get.changeThemeMode(currentTheme.value);
  }
  
  /// Get current theme data based on dynamic colors or fallback
  ThemeData getThemeData({required bool isLight}) {
    final ColorScheme? scheme = isLight ? lightDynamicScheme.value : darkDynamicScheme.value;
    
    if (scheme != null) {
      return isLight ? _createLightTheme(scheme) : _createDarkTheme(scheme);
    } else {
      return isLight ? kLightThemeData : kThemeData;
    }
  }
  
  /// Create light theme based on color scheme
  ThemeData _createLightTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'poppins',
      // Add other theme properties as needed
    );
  }
  
  /// Create dark theme based on color scheme
  ThemeData _createDarkTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'poppins',
      // Add other theme properties as needed
    );
  }
}