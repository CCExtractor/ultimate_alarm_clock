import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/repeat_once_tile.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../settings/controllers/theme_controller.dart';
import '../controllers/add_or_update_alarm_controller.dart';

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
    List<bool> repeatDays = List<bool>.filled(7, false);
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          BottomSheet(
            onClosing: () async {
              _storeOrPreset(controller.repeatDays, repeatDays);
            },
            backgroundColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            builder: (BuildContext context) {
              return Column(
                children: [
                  buildDailyTile(
                    controller: controller,
                    themeController: themeController,
                  ),
                  buildWeekdaysTile(
                      controller: controller, themeController: themeController),
                  RepeatOnceTile(
                    controller: controller,
                    themeController: themeController,
                  ),
                ],
              );
            },
          ),
        );
      },
      child: ListTile(
        tileColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: Obx(
          () {
            bool anyDaySelected =
                controller.repeatDays.any((daySelected) => daySelected);
            return Text(
              'Repeat'.tr,
              style: TextStyle(
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor
                    : kprimaryTextColor,
                fontWeight:
                    anyDaySelected ? FontWeight.w500 : FontWeight.normal,
              ),
            );
          },
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.daysRepeating.value.tr,
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

  void _storeOrPreset(List<bool> toSet, List<bool> toUse) {
    for (var i = 0; i < toUse.length; i++) {
      toSet[i] = toUse[i];
    }
  }

  ListTile buildDailyTile({
    required AddOrUpdateAlarmController controller,
    required ThemeController themeController,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10.0),
      title: Obx(
        () => InkWell(
          onTap: () {
            Utils.hapticFeedback();
            controller.setIsDailySelected(!controller.isDailySelected.value);

            // Update repeatDays based on isDailySelected value
            for (int i = 0; i < controller.repeatDays.length; i++) {
              controller.repeatDays[i] = controller.isDailySelected.value;
            }
          },
          child: Padding(
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Daily',
                ),
                Checkbox.adaptive(
                  side: BorderSide(
                    width: 1.5,
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor.withOpacity(0.5)
                        : kprimaryTextColor.withOpacity(0.5),
                  ),
                  activeColor: kprimaryColor.withOpacity(0.8),
                  value: controller.isDailySelected.value,
                  onChanged: (value) {
                    // This onChanged can be empty, as we handle the tap in InkWell
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildCustomDaysTile({
    required AddOrUpdateAlarmController controller,
    required ThemeController themeController,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10.0),
      title: Obx(
        () => InkWell(
          onTap: () {
            Utils.hapticFeedback();
            controller.setIsCustomSelected(!controller.isCustomSelected.value);
            
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Custom'),
                Checkbox.adaptive(
                  side: BorderSide(
                    width: 1.5,
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor.withOpacity(0.5)
                        : kprimaryTextColor.withOpacity(0.5),
                  ),
                  activeColor: kprimaryColor.withOpacity(0.8),
                  value: controller.isDailySelected.value,
                  onChanged: (value) {
                    // This onChanged can be empty, as we handle the tap in InkWell
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildWeekdaysTile({
    required AddOrUpdateAlarmController controller,
    required ThemeController themeController,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10.0),
      title: Obx(
        () => InkWell(
          onTap: () {
            Utils.hapticFeedback();
            controller
                .setIsWeekdaysSelected(!controller.isWeekdaysSelected.value);

            // Update repeatDays based on isWeekdaysSelected value
            for (int i = 0; i < controller.repeatDays.length; i++) {
              // Assuming weekdays are from Monday to Friday (index 0 to 5)
              controller.repeatDays[i] =
                  controller.isWeekdaysSelected.value && i >= 0 && i < 5;
            }
          },
          child: Padding(
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Weekdays',
                ),
                Checkbox.adaptive(
                  side: BorderSide(
                    width: 1.5,
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor.withOpacity(0.5)
                        : kprimaryTextColor.withOpacity(0.5),
                  ),
                  activeColor: kprimaryColor.withOpacity(0.8),
                  value: controller.isWeekdaysSelected.value,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.setIsWeekdaysSelected(
                        !controller.isWeekdaysSelected.value);

                    // Update repeatDays based on isWeekdaysSelected value
                    for (int i = 0; i < controller.repeatDays.length; i++) {
                      // Assuming weekdays are from Monday to Friday (index 1 to 5)
                      controller.repeatDays[i] =
                          controller.isWeekdaysSelected.value &&
                              i >= 1 &&
                              i <= 5;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
