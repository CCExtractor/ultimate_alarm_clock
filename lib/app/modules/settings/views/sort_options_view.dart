import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/sort_mode.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class SortOptionsView extends StatelessWidget {
  final SettingsController controller;
  final ThemeController themeController;
  final double height;
  final double width;

  const SortOptionsView({
    super.key,
    required this.controller,
    required this.themeController,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: width * 0.91,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: themeController.secondaryBackgroundColor.value,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort Options'.tr,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: themeController.primaryTextColor.value,
                    ),
              ),
              const SizedBox(height: 15),
              // Enable/Disable sorting switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enable Sorting'.tr,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: themeController.primaryTextColor.value,
                        ),
                  ),
                  Switch.adaptive(
                    value: controller.isSortedAlarmListEnabled.value,
                    activeColor: ksecondaryColor,
                    onChanged: (bool value) {
                      controller.toggleSortedAlarmList(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Sort Mode Dropdown
              if (controller.isSortedAlarmListEnabled.value) ...[
                Text(
                  'Sort By'.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: themeController.secondaryTextColor.value,
                      ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeController.primaryBackgroundColor.value,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AlarmSortMode>(
                      value: controller.currentSortMode.value,
                      isExpanded: true,
                      dropdownColor: themeController.primaryBackgroundColor.value,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      items: AlarmSortMode.values.map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(
                            mode.displayName,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: themeController.primaryTextColor.value,
                                ),
                          ),
                        );
                      }).toList(),
                      onChanged: (mode) {
                        if (mode != null) controller.updateSortMode(mode);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Sort Direction
                if (controller.currentSortMode.value != AlarmSortMode.customOrder) ...[
                  Text(
                    'Direction'.tr,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: themeController.secondaryTextColor.value,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeController.primaryBackgroundColor.value,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SortDirection>(
                        value: controller.currentSortDirection.value,
                        isExpanded: true,
                        dropdownColor: themeController.primaryBackgroundColor.value,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        items: SortDirection.values.map((direction) {
                          return DropdownMenuItem(
                            value: direction,
                            child: Text(
                              direction.displayName,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: themeController.primaryTextColor.value,
                                  ),
                            ),
                          );
                        }).toList(),
                        onChanged: (direction) {
                          if (direction != null) {
                            controller.updateSortDirection(direction);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
} 