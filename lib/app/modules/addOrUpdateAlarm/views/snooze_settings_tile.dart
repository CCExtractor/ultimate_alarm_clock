import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SnoozeSettingsTile extends StatelessWidget {
  SnoozeSettingsTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  int initialDuration = 0;
  int initialCount = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        onTap: () {
          Utils.hapticFeedback();
          initialDuration = controller.snoozeDuration.value;
          initialCount = controller.maxSnoozeCount.value;
          
          Get.dialog(
            Dialog.fullscreen(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: themeController.primaryBackgroundColor.value,
                  title: Text('Snooze Settings'.tr, 
                    style: TextStyle(
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.close, 
                      color: themeController.primaryTextColor.value,
                    ),
                    onPressed: () {
                      Utils.hapticFeedback();
                      controller.snoozeDuration.value = initialDuration;
                      controller.maxSnoozeCount.value = initialCount;
                      Get.back();
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Utils.hapticFeedback();
                        Get.back();
                      },
                      child: Text(
                        'Done'.tr,
                        style: TextStyle(
                          color: kprimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Container(
                  color: themeController.primaryBackgroundColor.value,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Snooze Duration'.tr,
                                style: TextStyle(
                                  color: themeController.primaryTextColor.value,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Set how long the snooze lasts'.tr,
                                style: TextStyle(
                                  color: themeController.primaryDisabledTextColor.value,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
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
                                      itemWidth: Utils
                                          .getResponsiveNumberPickerItemWidth(
                                        context,
                                        screenWidth: MediaQuery.of(context).size.width,
                                        baseWidthFactor: 0.2,
                                      ),
                                      textStyle: Utils
                                          .getResponsiveNumberPickerTextStyle(
                                        context,
                                        baseFontSize: 20,
                                        color: themeController.primaryDisabledTextColor.value,
                                      ),
                                      selectedTextStyle: Utils
                                          .getResponsiveNumberPickerSelectedTextStyle(
                                        context,
                                        baseFontSize: 32,
                                        color: kprimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Obx(
                                    () => Text(
                                      controller.snoozeDuration.value > 0
                                          ? controller.snoozeDuration.value > 1
                                              ? 'minutes'.tr
                                              : 'minute'.tr
                                          : 'Off'.tr,
                                      style: TextStyle(
                                        color: themeController.primaryTextColor.value,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        Divider(
                          color: themeController.secondaryBackgroundColor.value,
                          thickness: 8,
                        ),
                      
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Maximum Snooze Count'.tr,
                                style: TextStyle(
                                  color: themeController.primaryTextColor.value,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Set the number of times you can snooze'.tr,
                                style: TextStyle(
                                  color: themeController.primaryDisabledTextColor.value,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
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
                                      itemWidth: Utils
                                          .getResponsiveNumberPickerItemWidth(
                                        context,
                                        screenWidth: MediaQuery.of(context).size.width,
                                        baseWidthFactor: 0.2,
                                      ),
                                      textStyle: Utils
                                          .getResponsiveNumberPickerTextStyle(
                                        context,
                                        baseFontSize: 20,
                                        color: themeController.primaryDisabledTextColor.value,
                                      ),
                                      selectedTextStyle: Utils
                                          .getResponsiveNumberPickerSelectedTextStyle(
                                        context,
                                        baseFontSize: 32,
                                        color: kprimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Obx(
                                    () => Text(
                                      controller.maxSnoozeCount.value > 1
                                          ? 'times'.tr
                                          : 'time'.tr,
                                      style: TextStyle(
                                        color: themeController.primaryTextColor.value,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Card(
                            color: themeController.secondaryBackgroundColor.value,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline, 
                                        color: themeController.primaryTextColor.value,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'How Snooze Works'.tr,
                                        style: TextStyle(
                                          color: themeController.primaryTextColor.value,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'When the alarm rings, you can press the snooze button to temporarily silence it. '
                                    'The alarm will ring again after the snooze duration. '
                                    'You can snooze the alarm up to the maximum snooze count.'.tr,
                                    style: TextStyle(
                                      color: themeController.primaryTextColor.value,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            'Snooze Settings'.tr,
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
                '${controller.snoozeDuration.value} min, ${controller.maxSnoozeCount.value}x',
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