import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../settings/controllers/theme_controller.dart';
import '../controllers/add_or_update_alarm_controller.dart';

class SchedulingOptionsTile extends StatelessWidget {
  const SchedulingOptionsTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Schedule Alarm",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeController.primaryTextColor.value,
            ),
          ),
        ),
        
        Container(
          decoration: BoxDecoration(
            color: themeController.secondaryBackgroundColor.value,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (controller.repeatDays.any((day) => day)) {
                      final List<bool> oldRepeatDays = List<bool>.from(controller.repeatDays);
                      final bool oldIsDailySelected = controller.isDailySelected.value;
                      final bool oldIsWeekdaysSelected = controller.isWeekdaysSelected.value;
                      final bool oldIsCustomSelected = controller.isCustomSelected.value;
                      
                      for (int i = 0; i < controller.repeatDays.length; i++) {
                        controller.repeatDays[i] = false;
                      }
                      
                      
                      controller.isDailySelected.value = false;
                      controller.isWeekdaysSelected.value = false;
                      controller.isCustomSelected.value = false;
                      
                      Get.snackbar(
                        'Repeat Pattern Disabled',
                        'Switching to one-time scheduling',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 4),
                        mainButton: TextButton(
                          child: const Text('UNDO', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            for (int i = 0; i < controller.repeatDays.length; i++) {
                              controller.repeatDays[i] = oldRepeatDays[i];
                            }
                            controller.isDailySelected.value = oldIsDailySelected;
                            controller.isWeekdaysSelected.value = oldIsWeekdaysSelected;
                            controller.isCustomSelected.value = oldIsCustomSelected;
                            controller.isFutureDate.value = false;
                          },
                        ),
                      );
                    }
                    
                    controller.isFutureDate.value = true;
                    controller.datePicker(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.isFutureDate.value
                          ? kprimaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "One-time",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: controller.isFutureDate.value
                            ? Colors.black
                            : themeController.primaryTextColor.value,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (controller.isFutureDate.value) {
                      final bool oldIsFutureDate = controller.isFutureDate.value;
                      final DateTime oldSelectedDate = controller.selectedDate.value;
                      
                      
                      controller.isFutureDate.value = false;
                      
                      
                      Get.snackbar(
                        'One-time Schedule Disabled',
                        'Switching to recurring scheduling',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 4),
                        mainButton: TextButton(
                          child: const Text('UNDO', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            
                            controller.isFutureDate.value = oldIsFutureDate;
                            controller.selectedDate.value = oldSelectedDate;
                            
                            
                            for (int i = 0; i < controller.repeatDays.length; i++) {
                              controller.repeatDays[i] = false;
                            }
                            controller.isDailySelected.value = false;
                            controller.isWeekdaysSelected.value = false;
                            controller.isCustomSelected.value = false;
                          },
                        ),
                      );
                    }
                    
                    
                    if (!controller.repeatDays.any((day) => day)) {
                      controller.setIsWeekdaysSelected(true);
                    }
                    
                    
                    _showRepeatOptions(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.repeatDays.any((day) => day)
                          ? kprimaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Recurring",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: controller.repeatDays.any((day) => day)
                            ? Colors.black
                            : themeController.primaryTextColor.value,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        controller.isFutureDate.value
            ? _buildOneTimeContent(context)
            : _buildRecurringContent(context),
            
        const SizedBox(height: 8),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: themeController.primaryDisabledTextColor.value,
              ),
              const SizedBox(width: 8),
              Obx(() => Text(
                "Rings in: ${controller.timeToAlarm}",
                style: TextStyle(
                  fontSize: 12,
                  color: themeController.primaryDisabledTextColor.value,
                ),
              )),
            ],
          ),
        ),
      ],
    ));
  }
  
  Widget _buildOneTimeContent(BuildContext context) {
    return ListTile(
      onTap: () => controller.datePicker(context),
      title: Text(
        "Date",
        style: TextStyle(
          color: themeController.primaryTextColor.value,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.selectedDate.value.toString().substring(0, 11),
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: themeController.primaryTextColor.value,
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecurringContent(BuildContext context) {
    return ListTile(
      title: Text(
        "Pattern",
        style: TextStyle(
          color: themeController.primaryTextColor.value,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.daysRepeating.value,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: themeController.primaryTextColor.value,
          ),
        ],
      ),
      onTap: () => _showRepeatOptions(context),
    );
  }
  
  void _showRepeatOptions(BuildContext context) {
    List<bool> repeatDays = List<bool>.filled(7, false);
    
    Get.bottomSheet(
      BottomSheet(
        onClosing: () {},
        backgroundColor: themeController.secondaryBackgroundColor.value,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Repeat Pattern",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                ),
                Divider(color: themeController.primaryDisabledTextColor.value),
                _buildPatternOption(
                  "Daily",
                  controller.isDailySelected,
                  (value) {
                    Utils.hapticFeedback();
                    controller.setIsDailySelected(value);
                    for (int i = 0; i < controller.repeatDays.length; i++) {
                      controller.repeatDays[i] = value;
                    }
                  },
                ),
                Divider(color: themeController.primaryDisabledTextColor.value),
                _buildPatternOption(
                  "Weekdays",
                  controller.isWeekdaysSelected,
                  (value) {
                    Utils.hapticFeedback();
                    controller.setIsWeekdaysSelected(value);
                    for (int i = 0; i < controller.repeatDays.length; i++) {
                      controller.repeatDays[i] = value && i >= 0 && i <= 4;
                    }
                  },
                ),
                Divider(color: themeController.primaryDisabledTextColor.value),
                _buildPatternOption(
                  "Custom",
                  controller.isCustomSelected,
                  (value) {
                    Utils.hapticFeedback();
                    controller.setIsCustomSelected(value);
                    if (value) {
                      // Show day picker dialog
                      Get.back();
                      _showDayPickerDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      "Done", 
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPatternOption(String title, RxBool value, Function(bool) onChanged) {
    return Obx(() => ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: themeController.primaryTextColor.value,
        ),
      ),
      trailing: Checkbox(
        value: value.value,
        activeColor: kprimaryColor,
        onChanged: (val) => onChanged(val!),
      ),
      onTap: () => onChanged(!value.value),
    ));
  }
  
  void _showDayPickerDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: themeController.secondaryBackgroundColor.value,
        title: Text(
          "Select Days",
          style: TextStyle(
            color: themeController.primaryTextColor.value,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDayCheckbox(0, "Monday"),
              _buildDayCheckbox(1, "Tuesday"),
              _buildDayCheckbox(2, "Wednesday"),
              _buildDayCheckbox(3, "Thursday"),
              _buildDayCheckbox(4, "Friday"),
              _buildDayCheckbox(5, "Saturday"),
              _buildDayCheckbox(6, "Sunday"),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Done", style: TextStyle(color: kprimaryColor)),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDayCheckbox(int dayIndex, String dayName) {
    return Obx(() => CheckboxListTile(
      title: Text(
        dayName,
        style: TextStyle(
          color: themeController.primaryTextColor.value,
        ),
      ),
      value: controller.repeatDays[dayIndex],
      activeColor: kprimaryColor,
      onChanged: (bool? value) {
        Utils.hapticFeedback();
        controller.repeatDays[dayIndex] = value!;
      },
    ));
  }
} 