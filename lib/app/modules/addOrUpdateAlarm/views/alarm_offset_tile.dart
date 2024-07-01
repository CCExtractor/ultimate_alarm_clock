import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmOffset extends StatelessWidget {
  const AlarmOffset({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.isSharedAlarmEnabled.value)
          ? InkWell(
              onTap: () {
                Utils.hapticFeedback();
                Get.defaultDialog(
                  titlePadding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: themeController.currentTheme.value == ThemeMode.light
                      ? kLightSecondaryBackgroundColor
                      : ksecondaryBackgroundColor,
                  title: 'Choose duration'.tr,
                  titleStyle: Theme.of(context).textTheme.displaySmall,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NumberPicker(
                              value: controller.offsetDuration.value,
                              minValue: 0,
                              maxValue: 1440,
                              onChanged: (value) {
                                Utils.hapticFeedback();
                                controller.offsetDuration.value = value;
                              },
                            ),
                            Text(
                              controller.offsetDuration.value > 1
                                  ? 'minutes'.tr
                                  : 'minute'.tr,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                Utils.hapticFeedback();
                                controller.isOffsetBefore.value = true;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (controller
                                        .isOffsetBefore.value)
                                    ? kprimaryColor
                                    : themeController.currentTheme.value == ThemeMode.light
                                        ? kLightPrimaryTextColor
                                            .withOpacity(0.10)
                                        : kprimaryTextColor.withOpacity(0.08),
                                foregroundColor:
                                    (controller.isOffsetBefore.value)
                                        ? themeController.currentTheme.value == ThemeMode.light
                                            ? kLightSecondaryTextColor
                                            : ksecondaryTextColor
                                        : themeController.currentTheme.value == ThemeMode.light
                                            ? kLightPrimaryTextColor
                                            : kprimaryTextColor,
                              ),
                              child:  Text(
                                'Before'.tr,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                Utils.hapticFeedback();
                                controller.isOffsetBefore.value = false;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (!controller
                                        .isOffsetBefore.value)
                                    ? kprimaryColor
                                    : themeController.currentTheme.value == ThemeMode.light
                                        ? kLightPrimaryTextColor
                                            .withOpacity(0.10)
                                        : kprimaryTextColor.withOpacity(0.08),
                                foregroundColor:
                                    (!controller.isOffsetBefore.value)
                                        ? themeController.currentTheme.value == ThemeMode.light
                                            ? kLightSecondaryTextColor
                                            : ksecondaryTextColor
                                        : themeController.currentTheme.value == ThemeMode.light
                                            ? kLightPrimaryTextColor
                                            : kprimaryTextColor,
                              ),
                              child:  Text(
                                'After'.tr,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: ListTile(
                title:  Text('Ring before / after '.tr),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        controller.offsetDuration.value > 0 ? 'Enabled'.tr : 'Off'.tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: (controller.offsetDuration.value > 0)
                                  ? themeController.currentTheme.value == ThemeMode.light
                                      ? kLightPrimaryTextColor
                                      : kprimaryTextColor
                                  : themeController.currentTheme.value == ThemeMode.light
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
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
            )
          : const SizedBox(),
    );
  }
}
