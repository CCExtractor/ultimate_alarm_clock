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
          duration = controller.snoozeDuration.value;
          Get.defaultDialog(
            onWillPop: () async {
              Get.back();
              controller.snoozeDuration.value = duration;
              return true;
            },
            titlePadding: const EdgeInsets.only(top: 20),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Select duration'.tr,
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
                              value: controller.snoozeDuration.value <= 0
                                  ? 0
                                  : controller.snoozeDuration.value,
                              minValue: 0,
                              maxValue: 60,
                              onChanged: (value) {
                                Utils.hapticFeedback();
                                controller.snoozeDuration.value = value;
                              },
                            ),
                          ),
                          Obx(
                            () => Text(
                              controller.snoozeDuration.value > 0
                              ? controller.snoozeDuration.value > 1
                                  ? 'minutes'.tr
                                  : 'minute'.tr
                              : 'Off'.tr,
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
