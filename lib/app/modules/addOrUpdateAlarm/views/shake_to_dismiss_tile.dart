import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ShakeToDismiss extends StatelessWidget {
  const ShakeToDismiss({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int shakeTimes;
    bool isShakeEnabled;
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          // storing initial state
          shakeTimes = controller.shakeTimes.value;
          isShakeEnabled = controller.isShakeEnabled.value;
          
          _showShakeSettingsBottomSheet(context, shakeTimes, isShakeEnabled);
        },
        child: ListTile(
          leading: Icon(
            controller.isShakeEnabled.value ? Icons.vibration : Icons.vibration_outlined,
            color: controller.isShakeEnabled.value 
                ? kprimaryColor 
                : themeController.primaryDisabledTextColor.value,
          ),
          title: Text(
            'Shake to Dismiss'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          subtitle: Text(
            controller.isShakeEnabled.value && controller.shakeTimes.value > 0
                ? controller.shakeTimes.value > 1
                    ? '${controller.shakeTimes.value} shakes required'.tr
                    : '${controller.shakeTimes.value} shake required'.tr
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

  void _showShakeSettingsBottomSheet(BuildContext context, int initialShakeTimes, bool initialIsShakeEnabled) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
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
                          Icons.vibration,
                          color: kprimaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Shake to Dismiss'.tr,
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
                            title: 'Enable Shake Dismissal'.tr,
                            subtitle: 'Require shaking to dismiss alarm'.tr,
                            child: Obx(() => Switch.adaptive(
                              value: controller.isShakeEnabled.value,
                              onChanged: (value) {
                                Utils.hapticFeedback();
                                controller.isShakeEnabled.value = value;
                                if (!value) {
                                  controller.shakeTimes.value = 0;
                                } else if (controller.shakeTimes.value == 0) {
                                  controller.shakeTimes.value = 5;
                                }
                              },
                              activeColor: kprimaryColor,
                            )),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Shake Count (when enabled)
                          Obx(() => controller.isShakeEnabled.value
                              ? _buildSection(
                                  title: 'Number of Shakes'.tr,
                                  subtitle: 'How many shakes are required'.tr,
                                  child: Column(
                                    children: [
                                      Obx(() => Text(
                                        controller.shakeTimes.value.toString(),
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          color: kprimaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                      const SizedBox(height: 16),
                                      NumberPicker(
                                        value: controller.shakeTimes.value,
                                        minValue: 1,
                                        maxValue: 50,
                                        onChanged: (value) {
                                          Utils.hapticFeedback();
                                          controller.shakeTimes.value = value;
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
                              controller.shakeTimes.value = initialShakeTimes;
                              controller.isShakeEnabled.value = initialIsShakeEnabled;
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
          Row(
            children: [
              Expanded(
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
                  ],
                ),
              ),
              child,
            ],
          ),
        ],
      ),
    );
  }

}
