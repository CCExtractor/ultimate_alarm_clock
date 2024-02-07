import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/std_time_model.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class StandardTimeContainer extends GetView<TimerController> {
  StandardTimeContainer({super.key, required this.time});
  final StandardTimeModel time;
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    String hrs = "${time.hours}",
        min = "${time.minutes}",
        secs = "${time.seconds}";
    if (time.hours < 10) {
      hrs = '0' + hrs;
    }
    if (time.minutes < 10) {
      min = '0' + min;
    }
    if (time.seconds < 10) {
      secs = '0' + secs;
    }
    return Obx(
      () => GestureDetector(
        onLongPress: () {
          Get.defaultDialog(
            buttonColor: kLightSecondaryColor,
            backgroundColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            titlePadding: const EdgeInsets.only(top: 20),
            middleText: '',
            title: 'Delete Time',
            textConfirm: 'Delete',
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
            confirmTextColor: kprimaryTextColor,
            cancelTextColor: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
            content: Text(
              'Are you sure you want to delete this preset time ?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor
                      : kprimaryTextColor),
            ),
            onConfirm: () {
              controller.stdTimesList.remove(time);
              controller.isStandardTimeSelected.value = false;
              Get.back();
            },
            onCancel: () {
              Get.back();
            },
          );
        },
        onTap: () {
          if (!(controller.isStandardTimeSelected.value &&
              controller.currentStandardTimeIndex.value ==
                  controller.stdTimesList.indexOf(time))) {
            controller.hours.value = time.hours;
            controller.minutes.value = time.minutes;
            controller.seconds.value = time.seconds;
            controller.stdHrs.value = time.hours;
            controller.stdMin.value = time.minutes;
            controller.stdSec.value = time.seconds;
          }
          controller.isStandardTimeSelected.value = true;
          controller.currentStandardTimeIndex.value =
              controller.stdTimesList.indexOf(time);
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                  color: controller.isStandardTimeSelected.value &&
                          controller.currentStandardTimeIndex.value ==
                              controller.stdTimesList.indexOf(time)
                      ? (themeController.isLightMode.value
                          ? kprimaryColor
                          : kLightSecondaryColor)
                      : (themeController.isLightMode.value
                          ? kLightPrimaryDisabledTextColor
                          : kprimaryDisabledTextColor),
                  width: 2)),
          child: Center(
            child: Text(
              hrs + ":" + min + ":" + secs,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor
                      : kprimaryTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
