import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class PedometerChallenge extends StatelessWidget {
  const PedometerChallenge({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int numberOfSteps;
    bool isPedometerEnabled;
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          // storing initial state
          numberOfSteps = controller.numberOfSteps.value;
          isPedometerEnabled = controller.isPedometerEnabled.value;
          
          _showPedometerSettingsBottomSheet(context, numberOfSteps, isPedometerEnabled);
        },
        child: ListTile(
          leading: Icon(
            controller.isPedometerEnabled.value ? Icons.directions_walk : Icons.directions_walk_outlined,
            color: controller.isPedometerEnabled.value 
                ? kprimaryColor 
                : themeController.primaryDisabledTextColor.value,
          ),
          title: Text(
            'Step Challenge'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          subtitle: Text(
            controller.isPedometerEnabled.value && controller.numberOfSteps.value > 0
                ? controller.numberOfSteps.value > 1
                    ? '${controller.numberOfSteps.value} steps required'
                    : '${controller.numberOfSteps.value} step required'
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

  void _showPedometerSettingsBottomSheet(BuildContext context, int initialNumberOfSteps, bool initialIsPedometerEnabled) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeController.secondaryBackgroundColor.value,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          color: kprimaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Step Challenge'.tr,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: themeController.primaryTextColor.value,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Enable/Disable Switch
                          _buildSection(
                            title: 'Enable Step Challenge'.tr,
                            subtitle: 'Require walking to dismiss alarm'.tr,
                            child: Obx(() => Switch.adaptive(
                              value: controller.isPedometerEnabled.value,
                              onChanged: (value) {
                                Utils.hapticFeedback();
                                controller.isPedometerEnabled.value = value;
                                if (!value) {
                                  controller.numberOfSteps.value = 0;
                                } else if (controller.numberOfSteps.value == 0) {
                                  controller.numberOfSteps.value = 10;
                                }
                              },
                              activeColor: kprimaryColor,
                            )),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Step Count (when enabled)
                          Obx(() => controller.isPedometerEnabled.value
                              ? _buildSection(
                                  title: 'Number of Steps'.tr,
                                  subtitle: 'How many steps are required'.tr,
                                  child: Column(
                                    children: [
                                      Obx(() => Text(
                                        controller.numberOfSteps.value.toString(),
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          color: kprimaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                      const SizedBox(height: 16),
                                      NumberPicker(
                                        value: controller.numberOfSteps.value,
                                        minValue: 1,
                                        maxValue: 100,
                                        onChanged: (value) {
                                          Utils.hapticFeedback();
                                          controller.numberOfSteps.value = value;
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
                                          baseFontSize: 16,
                                          color: themeController.primaryDisabledTextColor.value,
                                        ),
                                        selectedTextStyle: Utils
                                            .getResponsiveNumberPickerSelectedTextStyle(
                                          context,
                                          baseFontSize: 20,
                                          color: kprimaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Step guidance
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.green.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Get out of bed and walk around to dismiss your alarm'.tr,
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: themeController.primaryTextColor.value,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container()),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: themeController.secondaryBackgroundColor.value,
                      border: Border(
                        top: BorderSide(
                          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              // Reset to initial values
                              controller.numberOfSteps.value = initialNumberOfSteps;
                              controller.isPedometerEnabled.value = initialIsPedometerEnabled;
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Cancel'.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: themeController.primaryTextColor.value,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Done'.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
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

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeController.primaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
