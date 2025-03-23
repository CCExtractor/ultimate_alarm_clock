import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import '../controllers/settings_controller.dart';
import '../controllers/theme_controller.dart';

class TimeLimitView extends StatelessWidget {
  const TimeLimitView({
    super.key,
    required this.controller,
    required this.themeController,
    required this.width,
    required this.height,
  });

  final SettingsController controller;
  final ThemeController themeController;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    int initialTimeLimit;
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          initialTimeLimit = controller.challengeTimeLimit.value;
          Get.defaultDialog(
            onWillPop: () async {
              Get.back();
              controller.challengeTimeLimit.value = initialTimeLimit;
              return true;
            },
            titlePadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Customize Challenge Timer'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Column(
                children: [
                  Text(
                    '${controller.challengeTimeLimit.value} seconds'.tr,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Slider(
                    value: controller.challengeTimeLimit.value.toDouble(),
                    onChanged: (double newValue) {
                      controller.challengeTimeLimit.value = newValue.toInt();
                    },
                    min: 5.0,
                    max: 60.0,
                    divisions: 55,
                    label: controller.challengeTimeLimit.value.toString(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // controller.saveSettings();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                    ),
                    child: Text(
                      'Apply Time Limit'.tr,
                      style: TextStyle(
                        color: themeController.secondaryTextColor.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          width: width * 0.91,
          height: height * 0.09,
          decoration: Utils.getCustomTileBoxDecoration(
            isLightMode: themeController.currentTheme.value == ThemeMode.light,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                tileColor: themeController.secondaryBackgroundColor.value,
                title: Text(
                  'Challenge Timer Limit'.tr,
                  style: TextStyle(
                    color: themeController.primaryTextColor.value,
                    fontSize: 15,
                  ),
                ),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        '${controller.challengeTimeLimit.value.round()} seconds',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: themeController.primaryTextColor.value,
                              fontSize: 13,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: themeController.primaryDisabledTextColor.value,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
