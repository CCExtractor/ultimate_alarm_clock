import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // ignore: unused_local_variable
    var height = Get.height;
    var width = Get.width;

    return Obx(
      () => InkWell(
        onTap: () {
          Get.bottomSheet(
            BottomSheet(
              onClosing: () async {
                _storeOrPreset(controller.repeatDays, repeatDays);
              },
              backgroundColor: themeController.secondaryBackgroundColor.value,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildDailyTile(),
                      Container(
                        color: themeController.secondaryBackgroundColor.value,
                        child: Divider(
                          color: themeController.primaryDisabledTextColor.value,
                        ),
                      ),
                      buildWeekdaysTile(),
                      Container(
                        color: themeController.secondaryBackgroundColor.value,
                        child: Divider(
                          color: themeController.primaryDisabledTextColor.value,
                        ),
                      ),
                      buildCustomDaysTile(
                        context: context,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 25),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                kprimaryColor,
                              ),
                            ),
                            onPressed: () {
                              Utils.hapticFeedback();
                              Get.back();
                            },
                            child: Text(
                              'Done',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: controller.themeController
                                        .secondaryTextColor.value,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        child: ListTile(
          title: Obx(
            () {
              bool anyDaySelected =
                  controller.repeatDays.any((daySelected) => daySelected);
              return FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Repeat'.tr,
                  style: TextStyle(
                    color: themeController.primaryTextColor.value,
                    fontWeight:
                        anyDaySelected ? FontWeight.w500 : FontWeight.normal,
                  ),
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
                        color: themeController.primaryTextColor.value,
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
    );
  }

  void _storeOrPreset(List<bool> toSet, List<bool> toUse) {
    for (var i = 0; i < toUse.length; i++) {
      toSet[i] = toUse[i];
    }
  }

  ListTile buildDailyTile() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10.0),
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
            padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
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
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.5),
                  ),
                  activeColor: kprimaryColor.withOpacity(0.8),
                  value: controller.isDailySelected.value,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller
                        .setIsDailySelected(!controller.isDailySelected.value);

                    // Update repeatDays based on isDailySelected value
                    for (int i = 0; i < controller.repeatDays.length; i++) {
                      controller.repeatDays[i] =
                          controller.isDailySelected.value;
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

  Widget dayTile({
    required int dayIndex,
    required String dayName,
    required BuildContext context,
  }) {
    return Obx(
      () => InkWell(
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
                  color:
                      themeController.primaryTextColor.value.withOpacity(0.5),
                ),
                activeColor: kprimaryColor.withOpacity(0.8),
                value: controller.repeatDays[dayIndex],
                onChanged: (value) {
                  Utils.hapticFeedback();
                  controller.repeatDays[dayIndex] = value!;
                },
              ),
              Text(
                dayName,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildCustomDaysTile({
    required BuildContext context,
  }) {
    List<bool> repeatDays = List<bool>.filled(7, false);
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10.0),
      title: Obx(
        () => InkWell(
          onTap: () {
            Utils.hapticFeedback();
            _storeOrPreset(repeatDays, controller.repeatDays);

            controller.setIsCustomSelected(!controller.isCustomSelected.value);
            Get.defaultDialog(
              onWillPop: () async {
                // presetting values to initial state
                _storeOrPreset(controller.repeatDays, repeatDays);
                return true;
              },
              titlePadding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: themeController.secondaryBackgroundColor.value,
              title: 'Days of the week'.tr,
              titleStyle: TextStyle(
                color: themeController.primaryTextColor.value,
              ),
              content: Column(
                children: [
                  dayTile(
                    dayIndex: 0,
                    dayName: 'Monday'.tr,
                    context: context,
                  ),
                  dayTile(
                    dayIndex: 1,
                    dayName: 'Tuesday'.tr,
                    context: context,
                  ),
                  dayTile(
                    dayIndex: 2,
                    dayName: 'Wednesday'.tr,
                    context: context,
                  ),
                  dayTile(
                    dayIndex: 3,
                    dayName: 'Thursday'.tr,
                    context: context,
                  ),
                  dayTile(
                    dayIndex: 4,
                    dayName: 'Friday'.tr,
                    context: context,
                  ),
                  dayTile(
                    dayIndex: 5,
                    dayName: 'Saturday'.tr,
                    context: context,
                  ),
                  dayTile(
                    dayIndex: 6,
                    dayName: 'Sunday'.tr,
                    context: context,
                  ),
                  Padding(
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
                          ),
                          child: Text(
                            'Done'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color:
                                      themeController.secondaryTextColor.value,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Custom'),
                Checkbox.adaptive(
                  side: BorderSide(
                    width: 1.5,
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.5),
                  ),
                  activeColor: kprimaryColor.withOpacity(0.8),
                  value: controller.isCustomSelected.value,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.setIsCustomSelected(value!);

                    // Update repeatDays based on isCustomSelected value
                    _storeOrPreset(controller.repeatDays, repeatDays);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildWeekdaysTile() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10.0),
      title: Obx(
        () => InkWell(
          onTap: () {
            Utils.hapticFeedback();
            controller
                .setIsWeekdaysSelected(!controller.isWeekdaysSelected.value);

            // Update repeatDays based on isWeekdaysSelected value
            for (int i = 0; i < controller.repeatDays.length; i++) {
              // Assuming weekdays are from Monday to Friday (index 0 to 4)
              controller.repeatDays[i] =
                  controller.isWeekdaysSelected.value && i >= 0 && i <= 4;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Weekdays',
                ),
                Checkbox.adaptive(
                  side: BorderSide(
                    width: 1.5,
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.5),
                  ),
                  activeColor: kprimaryColor.withOpacity(0.8),
                  value: controller.isWeekdaysSelected.value,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.setIsWeekdaysSelected(
                      !controller.isWeekdaysSelected.value,
                    );

                    // Update repeatDays based on isWeekdaysSelected value
                    for (int i = 0; i < controller.repeatDays.length; i++) {
                      // Assuming weekdays are from Monday to Friday (index 0 to 4)
                      controller.repeatDays[i] =
                          controller.isWeekdaysSelected.value &&
                              i >= 0 &&
                              i <= 4;
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
