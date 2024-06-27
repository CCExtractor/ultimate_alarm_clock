import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SnoozeDurationTile extends StatelessWidget {
  const SnoozeDurationTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int duration;
    return InkWell(
      onTap: () {
        Utils.hapticFeedback();
        // storing the values
        duration = controller.snoozeDuration.value;
        Get.defaultDialog(
          onWillPop: () async {
            Get.back();
            // presetting the value to it's initial state
            controller.snoozeDuration.value = duration;
            return true;
          },
          titlePadding: const EdgeInsets.only(top: 20),
          backgroundColor: themeController.currentTheme.value == ThemeMode.light
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Select duration'.tr,
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NumberPicker(
                        value: controller.snoozeDuration.value,
                        minValue: 1,
                        maxValue: 1440,
                        onChanged: (value) {
                          Utils.hapticFeedback();
                          controller.snoozeDuration.value = value;
                        },
                      ),
                      Text(
                        controller.snoozeDuration.value > 1
                            ? 'minutes'.tr
                            : 'minute'.tr,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Utils.hapticFeedback();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                  ),
                  child: Text(
                    'Done'.tr,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: themeController.currentTheme.value == ThemeMode.light
                              ? kLightPrimaryTextColor
                              : ksecondaryTextColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: ListTile(
        tileColor: themeController.currentTheme.value == ThemeMode.light
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            'Snooze Duration'.tr,
            style: TextStyle(
              color: themeController.currentTheme.value == ThemeMode.light
                  ? kLightPrimaryTextColor
                  : kprimaryTextColor,
            ),
          ),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.snoozeDuration.value > 0
                    ? '${controller.snoozeDuration.value} min'
                    : 'Off'.tr,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.snoozeDuration.value <= 0)
                          ? themeController.currentTheme.value == ThemeMode.light
                              ? kLightPrimaryDisabledTextColor
                              : kprimaryDisabledTextColor
                          : themeController.currentTheme.value == ThemeMode.light
                              ? kLightPrimaryTextColor
                              : kprimaryTextColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: themeController.currentTheme.value == ThemeMode.light
                  ? kLightPrimaryDisabledTextColor
                  : kprimaryDisabledTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
