// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AscendingVolumeTile extends StatelessWidget {
  const AscendingVolumeTile({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int gradient = 10;
    return InkWell(
      onTap: () {
        Utils.hapticFeedback();
        gradient = controller.gradient.value;
        Get.defaultDialog(
          onWillPop: () async {
            Get.back();
            // Resetting the value to its initial state
            controller.gradient.value = gradient;
            return true;
          },
          titlePadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Volume will reach maximum in '.tr,
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Text(
                  '${controller.gradient.value} seconds',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Slider(
                  value: controller.selectedGradientDouble.value,
                  onChanged: (double value) {
                    controller.selectedGradientDouble.value = value;
                    controller.gradient.value = value.toInt();
                  },
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: controller.gradient.value.toString(),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    // Add your logic to handle the gradient value
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                  ),
                  child: Text(
                    'Apply Gradient',
                    style: TextStyle(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryTextColor
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
        tileColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: Text(
          'Ascending Volume'.tr,
          style: TextStyle(
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
          ),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                '${controller.gradient.value.round().toInt()} seconds',
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
}
