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

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeController.secondaryBackgroundColor.value,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: themeController.primaryDisabledTextColor.value.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sunrise Alarm Settings'.tr,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: themeController.primaryTextColor.value,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Reset values if cancelled
                            controller.isSunriseEnabled.value = originalEnabled;
                            controller.sunriseDuration.value = originalDuration;
                            controller.sunriseIntensity.value = originalIntensity;
                            controller.sunriseColorScheme.value = originalColorScheme;
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: themeController.primaryDisabledTextColor.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enable/Disable Switch
                          Obx(() => Container(
                            decoration: BoxDecoration(
                              color: themeController.primaryBackgroundColor.value,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
                              ),
                            ),
                            child: SwitchListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text(
                                'Enable Sunrise Alarm'.tr,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: themeController.primaryTextColor.value,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Gradually brighten screen before alarm'.tr,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: themeController.primaryDisabledTextColor.value,
                                ),
                              ),
                              value: controller.isSunriseEnabled.value,
                              onChanged: (value) {
                                Utils.hapticFeedback();
                                controller.isSunriseEnabled.value = value;
                              },
                              activeColor: kprimaryColor,
                            ),
                          )),
                          
                          // Settings (only visible when enabled)
                          Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: controller.isSunriseEnabled.value ? null : 0,
                            child: Visibility(
                              visible: controller.isSunriseEnabled.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  
                                  // Duration Slider
                                  _buildSettingCard(
                                    context,
                                    title: 'Sunrise Duration'.tr,
                                    subtitle: '${controller.sunriseDuration.value} minutes'.tr,
                                    child: Obx(() => Slider(
                                      value: controller.sunriseDuration.value.toDouble(),
                                      onChanged: (value) {
                                        Utils.hapticFeedback();
                                        controller.sunriseDuration.value = value.toInt();
                                      },
                                      min: 5.0,
                                      max: 60.0,
                                      divisions: 11,
                                      label: '${controller.sunriseDuration.value} min',
                                      activeColor: kprimaryColor,
                                      semanticFormatterCallback: (double value) {
                                        return '${value.round()} minutes';
                                      },
                                    )),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Intensity Slider
                                  _buildSettingCard(
                                    context,
                                    title: 'Light Intensity'.tr,
                                    subtitle: '${(controller.sunriseIntensity.value * 100).toInt()}%',
                                    child: Obx(() => Slider(
                                      value: controller.sunriseIntensity.value,
                                      onChanged: (value) {
                                        Utils.hapticFeedback();
                                        controller.sunriseIntensity.value = value;
                                      },
                                      min: 0.1,
                                      max: 1.0,
                                      divisions: 9,
                                      label: '${(controller.sunriseIntensity.value * 100).toInt()}%',
                                      activeColor: kprimaryColor,
                                      semanticFormatterCallback: (double value) {
                                        return '${(value * 100).round()} percent';
                                      },
                                    )),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Color Scheme Selection
                                  _buildSettingCard(
                                    context,
                                    title: 'Color Scheme'.tr,
                                    subtitle: _getColorSchemeName(),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              // Reset to original values
                              controller.isSunriseEnabled.value = originalEnabled;
                              controller.sunriseDuration.value = originalDuration;
                              controller.sunriseIntensity.value = originalIntensity;
                              controller.sunriseColorScheme.value = originalColorScheme;
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel'.tr,
                              style: TextStyle(
                                color: themeController.primaryTextColor.value,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Preview Button (only when enabled)
                        Obx(() => controller.isSunriseEnabled.value
                            ? Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Utils.hapticFeedback();
                                    _previewSunriseEffect();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(color: Colors.orange),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Preview'.tr,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()),
                        
                        SizedBox(width: controller.isSunriseEnabled.value ? 12 : 0),
                        
                        // Apply Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Apply'.tr,
                              style: TextStyle(
                                color: themeController.secondaryTextColor.value,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeController.primaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: themeController.primaryDisabledTextColor.value,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  String _getColorSchemeName() {
    switch (controller.sunriseColorScheme.value) {
      case 0:
        return 'Natural';
      case 1:
        return 'Warm';
      case 2:
        return 'Cool';
      default:
        return 'Natural';
    }
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