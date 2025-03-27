import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class DeveloperModeTile extends StatelessWidget {
  final double height;
  final double width;
  final SettingsController controller;
  final ThemeController themeController;

  const DeveloperModeTile({
    super.key,
    required this.height,
    required this.width,
    required this.controller,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.91,
      height: height * 0.1,
      decoration: Utils.getCustomTileBoxDecoration(
        isLightMode: themeController.currentTheme.value == ThemeMode.light,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    'Developer Mode'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_sharp,
                      size: 21,
                      color: themeController.primaryTextColor.value.withOpacity(0.3),
                    ),
                    onPressed: () {
                      Utils.hapticFeedback();
                      Utils.showModal(
                        context: context,
                        title: 'Developer Mode'.tr,
                        description: 'Show additional technical information in alarm history'.tr,
                        iconData: Icons.developer_mode,
                        isLightMode: themeController.currentTheme.value == ThemeMode.light,
                      );
                    },
                  ),
                ],
              ),
            ),
            Obx(() => Switch.adaptive(
              value: controller.isDevMode.value,
              activeColor: ksecondaryColor,
              onChanged: (value) {
                Utils.hapticFeedback();
                controller.toggleDevMode(value);
              },
            )),
          ],
        ),
      ),
    );
  }
} 