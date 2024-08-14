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
    int gradient;
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          gradient = controller.gradient.value;
          Get.defaultDialog(
            onWillPop: () async {
              Get.back();
              // Resetting the value to its initial state
              controller.gradient.value = gradient;
              controller.selectedGradientDouble.value = gradient.toDouble();

              return true;
            },
            titlePadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Volume will reach maximum in'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Column(
                children: [
                  Text(
                    '${controller.gradient.value} seconds'.tr,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Slider(
                    value: controller.selectedGradientDouble.value,
                    onChanged: (double value) {
                      controller.selectedGradientDouble.value = value;
                      controller.gradient.value = value.toInt();
                    },
                    min: 0.0,
                    max: 60.0,
                    divisions: 60,
                    label: controller.gradient.value.toString(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Adjust the volume range'.tr,
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Replace the volMin Slider with RangeSlider
                  RangeSlider(
                    labels: RangeLabels(
                      controller.volMin.value
                          .toInt()
                          .toString(), // Label for volMin
                      controller.volMax.value
                          .toInt()
                          .toString(), // Label for volMax
                    ),
                    values: RangeValues(
                      controller.volMin.value,
                      controller.volMax.value,
                    ),
                    onChanged: (RangeValues values) {
                      controller.volMin.value = values.start;
                      controller.volMax.value = values.end;
                    },
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                    ),
                    child: Text(
                      'Apply Gradient'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: themeController.currentTheme.value ==
                                    ThemeMode.light
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
          tileColor: themeController.secondaryBackgroundColor.value,
          title: Text(
            'Ascending Volume'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Text(
                  '${controller.gradient.value.round().toInt()} seconds',
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
}
