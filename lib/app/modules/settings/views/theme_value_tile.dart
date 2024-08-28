import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ThemeValueTile extends StatefulWidget {
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

  @override
  State<ThemeValueTile> createState() => _ThemeValueTileState();
}

class _ThemeValueTileState extends State<ThemeValueTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: widget.width * 0.91,
        height: widget.height * 0.1,
        decoration: Utils.getCustomTileBoxDecoration(
          isLightMode:
              widget.themeController.currentTheme.value == ThemeMode.light,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Enable Light Mode'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Obx(
                () => Switch.adaptive(
                  value: widget.themeController.currentTheme.value ==
                      ThemeMode.light,
                  activeColor: ksecondaryColor,
                  onChanged: (bool value) async {
                    widget.themeController.toggleThemeValue(value);
                    Get.changeThemeMode(
                      widget.themeController.currentTheme.value,
                    );
                    Utils.hapticFeedback();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
