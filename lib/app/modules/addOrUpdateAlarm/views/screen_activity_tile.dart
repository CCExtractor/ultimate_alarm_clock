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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Screen Activity'.tr,
                    style: TextStyle(
                      color: themeController.primaryTextColor.value,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_sharp,
                    size: 21,
                    color: themeController.primaryTextColor.value.withOpacity(0.3),
                  ),
                  onPressed: () {
                    Utils.hapticFeedback();
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: themeController.secondaryBackgroundColor.value,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.smartphone,
                                  color: themeController.primaryTextColor.value,
                                  size: height * 0.1,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Enhanced Screen Activity Monitoring'.tr,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Choose how your alarm responds to your phone usage:',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                _buildInfoItem(context, Icons.alarm, 'Ring When Active', 'Alarm rings if you\'ve been using your phone within the time limit'),
                                _buildInfoItem(context, Icons.alarm_off, 'Cancel When Active', 'Alarm is cancelled if you\'ve been using your phone within the time limit'),
                                _buildInfoItem(context, Icons.alarm_on, 'Ring When Inactive', 'Alarm rings if you haven\'t used your phone for the specified time'),
                                _buildInfoItem(context, Icons.cancel, 'Cancel When Inactive', 'Alarm is cancelled if you haven\'t used your phone for the specified time'),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: width,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(kprimaryColor),
                                    ),
                                    onPressed: () {
                                      Utils.hapticFeedback();
                                      Get.back();
                                    },
                                    child: Text(
                                      'Understood'.tr,
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                        color: themeController.secondaryTextColor.value,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            trailing: Obx(
              () => Switch(
                value: controller.activityConditionType.value != ActivityConditionType.off,
                onChanged: (value) {
                  Utils.hapticFeedback();
                  if (value) {
                    controller.activityConditionType.value = ActivityConditionType.cancelWhenActive;
                    controller.isActivityMonitorenabled.value = 1;
                    controller.useScreenActivity.value = true;
                    // Set default interval if it's 0
                    if (controller.activityInterval.value == 0) {
                      controller.activityInterval.value = 30; // 30 minutes default
                    }
                  } else {
                    controller.activityConditionType.value = ActivityConditionType.off;
                    controller.isActivityMonitorenabled.value = 0;
                    controller.useScreenActivity.value = false;
                  }
                },
                activeColor: kprimaryColor,
              ),
            ),
          ),
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: controller.activityConditionType.value != ActivityConditionType.off
                  ? null
                  : 0,
              child: controller.activityConditionType.value != ActivityConditionType.off
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          ...ActivityConditionType.values.where((type) => type != ActivityConditionType.off).map(
                            (conditionType) => _buildActivityConditionCard(
                              context,
                              conditionType,
                              controller,
                              themeController,
                            ),
                          ).toList(),
                          const SizedBox(height: 10),
                          _buildTimeIntervalCard(context, controller, themeController),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: themeController.primaryTextColor.value),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: themeController.primaryTextColor.value,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeController.primaryTextColor.value.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityConditionCard(
    BuildContext context,
    ActivityConditionType conditionType,
    AddOrUpdateAlarmController controller,
    ThemeController themeController,
  ) {
    final isSelected = controller.activityConditionType.value == conditionType;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Utils.hapticFeedback();
          controller.activityConditionType.value = conditionType;
          
          // Update legacy fields for backward compatibility
          controller.isActivityMonitorenabled.value = 1;
          controller.useScreenActivity.value = true;
          
          // Set default interval if it's 0
          if (controller.activityInterval.value == 0) {
            controller.activityInterval.value = 30; // 30 minutes default
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? kprimaryColor.withOpacity(0.1) 
                : themeController.primaryBackgroundColor.value,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? kprimaryColor 
                  : themeController.primaryDisabledTextColor.value.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getActivityConditionIcon(conditionType),
                color: isSelected 
                    ? kprimaryColor 
                    : themeController.primaryTextColor.value.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getActivityConditionText(conditionType),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: themeController.primaryTextColor.value,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getActivityConditionDescription(conditionType),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeController.primaryTextColor.value.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: kprimaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeIntervalCard(
    BuildContext context,
    AddOrUpdateAlarmController controller,
    ThemeController themeController,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeController.primaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kprimaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: kprimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Time Duration',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => NumberPicker(
                  value: controller.activityInterval.value > 0 ? controller.activityInterval.value : 1,
                  minValue: 1,
                  maxValue: 1440,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.activityInterval.value = value;
                    controller.isActivityenabled.value = value > 0;
                  },
                  itemWidth: Utils
                      .getResponsiveNumberPickerItemWidth(
                    context,
                    screenWidth: MediaQuery.of(context).size.width,
                    baseWidthFactor: 0.25,
                  ),
                  selectedTextStyle: Utils
                      .getResponsiveNumberPickerSelectedTextStyle(
                    context,
                    baseFontSize: 24,
                    color: kprimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textStyle: Utils
                      .getResponsiveNumberPickerTextStyle(
                    context,
                    baseFontSize: 18,
                    color: themeController.primaryTextColor.value,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: kprimaryColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => Text(
                  controller.activityInterval.value > 1 ? 'minutes'.tr : 'minute'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeController.primaryTextColor.value,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Set how many minutes of activity/inactivity should trigger the condition',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: themeController.primaryTextColor.value.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getActivityConditionText(ActivityConditionType conditionType) {
    switch (conditionType) {
      case ActivityConditionType.off:
        return 'Off'.tr;
      case ActivityConditionType.ringWhenActive:
        return 'Ring when Active'.tr;
      case ActivityConditionType.cancelWhenActive:
        return 'Cancel when Active'.tr;
      case ActivityConditionType.ringWhenInactive:
        return 'Ring when Inactive'.tr;
      case ActivityConditionType.cancelWhenInactive:
        return 'Cancel when Inactive'.tr;
    }
  }

  String _getActivityConditionDescription(ActivityConditionType conditionType) {
    switch (conditionType) {
      case ActivityConditionType.off:
        return 'Screen activity monitoring is disabled';
      case ActivityConditionType.ringWhenActive:
        return 'Perfect for late-night usage alerts - rings if you\'ve been active';
      case ActivityConditionType.cancelWhenActive:
        return 'Smart wake-up - cancels if you\'re already awake and using your phone';
      case ActivityConditionType.ringWhenInactive:
        return 'Activity reminders - rings if you haven\'t been active';
      case ActivityConditionType.cancelWhenInactive:
        return 'Sleep detection - cancels if you\'ve been inactive (likely sleeping)';
    }
  }

  IconData _getActivityConditionIcon(ActivityConditionType conditionType) {
    switch (conditionType) {
      case ActivityConditionType.off:
        return Icons.smartphone_outlined;
      case ActivityConditionType.ringWhenActive:
        return Icons.smartphone;
      case ActivityConditionType.cancelWhenActive:
        return Icons.phone_android;
      case ActivityConditionType.ringWhenInactive:
        return Icons.mobile_off;
      case ActivityConditionType.cancelWhenInactive:
        return Icons.do_not_disturb_on;
    }
  }
}
