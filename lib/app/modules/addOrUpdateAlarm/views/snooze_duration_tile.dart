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
    return InkWell(
      onTap: () {
        Utils.hapticFeedback();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Select duration',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(() => Column(
                children: [
                  Row(
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
                            ? 'minutes'
                            : 'minute',
                      ),
                    ],
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kprimaryColor,),
                            child: Text(
                              'Done',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryTextColor
                                          : ksecondaryTextColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),),
        );
      },
      child: ListTile(
        tileColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: Text(
          'Snooze Duration',
          style: TextStyle(
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor
                  : kprimaryTextColor,),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.snoozeDuration.value > 0
                    ? '${controller.snoozeDuration.value} min'
                    : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.snoozeDuration.value <= 0)
                          ? themeController.isLightMode.value
                              ? kLightPrimaryDisabledTextColor
                              : kprimaryDisabledTextColor
                          : themeController.isLightMode.value
                              ? kLightPrimaryTextColor
                              : kprimaryTextColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: themeController.isLightMode.value
                  ? kLightPrimaryDisabledTextColor
                  : kprimaryDisabledTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
