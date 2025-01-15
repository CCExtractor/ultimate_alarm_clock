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
    return Obx(
      () => InkWell(
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
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Select duration'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NumberPicker(
                            value: controller.snoozeDuration.value <= 0
                                ? 1
                                : controller.snoozeDuration
                                    .value, // Handle 0 or negative values
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
                                color: themeController.secondaryTextColor.value,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            ),
          );
        },
        child: ListTile(
          title: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              'Snooze Duration'.tr,
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
                  controller.snoozeDuration.value > 0
                      ? '${controller.snoozeDuration.value} min'
                      : 'Off'.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: (controller.snoozeDuration.value <= 0)
                            ? themeController.primaryDisabledTextColor.value
                            : themeController.primaryTextColor.value,
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
