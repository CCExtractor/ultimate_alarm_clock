import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ThemeValueTile extends StatelessWidget {
  const ThemeValueTile({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final SettingsController controller;
  final ThemeController themeController;

  final double height;
  final double width;

  final themes = const <MapEntry>[MapEntry('dark', 'Dark Theme'),
    MapEntry('light', 'Light Theme'),
    MapEntry('system', 'System Theme'),];

  @override
  Widget build(BuildContext context) {
    ThemeMode theme = themeController.currentTheme.value;
    return Obx(
      () => Container(
        width: width * 0.91,
        height: height * 0.1,
        decoration: Utils.getCustomTileBoxDecoration(
          isLightMode:
              themeController.currentTheme.value == ThemeMode.light,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 20),
          child: Obx(
                () => DropdownMenu(
              menuStyle: MenuStyle(
                backgroundColor: MaterialStatePropertyAll(
                  themeController.secondaryBackgroundColor.value,
                ),
              ),
              inputDecorationTheme:
              const InputDecorationTheme(enabledBorder: InputBorder.none),
              trailingIcon: Icon(
                Icons.arrow_drop_down_outlined,
                size: 40.0,
                color: themeController.primaryTextColor.value
                    .withOpacity(0.8),
              ),
              width: width * 0.78,
              initialSelection: themeController.isSystemTheme ? themes[2].key
                  : theme == ThemeMode.dark ? themes[0].key
                  : themes[1].key,
              label: const Text('Select Theme'),
              dropdownMenuEntries: themes.map((e) {
                return DropdownMenuEntry(
                  value: e.key,
                  label: e.value,
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                      themeController.primaryTextColor.value,
                    ),
                  ),
                );
              }).toList(),
              onSelected: (newValue) {
                if (newValue == themes[0].key) {
                  themeController.toggleThemeValue(ThemeMode.dark);
                } else if (newValue == themes[1].key) {
                  themeController.toggleThemeValue(ThemeMode.light);
                } else {
                  themeController.toggleThemeValue(ThemeMode.system);
                }
                Utils.hapticFeedback();
              },
            ),
          ),
        ),
      ),
    );
  }
}
