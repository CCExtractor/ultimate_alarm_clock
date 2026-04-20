// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AscendingVolumeTile extends StatelessWidget {
  const AscendingVolumeTile({
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
          _showAscendingVolumeBottomSheet(context);
        },
        child: ListTile(
          leading: Icon(
            controller.gradient.value > 0 ? Icons.trending_up : Icons.volume_up,
            color: controller.gradient.value > 0 
                ? kprimaryColor 
                : themeController.primaryDisabledTextColor.value,
          ),
          title: Text(
            'Ascending Volume'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          subtitle: Text(
            controller.gradient.value > 0
                ? 'Volume ramps up over ${controller.gradient.value}s'.tr
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

  void _showAscendingVolumeBottomSheet(BuildContext context) {
    // Store original values for cancellation
    int originalGradient = controller.gradient.value;
    double originalGradientDouble = controller.selectedGradientDouble.value;
    double originalVolMin = controller.volMin.value;
    double originalVolMax = controller.volMax.value;

    // Fix: Ensure gradient values are always within valid range
    double _getValidGradientValue() {
      final currentValue = controller.selectedGradientDouble.value;
      if (currentValue < 5.0) return 30.0; // Default to 30 when invalid
      if (currentValue > 300.0) return 300.0;
      return currentValue;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.6,
          maxChildSize: 0.95,
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
                  // Drag Handle
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: themeController.primaryDisabledTextColor.value.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kprimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: kprimaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ascending Volume'.tr,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: themeController.primaryTextColor.value,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Gradually increase alarm volume'.tr,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: themeController.primaryDisabledTextColor.value,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Utils.hapticFeedback();
                            // Reset values if cancelled
                            controller.gradient.value = originalGradient;
                            controller.selectedGradientDouble.value = originalGradientDouble;
                            controller.volMin.value = originalVolMin;
                            controller.volMax.value = originalVolMax;
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: themeController.primaryDisabledTextColor.value,
                            size: 24,
                          ),
                          tooltip: 'Close'.tr,
                        ),
                      ],
                    ),
                  ),
                  
                  // Divider
                  Divider(
                    height: 1,
                    color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Feature Toggle Section
                          _buildSection(
                            context,
                            title: 'Settings'.tr,
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeController.primaryBackgroundColor.value,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: themeController.primaryDisabledTextColor.value.withOpacity(0.08),
                                  width: 1,
                                ),
                              ),
                              child: Obx(() => SwitchListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                title: Text(
                                  'Enable Ascending Volume'.tr,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: themeController.primaryTextColor.value,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Start quiet and gradually get louder'.tr,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: themeController.primaryDisabledTextColor.value,
                                    ),
                                  ),
                                ),
                                value: controller.gradient.value > 0,
                                onChanged: (value) {
                                  Utils.hapticFeedback();
                                  if (value) {
                                    // Enable with valid default value
                                    controller.gradient.value = 30;
                                    controller.selectedGradientDouble.value = 30.0;
                                  } else {
                                    // Disable - keep gradient at 0 but don't update selectedGradientDouble
                                    controller.gradient.value = 0;
                                    // Keep selectedGradientDouble at its last valid value for when re-enabled
                                  }
                                },
                                activeColor: kprimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              )),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Settings (only visible when enabled)
                          Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            child: controller.gradient.value > 0
                                ? Column(
                                    key: const ValueKey('settings_visible'),
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Duration Setting
                                      _buildSection(
                                        context,
                                        title: 'Duration'.tr,
                                        child: _buildSettingCard(
                                          context,
                                          icon: Icons.timer_outlined,
                                          iconColor: Colors.blue,
                                          title: 'Ramp Duration'.tr,
                                          subtitle: '${controller.gradient.value} seconds'.tr,
                                          description: 'How long to reach maximum volume'.tr,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Obx(() {
                                              // Fix: Always use valid value for slider
                                              final validValue = _getValidGradientValue();
                                              return Slider(
                                                value: validValue,
                                                onChanged: (double value) {
                                                  Utils.hapticFeedback();
                                                  controller.selectedGradientDouble.value = value;
                                                  controller.gradient.value = value.toInt();
                                                },
                                                min: 5.0,
                                                max: 300.0,
                                                divisions: 59,
                                                label: '${validValue.toInt()}s',
                                                activeColor: Colors.blue,
                                                inactiveColor: Colors.blue.withOpacity(0.2),
                                                semanticFormatterCallback: (double value) {
                                                  return '${value.round()} seconds';
                                                },
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Volume Range Setting
                                      _buildSection(
                                        context,
                                        title: 'Volume Levels'.tr,
                                        child: _buildSettingCard(
                                          context,
                                          icon: Icons.volume_up_outlined,
                                          iconColor: Colors.green,
                                          title: 'Volume Range'.tr,
                                          subtitle: '${(controller.volMin.value * 10).toInt()}% → ${(controller.volMax.value * 10).toInt()}%',
                                          description: 'Starting and maximum volume'.tr,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 12),
                                              Obx(() => RangeSlider(
                                                values: RangeValues(
                                                  controller.volMin.value,
                                                  controller.volMax.value,
                                                ),
                                                onChanged: (RangeValues values) {
                                                  Utils.hapticFeedback();
                                                  controller.volMin.value = values.start;
                                                  controller.volMax.value = values.end;
                                                },
                                                min: 0.0,
                                                max: 10.0,
                                                divisions: 10,
                                                labels: RangeLabels(
                                                  '${(controller.volMin.value * 10).toInt()}%',
                                                  '${(controller.volMax.value * 10).toInt()}%',
                                                ),
                                                activeColor: Colors.green,
                                                inactiveColor: Colors.green.withOpacity(0.2),
                                              )),
                                              
                                              const SizedBox(height: 8),
                                              
                                              // Volume indicators
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    _buildVolumeIndicator(
                                                      context,
                                                      icon: Icons.volume_mute,
                                                      label: 'Start'.tr,
                                                      value: '${(controller.volMin.value * 10).toInt()}%',
                                                    ),
                                                    _buildVolumeIndicator(
                                                      context,
                                                      icon: Icons.volume_up,
                                                      label: 'Max'.tr,
                                                      value: '${(controller.volMax.value * 10).toInt()}%',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      // Preview Section
                                      _buildPreviewSection(context),
                                    ],
                                  )
                                : Container(
                                    key: const ValueKey('settings_hidden'),
                                    padding: const EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.volume_off_outlined,
                                            size: 48,
                                            color: themeController.primaryDisabledTextColor.value,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Ascending volume is disabled'.tr,
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: themeController.primaryDisabledTextColor.value,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Enable it to configure volume settings'.tr,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: themeController.primaryDisabledTextColor.value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          )),
                          
                          // Bottom spacing for scroll
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action Buttons
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      16,
                      24,
                      24 + MediaQuery.of(context).padding.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: themeController.secondaryBackgroundColor.value,
                      border: Border(
                        top: BorderSide(
                          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
                          width: 1,
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
                              controller.gradient.value = originalGradient;
                              controller.selectedGradientDouble.value = originalGradientDouble;
                              controller.volMin.value = originalVolMin;
                              controller.volMax.value = originalVolMax;
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: BorderSide(
                                color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Cancel'.tr,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: themeController.primaryTextColor.value,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Apply Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              'Apply'.tr,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: themeController.primaryTextColor.value,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeController.primaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeController.primaryDisabledTextColor.value.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (iconColor ?? kprimaryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? kprimaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: themeController.primaryTextColor.value,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: iconColor ?? kprimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: themeController.primaryDisabledTextColor.value,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildVolumeIndicator(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeController.secondaryBackgroundColor.value,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: themeController.primaryTextColor.value,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: themeController.primaryDisabledTextColor.value,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: themeController.primaryTextColor.value,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kprimaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kprimaryColor.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kprimaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.info_outline,
              color: kprimaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeController.primaryTextColor.value,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  'Volume will ramp from ${(controller.volMin.value * 10).toInt()}% to ${(controller.volMax.value * 10).toInt()}% over ${controller.gradient.value} seconds.'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeController.primaryTextColor.value.withOpacity(0.8),
                    height: 1.4,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
