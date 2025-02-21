import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ScreenActivityTile extends StatelessWidget {
  const ScreenActivityTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int activityInterval;
    bool isActivityEnalbed;
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          activityInterval = controller.activityInterval.value;
          isActivityEnalbed = controller.isActivityenabled.value;
          Get.defaultDialog(
            onWillPop: () async {
              controller.activityInterval.value = activityInterval;
              controller.isActivityenabled.value = isActivityEnalbed;
              return true;
            },
            titlePadding: const EdgeInsets.only(top: 20),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Timeout Duration'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Switch.adaptive(
                          value: controller.useScreenActivity.value,
                          activeColor: ksecondaryColor,
                          onChanged: (value) {
                            controller.useScreenActivity.value = value;
                            if (!value)
                              controller.isActivityMonitorenabled.value = 0;
                            else
                              controller.isActivityMonitorenabled.value = 1;
                          },
                        ),
                        NumberPicker(
                          value: controller.activityInterval.value,
                          minValue: 0,
                          maxValue: 1440,
                          onChanged: (value) {
                            Utils.hapticFeedback();
                            if (value > 0) {
                              controller.isActivityenabled.value = true;
                            } else {
                              controller.isActivityenabled.value = false;
                            }
                            controller.activityInterval.value = value;
                          },
                        ),
                        Text(
                          controller.activityInterval.value > 1
                              ? 'minutes'.tr
                              : 'minute'.tr,
                        ),
                      ],
                    ),
                  ),
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
                      'Done'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: themeController.secondaryTextColor.value,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Screen Activity'.tr,
                  style: TextStyle(
                    color: themeController.primaryTextColor.value,
                  ),
                ),
              ),
              Obx(
                () => Switch.adaptive(
                  value: controller.useScreenActivity.value,
                  activeColor: ksecondaryColor,
                  onChanged: (value) {
                    controller.useScreenActivity.value = value;
                    if (!value)
                      controller.isActivityMonitorenabled.value = 0;
                    else
                      controller.isActivityMonitorenabled.value = 1;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
