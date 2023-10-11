import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class RepeatTile extends StatelessWidget {
  const RepeatTile({
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
          title: 'Repeat',
          titleStyle: TextStyle(
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
          ),
          content: Obx(
            () => Column(
              children: [
                dayTile(dayIndex: 0, dayName: 'Monday', context: context),
                dayTile(dayIndex: 1, dayName: 'Tuesday', context: context),
                dayTile(dayIndex: 2, dayName: 'Wednesday', context: context),
                dayTile(dayIndex: 3, dayName: 'Thursday', context: context),
                dayTile(dayIndex: 4, dayName: 'Friday', context: context),
                dayTile(dayIndex: 5, dayName: 'Saturday', context: context),
                dayTile(dayIndex: 6, dayName: 'Sunday', context: context),
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
                            backgroundColor: kprimaryColor,
                            // Set the desired background color
                          ),
                          child: Text(
                            'Done',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryTextColor
                                      : ksecondaryTextColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: ListTile(
        tileColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: Text(
          'Repeat',
          style: TextStyle(
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.daysRepeating.value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: themeController.isLightMode.value
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

  Widget dayTile({
    required int dayIndex,
    required String dayName,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        Utils.hapticFeedback();
        controller.repeatDays[dayIndex] = !controller.repeatDays[dayIndex];
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox.adaptive(
              side: BorderSide(
                width: 1.5,
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.5)
                    : kprimaryTextColor.withOpacity(0.5),
              ),
              activeColor: kprimaryColor.withOpacity(0.8),
              value: controller.repeatDays[dayIndex],
              onChanged: (value) {
                Utils.hapticFeedback();
                controller.repeatDays[dayIndex] =
                    !controller.repeatDays[dayIndex];
              },
            ),
            Text(
              dayName,
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
