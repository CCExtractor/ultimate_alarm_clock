import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmRing/views/sunrise_effect_widget.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

class SunriseAlarmTile extends StatelessWidget {
  const SunriseAlarmTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        leading: Icon(
          controller.isSunriseEnabled.value
              ? Icons.wb_sunny
              : Icons.wb_sunny_outlined,
          color: controller.isSunriseEnabled.value
              ? kprimaryColor
              : themeController.primaryDisabledTextColor.value,
        ),
        title: Text(
          'Sunrise Alarm'.tr,
          style: TextStyle(color: themeController.primaryTextColor.value),
        ),
        subtitle: Text(
          controller.isSunriseEnabled.value
              ? '${controller.sunriseDuration.value} min before alarm'
              : 'Disabled'.tr,
          style: TextStyle(
            color: controller.isSunriseEnabled.value
                ? themeController.primaryTextColor.value.withOpacity(0.7)
                : themeController.primaryDisabledTextColor.value,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: themeController.primaryDisabledTextColor.value,
        ),
        onTap: () {
          Utils.hapticFeedback();
          _showSunriseBottomSheet(context);
        },
      ),
    );
  }

  void _showSunriseBottomSheet(BuildContext context) {
    // Capture original values for Cancel
    final origEnabled = controller.isSunriseEnabled.value;
    final origDuration = controller.sunriseDuration.value;
    final origIntensity = controller.sunriseIntensity.value;
    final origColorScheme = controller.sunriseColorScheme.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeController.secondaryBackgroundColor.value,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: themeController.primaryDisabledTextColor.value,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          // Title
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Sunrise Alarm Settings'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: themeController.primaryTextColor.value,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          // Enable switch
                          SwitchListTile(
                            activeColor: kprimaryColor,
                            title: Text(
                              'Enable Sunrise Alarm'.tr,
                              style: TextStyle(
                                  color:
                                      themeController.primaryTextColor.value),
                            ),
                            subtitle: Text(
                              'Gradually brighten screen before alarm'.tr,
                              style: TextStyle(
                                color: themeController
                                    .primaryDisabledTextColor.value,
                              ),
                            ),
                            value: controller.isSunriseEnabled.value,
                            onChanged: (val) {
                              controller.isSunriseEnabled.value = val;
                            },
                          ),
                          // Animated settings block
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: controller.isSunriseEnabled.value
                                ? null
                                : 0,
                            child: controller.isSunriseEnabled.value
                                ? _buildSettingsBody(context)
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          // Footer row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Cancel
                              TextButton(
                                onPressed: () {
                                  controller.isSunriseEnabled.value =
                                      origEnabled;
                                  controller.sunriseDuration.value =
                                      origDuration;
                                  controller.sunriseIntensity.value =
                                      origIntensity;
                                  controller.sunriseColorScheme.value =
                                      origColorScheme;
                                  Get.back();
                                },
                                child: Text(
                                  'Cancel'.tr,
                                  style: TextStyle(
                                    color: themeController
                                        .primaryTextColor.value,
                                  ),
                                ),
                              ),
                              // Preview
                              if (controller.isSunriseEnabled.value)
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: () {
                                    final previewAlarm =
                                        Utils.alarmModelInit.copyWithSunrise(
                                      isSunriseEnabled: true,
                                      sunriseDuration: 1,
                                      sunriseIntensity:
                                          controller.sunriseIntensity.value,
                                      sunriseColorScheme:
                                          controller.sunriseColorScheme.value,
                                    );
                                    Get.toNamed(
                                      '/alarm-ring',
                                      arguments: {
                                        'alarm': previewAlarm,
                                        'preview': true,
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Preview'.tr,
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              // Apply
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kprimaryColor),
                                onPressed: () => Get.back(),
                                child: Text(
                                  'Apply'.tr,
                                  style: TextStyle(
                                    color: themeController
                                        .secondaryTextColor.value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      )),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsBody(BuildContext context) {
    const schemeLabels = ['Natural', 'Warm', 'Cool'];
    const schemeColors = [Colors.orange, Colors.deepOrange, Colors.lightBlue];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        // Duration
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sunrise Duration'.tr,
                style:
                    TextStyle(color: themeController.primaryTextColor.value),
              ),
              Text(
                '${controller.sunriseDuration.value} min',
                style:
                    TextStyle(color: themeController.primaryTextColor.value),
              ),
            ],
          ),
        ),
        Slider(
          activeColor: kprimaryColor,
          min: 5,
          max: 60,
          divisions: 11,
          label: '${controller.sunriseDuration.value} min',
          value: controller.sunriseDuration.value.toDouble(),
          onChanged: (val) =>
              controller.sunriseDuration.value = val.toInt(),
        ),
        // Intensity
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Light Intensity'.tr,
                style:
                    TextStyle(color: themeController.primaryTextColor.value),
              ),
              Text(
                '${(controller.sunriseIntensity.value * 100).toInt()}%',
                style:
                    TextStyle(color: themeController.primaryTextColor.value),
              ),
            ],
          ),
        ),
        Slider(
          activeColor: kprimaryColor,
          min: 0.1,
          max: 1.0,
          divisions: 9,
          label:
              '${(controller.sunriseIntensity.value * 100).toInt()}%',
          value: controller.sunriseIntensity.value,
          onChanged: (val) => controller.sunriseIntensity.value = val,
        ),
        // Color scheme
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            'Color Scheme'.tr,
            style:
                TextStyle(color: themeController.primaryTextColor.value),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            final selected =
                controller.sunriseColorScheme.value == index;
            return GestureDetector(
              onTap: () =>
                  controller.sunriseColorScheme.value = index,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? kprimaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                  color: selected
                      ? kprimaryColor.withOpacity(0.15)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: schemeColors[index],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      schemeLabels[index],
                      style: TextStyle(
                        color: selected
                            ? kprimaryColor
                            : themeController.primaryTextColor.value,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

extension _AlarmModelSunriseCopy on AlarmModel {
  AlarmModel copyWithSunrise({
    required bool isSunriseEnabled,
    required int sunriseDuration,
    required double sunriseIntensity,
    required int sunriseColorScheme,
  }) {
    return AlarmModel(
      alarmTime: alarmTime,
      alarmID: alarmID,
      ownerId: ownerId,
      ownerName: ownerName,
      lastEditedUserId: lastEditedUserId,
      mutexLock: mutexLock,
      isEnabled: isEnabled,
      days: days,
      intervalToAlarm: intervalToAlarm,
      isActivityEnabled: isActivityEnabled,
      minutesSinceMidnight: minutesSinceMidnight,
      isLocationEnabled: isLocationEnabled,
      isSharedAlarmEnabled: isSharedAlarmEnabled,
      isWeatherEnabled: isWeatherEnabled,
      location: location,
      weatherTypes: weatherTypes,
      isMathsEnabled: isMathsEnabled,
      mathsDifficulty: mathsDifficulty,
      numMathsQuestions: numMathsQuestions,
      isShakeEnabled: isShakeEnabled,
      shakeTimes: shakeTimes,
      isQrEnabled: isQrEnabled,
      qrValue: qrValue,
      isPedometerEnabled: isPedometerEnabled,
      numberOfSteps: numberOfSteps,
      activityInterval: activityInterval,
      offsetDetails: offsetDetails,
      mainAlarmTime: mainAlarmTime,
      label: label,
      isOneTime: isOneTime,
      snoozeDuration: snoozeDuration,
      maxSnoozeCount: maxSnoozeCount,
      gradient: gradient,
      ringtoneName: ringtoneName,
      note: note,
      deleteAfterGoesOff: deleteAfterGoesOff,
      showMotivationalQuote: showMotivationalQuote,
      volMax: volMax,
      volMin: volMin,
      activityMonitor: activityMonitor,
      alarmDate: alarmDate,
      ringOn: ringOn,
      profile: profile,
      isGuardian: isGuardian,
      guardianTimer: guardianTimer,
      guardian: guardian,
      isCall: isCall,
      isSunriseEnabled: isSunriseEnabled,
      sunriseDuration: sunriseDuration,
      sunriseIntensity: sunriseIntensity,
      sunriseColorScheme: sunriseColorScheme,
    );
  }
}
