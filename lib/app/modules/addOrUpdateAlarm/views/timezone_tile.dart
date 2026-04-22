import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/timezone_utils.dart';

class TimezoneTile extends StatelessWidget {
  const TimezoneTile({
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
          _showTimezoneDialog(context);
        },
        child: ListTile(
          leading: Icon(
            controller.isTimezoneEnabled.value ? Icons.access_time : Icons.access_time_outlined,
            color: controller.isTimezoneEnabled.value 
                ? kprimaryColor 
                : themeController.primaryDisabledTextColor.value,
          ),
          title: Text(
            'Timezone'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          subtitle: Text(
            controller.isTimezoneEnabled.value 
                ? _getTimezoneSubtitleText()
                : 'Local time'.tr,
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

  String _getTimezoneSubtitleText() {
    final selectedData = controller.getSelectedTimezoneData();
    if (selectedData != null) {
      return '${selectedData.displayName}';
    }
    return controller.selectedTimezoneId.value.isNotEmpty 
        ? controller.selectedTimezoneId.value 
        : 'Select timezone'.tr;
  }

  void _showTimezoneDialog(BuildContext context) {
    // Store original values
    bool originalEnabled = controller.isTimezoneEnabled.value;
    String originalTimezoneId = controller.selectedTimezoneId.value;
    int originalOffset = controller.targetTimezoneOffset.value;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                          'Timezone Settings'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: themeController.primaryTextColor.value,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Done'.tr,
                            style: TextStyle(
                              color: kprimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          // Enable/Disable Toggle
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            decoration: BoxDecoration(
                              color: themeController.primaryBackgroundColor.value,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Obx(
                              () => SwitchListTile(
                                title: Text(
                                  'Enable Timezone'.tr,
                                  style: TextStyle(
                                    color: themeController.primaryTextColor.value,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  'Convert your local time to selected timezone'.tr,
                                  style: TextStyle(
                                    color: themeController.primaryDisabledTextColor.value,
                                    fontSize: 13,
                                  ),
                                ),
                                value: controller.isTimezoneEnabled.value,
                                onChanged: (bool value) {
                                  controller.toggleTimezone(value);
                                },
                                activeColor: kprimaryColor,
                              ),
                            ),
                          ),

                          // Current Time Preview
                          Obx(() {
                            if (!controller.isTimezoneEnabled.value) return const SizedBox.shrink();
                            
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                                  Text(
                                    'Conversion Preview'.tr,
                                    style: TextStyle(
                                      color: themeController.primaryTextColor.value,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.getFormattedTimezoneTime(),
                                    style: TextStyle(
                                      color: themeController.primaryDisabledTextColor.value,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Time shown above is converted from your local time'.tr,
                                    style: TextStyle(
                                      color: themeController.primaryDisabledTextColor.value,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // Timezone Search
                          Obx(() {
                            if (!controller.isTimezoneEnabled.value) return const SizedBox.shrink();
                            
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              child: TextField(
                                onChanged: (query) => controller.searchTimezones(query),
                                decoration: InputDecoration(
                                  hintText: 'Search timezones...'.tr,
                                  hintStyle: TextStyle(
                                    color: themeController.primaryDisabledTextColor.value,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: themeController.primaryDisabledTextColor.value,
                                  ),
                                  filled: true,
                                  fillColor: themeController.primaryBackgroundColor.value,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                  color: themeController.primaryTextColor.value,
                                ),
                              ),
                            );
                          }),

                          // Timezone List
                          Obx(() {
                            if (!controller.isTimezoneEnabled.value) return const SizedBox.shrink();
                            
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: themeController.primaryBackgroundColor.value,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.filteredTimezoneList.length,
                                itemBuilder: (context, index) {
                                  final timezone = controller.filteredTimezoneList[index];
                                  final isSelected = controller.selectedTimezoneId.value == timezone.id;
                                  
                                  return ListTile(
                                    title: Text(
                                      timezone.displayName,
                                      style: TextStyle(
                                        color: isSelected 
                                            ? kprimaryColor 
                                            : themeController.primaryTextColor.value,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Text(
                                      timezone.formattedOffset,
                                      style: TextStyle(
                                        color: isSelected 
                                            ? kprimaryColor.withOpacity(0.7) 
                                            : themeController.primaryDisabledTextColor.value,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: isSelected 
                                        ? Icon(
                                            Icons.check,
                                            color: kprimaryColor,
                                          )
                                        : null,
                                    onTap: () {
                                      controller.selectTimezone(timezone.id);
                                    },
                                  );
                                },
                              ),
                            );
                          }),
                          
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // If user cancels without confirming, restore original values
      // This is handled by the Done button, but we keep this as backup
    });
  }
}