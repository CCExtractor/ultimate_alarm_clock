import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SmartControlCombinationTile extends StatelessWidget {
  const SmartControlCombinationTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Only show this tile if multiple smart controls are enabled
      int enabledSmartControls = 0;
      if (controller.isActivityenabled.value) enabledSmartControls++;
      if (controller.isLocationEnabled.value) enabledSmartControls++;
      if (controller.isWeatherEnabled.value) enabledSmartControls++;

      if (enabledSmartControls < 2) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 10.0,
          top: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Control Combination',
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose how multiple smart controls work together',
                        style: TextStyle(
                          color: themeController.primaryDisabledTextColor.value,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCombinationOption(
                  context,
                  SmartControlCombinationType.and,
                  'ALL must pass',
                  'All conditions required',
                  Icons.all_inclusive,
                ),
                const SizedBox(width: 16),
                _buildCombinationOption(
                  context,
                  SmartControlCombinationType.or,
                  'ANY can pass',
                  'Any condition works',
                  Icons.alt_route,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCombinationOption(
    BuildContext context,
    SmartControlCombinationType type,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = controller.smartControlCombinationType.value == type.index;
    
    return GestureDetector(
      onTap: () {
        controller.setSmartControlCombinationType(type);
        Utils.hapticFeedback();
      },
      child: Container(
        width: 120,
        height: 95,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? kprimaryColor.withOpacity(0.2)
              : themeController.secondaryBackgroundColor.value,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected 
                ? kprimaryColor
                : themeController.primaryDisabledTextColor.value
                    .withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected 
                  ? kprimaryColor
                  : themeController.primaryDisabledTextColor.value,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected 
                    ? kprimaryColor
                    : themeController.primaryTextColor.value,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: TextStyle(
                color: themeController.primaryDisabledTextColor.value,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}