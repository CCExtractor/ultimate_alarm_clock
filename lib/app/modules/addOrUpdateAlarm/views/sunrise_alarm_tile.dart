import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

class SunriseAlarmTile extends StatelessWidget {
  const SunriseAlarmTile({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          _showSunriseAlarmDialog(context);
        },
        child: ListTile(
          leading: Icon(
            controller.isSunriseEnabled.value ? Icons.wb_sunny : Icons.wb_sunny_outlined,
            color: controller.isSunriseEnabled.value 
                ? kprimaryColor 
                : themeController.primaryDisabledTextColor.value,
          ),
          title: Text(
            'Sunrise Alarm'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          subtitle: Text(
            controller.isSunriseEnabled.value 
                ? '${controller.sunriseDuration.value} min before alarm'
                : 'Disabled'.tr,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: themeController.primaryDisabledTextColor.value,
          ),
        ),
      ),
    );
  }

  void _showSunriseAlarmDialog(BuildContext context) {
    // Store original values
    bool originalEnabled = controller.isSunriseEnabled.value;
    int originalDuration = controller.sunriseDuration.value;
    double originalIntensity = controller.sunriseIntensity.value;
    int originalColorScheme = controller.sunriseColorScheme.value;

    Get.defaultDialog(
      onWillPop: () async {
        // Reset values if cancelled
        controller.isSunriseEnabled.value = originalEnabled;
        controller.sunriseDuration.value = originalDuration;
        controller.sunriseIntensity.value = originalIntensity;
        controller.sunriseColorScheme.value = originalColorScheme;
        Get.back();
        return true;
      },
      titlePadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      backgroundColor: themeController.secondaryBackgroundColor.value,
      title: 'Sunrise Alarm Settings'.tr,
      titleStyle: Theme.of(context).textTheme.displaySmall,
      content: Container(
        width: Get.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enable/Disable Switch
            Obx(() => SwitchListTile(
              title: Text(
                'Enable Sunrise Alarm'.tr,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: themeController.primaryTextColor.value,
                ),
              ),
              subtitle: Text(
                'Gradually brighten screen before alarm'.tr,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: themeController.primaryDisabledTextColor.value,
                ),
              ),
              value: controller.isSunriseEnabled.value,
              onChanged: (value) {
                controller.isSunriseEnabled.value = value;
              },
              activeColor: kprimaryColor,
            )),
            
            // Duration Slider (only visible when enabled)
            Obx(() => Visibility(
              visible: controller.isSunriseEnabled.value,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Sunrise Duration: ${controller.sunriseDuration.value} minutes'.tr,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                  Slider(
                    value: controller.sunriseDuration.value.toDouble(),
                    onChanged: (value) {
                      controller.sunriseDuration.value = value.toInt();
                    },
                    min: 5.0,
                    max: 60.0,
                    divisions: 11, // 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60
                    label: '${controller.sunriseDuration.value} min',
                    activeColor: kprimaryColor,
                  ),
                ],
              ),
            )),
            
            // Intensity Slider (only visible when enabled)
            Obx(() => Visibility(
              visible: controller.isSunriseEnabled.value,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Light Intensity: ${(controller.sunriseIntensity.value * 100).toInt()}%'.tr,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                  Slider(
                    value: controller.sunriseIntensity.value,
                    onChanged: (value) {
                      controller.sunriseIntensity.value = value;
                    },
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: '${(controller.sunriseIntensity.value * 100).toInt()}%',
                    activeColor: kprimaryColor,
                  ),
                ],
              ),
            )),
            
            // Color Scheme Selection (only visible when enabled)
            Obx(() => Visibility(
              visible: controller.isSunriseEnabled.value,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Color Scheme'.tr,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorSchemeOption(
                        context,
                        index: 0,
                        name: 'Natural',
                        color: Colors.orange,
                      ),
                      _buildColorSchemeOption(
                        context,
                        index: 1,
                        name: 'Warm',
                        color: Colors.deepOrange,
                      ),
                      _buildColorSchemeOption(
                        context,
                        index: 2,
                        name: 'Cool',
                        color: Colors.lightBlue,
                      ),
                    ],
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Reset to original values
                    controller.isSunriseEnabled.value = originalEnabled;
                    controller.sunriseDuration.value = originalDuration;
                    controller.sunriseIntensity.value = originalIntensity;
                    controller.sunriseColorScheme.value = originalColorScheme;
                    Get.back();
                  },
                  child: Text(
                    'Cancel'.tr,
                    style: TextStyle(
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                ),
                Obx(() => Visibility(
                  visible: controller.isSunriseEnabled.value,
                  child: TextButton(
                    onPressed: () => _previewSunriseEffect(),
                    child: Text(
                      'Preview'.tr,
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                )),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                  ),
                  child: Text(
                    'Apply'.tr,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: themeController.secondaryTextColor.value,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSchemeOption(BuildContext context, {
    required int index,
    required String name,
    required Color color,
  }) {
    return Obx(() => GestureDetector(
      onTap: () {
        controller.sunriseColorScheme.value = index;
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: controller.sunriseColorScheme.value == index 
              ? kprimaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.sunriseColorScheme.value == index 
                ? kprimaryColor
                : themeController.primaryDisabledTextColor.value,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ));
  }
  
  void _previewSunriseEffect() {
    Get.back(); // Close the dialog first
    
    // Create a preview alarm model with current sunrise settings using init model
    final previewAlarm = Utils.alarmModelInit;
    previewAlarm.note = 'Sunrise Preview';
    previewAlarm.ringtoneName = 'Digital Alarm Clock';
    previewAlarm.isSunriseEnabled = controller.isSunriseEnabled.value;
    previewAlarm.sunriseDuration = 1; // Use 1 minute for preview
    previewAlarm.sunriseIntensity = controller.sunriseIntensity.value;
    previewAlarm.sunriseColorScheme = controller.sunriseColorScheme.value;
    
    // Navigate to alarm ring view in preview mode
    Get.toNamed(
      '/alarm-ring',
      arguments: {
        'alarm': previewAlarm,
        'preview': true,
      },
    );
  }
} 