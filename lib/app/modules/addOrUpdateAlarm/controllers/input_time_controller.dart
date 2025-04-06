import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

class InputTimeController extends GetxController {
  SettingsController settingsController = Get.find<SettingsController>();

  final isTimePicker = false.obs;
  final isTimePickerTimer = false.obs;

  TextEditingController inputHrsController = TextEditingController();
  TextEditingController inputMinutesController = TextEditingController();

  TextEditingController inputHoursControllerTimer = TextEditingController();
  TextEditingController inputMinutesControllerTimer = TextEditingController();
  TextEditingController inputSecondsControllerTimer = TextEditingController();

  final selectedDateTime = DateTime.now().obs;
  bool isInputtingTime = false;


  int? _previousDisplayHour;


  void confirmTimeInput() {
    setTime();
    changeDatePicker();
  }

  @override
  void onInit() {
    isTimePicker.value = true;
    isTimePickerTimer.value = true;
    inputHoursControllerTimer.text = '0';
    inputMinutesControllerTimer.text = '1';
    inputSecondsControllerTimer.text = '0';
    super.onInit();
  }

  void initTimeTextField() {
    AddOrUpdateAlarmController addOrUpdateAlarmController = Get.find<AddOrUpdateAlarmController>();
    selectedDateTime.value = addOrUpdateAlarmController.selectedTime.value;

    isAM.value = addOrUpdateAlarmController.selectedTime.value.hour < 12;
    inputHrsController.text = settingsController.is24HrsEnabled.value
        ? selectedDateTime.value.hour.toString()
        : (selectedDateTime.value.hour == 0
            ? '12'
            : (selectedDateTime.value.hour > 12
                ? (selectedDateTime.value.hour - 12).toString()
                : selectedDateTime.value.hour.toString()));
    inputMinutesController.text = selectedDateTime.value.minute.toString().padLeft(2, '0');
  }


  final isAM = true.obs;


  void changePeriod(String period) {
    isAM.value = period == 'AM';
  }


  void changeDatePicker() {
    isTimePicker.value = !isTimePicker.value;

    if (isTimePicker.value) {
      initTimeTextField();
    }
  }


  void changeTimePickerTimer() {
    isTimePickerTimer.value = !isTimePickerTimer.value;
  }


  int convert24(int value, int meridiemIndex) {
    if (!settingsController.is24HrsEnabled.value) {
      if (meridiemIndex == 0) {
        if (value == 12) {
          value = value - 12;
        }
      } else {
        if (value != 12) {
          value = value + 12;
        }
      }
    }
    return value;
  }




  void toggleIfAtBoundary() {
    if (!settingsController.is24HrsEnabled.value) {
      final rawHourText = inputHrsController.text.trim();
      int newHour;
      try {
        newHour = int.parse(rawHourText);
      } catch (e) {
        debugPrint("toggleIfAtBoundary error parsing hour: $e");
        return;
      }

      if (newHour == 0) {
        newHour = 12;
      }
      debugPrint("toggleIfAtBoundary: previousDisplayHour = $_previousDisplayHour, newHour = $newHour");
      if (_previousDisplayHour != null) {
        if ((_previousDisplayHour == 11 && newHour == 12) ||
            (_previousDisplayHour == 12 && newHour == 11)) {
          isAM.value = !isAM.value;
          debugPrint("toggleIfAtBoundary: Toggled isAM to ${isAM.value}");
        }
      }
      _previousDisplayHour = newHour;
    }
  }


  void setTime() {
    AddOrUpdateAlarmController addOrUpdateAlarmController = Get.find<AddOrUpdateAlarmController>();
    selectedDateTime.value = addOrUpdateAlarmController.selectedTime.value;

    toggleIfAtBoundary();

    try {
      int hour = int.parse(inputHrsController.text);
      if (!settingsController.is24HrsEnabled.value) {
        if (isAM.value) {
          if (hour == 12) hour = 0; 
        } else {
          if (hour != 12) hour = hour + 12;
        }
      }

      int minute = int.parse(inputMinutesController.text);
      final time = TimeOfDay(hour: hour, minute: minute);
      DateTime today = DateTime.now();
      DateTime tomorrow = today.add(const Duration(days: 1));

      bool isNextDay = (time.hour == today.hour && time.minute < today.minute) || (time.hour < today.hour);
      bool isNextMonth = isNextDay && (today.day > tomorrow.day);
      bool isNextYear = isNextMonth && (today.month > tomorrow.month);
      int day = isNextDay ? tomorrow.day : today.day;
      int month = isNextMonth ? tomorrow.month : today.month;
      int year = isNextYear ? tomorrow.year : today.year;
      selectedDateTime.value = DateTime(year, month, day, time.hour, time.minute);
      addOrUpdateAlarmController.selectedTime.value = selectedDateTime.value;

      if (!settingsController.is24HrsEnabled.value) {
        if (selectedDateTime.value.hour == 0) {
          addOrUpdateAlarmController.hours.value = 12;
        } else if (selectedDateTime.value.hour > 12) {
          addOrUpdateAlarmController.hours.value = selectedDateTime.value.hour - 12;
        } else {
          addOrUpdateAlarmController.hours.value = selectedDateTime.value.hour;
        }
      } else {
        addOrUpdateAlarmController.hours.value =
            convert24(selectedDateTime.value.hour, addOrUpdateAlarmController.meridiemIndex.value);
      }
      addOrUpdateAlarmController.minutes.value = selectedDateTime.value.minute;
      if (selectedDateTime.value.hour >= 12) {
        addOrUpdateAlarmController.meridiemIndex.value = 1;
      } else {
        addOrUpdateAlarmController.meridiemIndex.value = 0;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  void setTimerTime() {
    TimerController timerController = Get.find<TimerController>();
    try {
      int hours = int.parse(inputHoursControllerTimer.text);
      int minutes = int.parse(inputMinutesControllerTimer.text);
      int seconds = int.parse(inputSecondsControllerTimer.text);
      timerController.hours.value = hours;
      timerController.minutes.value = minutes;
      timerController.seconds.value = seconds;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setTextFieldTimerTime() {
    TimerController timerController = Get.find<TimerController>();
    inputHoursControllerTimer.text = timerController.hours.value.toString();
    inputMinutesControllerTimer.text = timerController.minutes.value.toString();
    inputSecondsControllerTimer.text = timerController.seconds.value.toString();
  }

  @override
  void onClose() {
    inputHrsController.dispose();
    inputMinutesController.dispose();
    inputHoursControllerTimer.dispose();
    inputMinutesControllerTimer.dispose();
    inputSecondsControllerTimer.dispose();
    super.onClose();
  }
}

class LimitRange extends TextInputFormatter {
  LimitRange(this.minRange, this.maxRange) : assert(minRange < maxRange);
  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      if (newValue.text.isEmpty) {
        return newValue;
      }
      int value = int.parse(newValue.text);
      if (value < minRange) return TextEditingValue(text: minRange.toString());
      else if (value > maxRange) return TextEditingValue(text: maxRange.toString());
      return newValue;
    } catch (e) {
      debugPrint(e.toString());
      return newValue;
    }
  }
}
