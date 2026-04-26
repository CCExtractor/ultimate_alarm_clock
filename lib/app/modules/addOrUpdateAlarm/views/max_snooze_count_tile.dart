import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class MaxSnoozeCountTile extends StatelessWidget {
  MaxSnoozeCountTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  int initialCount = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        onTap: () {
          Utils.hapticFeedback();
          initialCount = controller.maxSnoozeCount.value;
          Get.defaultDialog(
            onWillPop: () async {
              Get.back();
              controller.maxSnoozeCount.value = initialCount;
              return true;
            },
            titlePadding: const EdgeInsets.only(top: 20),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Maximum Snooze Count'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                            () => NumberPicker(
                              value: controller.maxSnoozeCount.value <= 0
                                  ? 1
                                  : controller.maxSnoozeCount.value,
                              minValue: 1,
                              maxValue: 10,
                              onChanged: (value) {
                                Utils.hapticFeedback();
                                controller.maxSnoozeCount.value = value;
                              },
                            ),
                          ),
                          Obx(
                            () => Text(
                              controller.maxSnoozeCount.value > 1
                                  ? 'times'.tr
                                  : 'time'.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            'Max Snooze Count'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                '${controller.maxSnoozeCount.value} ${controller.maxSnoozeCount.value > 1 ? 'times'.tr : 'time'.tr}',
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
    );
  }
} 