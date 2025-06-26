import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../settings/controllers/theme_controller.dart';
import '../controllers/add_or_update_alarm_controller.dart';

class SchedulingOptionsTile extends StatelessWidget {
  const SchedulingOptionsTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: themeController.secondaryBackgroundColor.value,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              
              Container(
                decoration: BoxDecoration(
                  color: themeController.secondaryBackgroundColor.value.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(8),
                child: Row(
                  children: [
              
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!controller.isFutureDate.value) {
                            controller.isFutureDate.value = true;
                            
                            if (controller.repeatDays.any((day) => day)) {
                              controller.repeatDays.value = List.filled(7, false);
                              controller.daysRepeating.value = 'Never'.tr;
                              
                              Get.snackbar(
                                'Scheduling Changed',
                                'Repeat days have been turned off since you enabled "Ring On"',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: themeController.secondaryBackgroundColor.value,
                                colorText: themeController.primaryTextColor.value,
                                duration: const Duration(seconds: 3),
                                mainButton: TextButton(
                                  onPressed: () {
                                    controller.isFutureDate.value = false;
                                    controller.repeatDays.value = List.filled(7, true);
                                    controller.daysRepeating.value = 'Everyday'.tr;
                                    Get.back();
                                  },
                                  child: Text(
                                    'Undo',
                                    style: TextStyle(
                                      color: themeController.primaryTextColor.value,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }
                          } else {
                            
                            controller.datePicker(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: controller.isFutureDate.value
                                ? themeController.primaryColor.value
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'One-time',
                              style: TextStyle(
                                color: controller.isFutureDate.value
                                    ? Colors.white
                                    : themeController.primaryTextColor.value,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.isFutureDate.value) {
                            controller.isFutureDate.value = false;
                            
                    
                            Get.bottomSheet(
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: themeController.secondaryBackgroundColor.value,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Select Repeat Days',
                                      style: TextStyle(
                                        color: themeController.primaryTextColor.value,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      title: Text(
                                        'Everyday',
                                        style: TextStyle(
                                          color: themeController.primaryTextColor.value,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.repeatDays.value = List.filled(7, true);
                                        controller.daysRepeating.value = 'Everyday'.tr;
                                        Get.back();
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Weekdays',
                                        style: TextStyle(
                                          color: themeController.primaryTextColor.value,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.repeatDays.value = [true, true, true, true, true, false, false];
                                        controller.daysRepeating.value = 'Weekdays'.tr;
                                        Get.back();
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Weekends',
                                        style: TextStyle(
                                          color: themeController.primaryTextColor.value,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.repeatDays.value = [false, false, false, false, false, true, true];
                                        controller.daysRepeating.value = 'Weekends'.tr;
                                        Get.back();
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Custom',
                                        style: TextStyle(
                                          color: themeController.primaryTextColor.value,
                                        ),
                                      ),
                                      onTap: () {
                                        Get.back();
                                        controller.showCustomDaysDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                    
                            controller.showCustomDaysDialog(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !controller.isFutureDate.value
                                ? themeController.primaryColor.value
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Recurring',
                              style: TextStyle(
                                color: !controller.isFutureDate.value
                                    ? Colors.white
                                    : themeController.primaryTextColor.value,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(16),
                child: controller.isFutureDate.value
                    ? _buildOneTimeContent()
                    : _buildRecurringContent(),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildOneTimeContent() {
    return InkWell(
      onTap: () => controller.datePicker(Get.context!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ring On Date',
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          Row(
            children: [
              Text(
                controller.selectedDate.value.toString().substring(0, 10),
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.calendar_today,
                color: themeController.primaryColor.value,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringContent() {
    return InkWell(
      onTap: () => controller.showCustomDaysDialog(Get.context!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Repeat',
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          Row(
            children: [
              Text(
                controller.daysRepeating.value,
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: themeController.primaryColor.value,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 