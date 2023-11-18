import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';

class InputTimeController extends GetxController {
  AddOrUpdateAlarmController addOrUpdateAlarmController =
      Get.find<AddOrUpdateAlarmController>();
  final isTimePicker = false.obs;
  TextEditingController inputHrsController = TextEditingController();
  TextEditingController inputMinutesController = TextEditingController();
  final selectedDateTime = DateTime.now().obs;
  @override
  void onInit() {
    isTimePicker.value = true;
    selectedDateTime.value = addOrUpdateAlarmController.selectedTime.value;
    isAM.value = addOrUpdateAlarmController.selectedTime.value.hour < 12;
    super.onInit();
  }

  final isAM = true.obs;
  changePeriod(String period) {
    isAM.value = period == 'AM';
  }

  changeDatePicker() {
    isTimePicker.value = !isTimePicker.value;
  }

  void setTime() {
    int hour = int.parse(inputHrsController.text);
    if (hour == 0 && inputHrsController.text.length == 2) {
      inputHrsController.text = '12';
    }

    if (isAM.value) {
      if (hour == 12) {
        hour = hour - 12;
      }
    } else {
      if (hour != 12) {
        hour = hour + 12;
      }
    }
    int minute = int.parse(inputMinutesController.text);
    final time = TimeOfDay(hour: hour, minute: minute);
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    bool isNextDay = (time.hour == today.hour && time.minute < today.minute) ||
        (time.hour < today.hour);
    bool isNextMonth = isNextDay && (today.day > tomorrow.day);
    bool isNextYear = isNextMonth && (today.month > tomorrow.month);
    int day = isNextDay ? tomorrow.day : today.day;
    int month = isNextMonth ? tomorrow.month : today.month;
    int year = isNextYear ? tomorrow.month : today.month;
    selectedDateTime.value = DateTime(year, month, day, time.hour, time.minute);
    addOrUpdateAlarmController.selectedTime.value = selectedDateTime.value;
  }

  @override
  void onClose() {
    inputHrsController.dispose();
    inputMinutesController.dispose();
    super.onClose();
  }
}

class LimitRange extends TextInputFormatter {
  LimitRange(
    this.minRange,
    this.maxRange,
  ) : assert(
          minRange < maxRange,
        );

  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = int.parse(newValue.text);
    if (value < minRange) {
      return TextEditingValue(text: minRange.toString());
    } else if (value > maxRange) {
      return TextEditingValue(text: maxRange.toString());
    }
    return newValue;
  }
}
