import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

class InputTimeController extends GetxController {
  AddOrUpdateAlarmController addOrUpdateAlarmController =
      Get.find<AddOrUpdateAlarmController>();
  TimerController timerController = Get.find<TimerController>();
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

  void confirmTimeInput() {
    setTime();
    changeDatePicker();
  }

  @override
  void onInit() {
    isTimePicker.value = true;
    isTimePickerTimer.value = true;
    selectedDateTime.value = addOrUpdateAlarmController.selectedTime.value;
    isAM.value = addOrUpdateAlarmController.selectedTime.value.hour < 12;
    inputHrsController.text = settingsController.is24HrsEnabled.value
        ? selectedDateTime.value.hour.toString()
        : (selectedDateTime.value.hour == 0
            ? 12.toString()
            : (selectedDateTime.value.hour > 12
                ? (selectedDateTime.value.hour - 12).toString()
                : selectedDateTime.value.hour.toString()));
    inputMinutesController.text = selectedDateTime.value.minute.toString();
    inputHoursControllerTimer.text = timerController.hours.value.toString();
    inputMinutesControllerTimer.text = timerController.minutes.value.toString();
    inputSecondsControllerTimer.text = timerController.seconds.value.toString();
    super.onInit();
  }

  final isAM = true.obs;
  changePeriod(String period) {
    isAM.value = period == 'AM';
  }

  changeDatePicker() {
    isTimePicker.value = !isTimePicker.value;
  }

  changeTimePickerTimer() {
    isTimePickerTimer.value = !isTimePickerTimer.value;
  }

  int convert24(int value) {
    if (!settingsController.is24HrsEnabled.value) {
      if (addOrUpdateAlarmController.meridiemIndex == 0) {
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

  void setTime() {
    try {
      int hour = int.parse(inputHrsController.text);
      if (!settingsController.is24HrsEnabled.value) {
        if (isAM.value) {
          if (hour == 12) {
            hour = hour - 12;
          }
        } else {
          if (hour != 12) {
            hour = hour + 12;
          }
        }
      }

      int minute = int.parse(inputMinutesController.text);
      final time = TimeOfDay(hour: hour, minute: minute);
      DateTime today = DateTime.now();
      DateTime tomorrow = today.add(const Duration(days: 1));
      bool isNextDay =
          (time.hour == today.hour && time.minute < today.minute) ||
              (time.hour < today.hour);
      bool isNextMonth = isNextDay && (today.day > tomorrow.day);
      bool isNextYear = isNextMonth && (today.month > tomorrow.month);
      int day = isNextDay ? tomorrow.day : today.day;
      int month = isNextMonth ? tomorrow.month : today.month;
      int year = isNextYear ? tomorrow.month : today.month;
      selectedDateTime.value =
          DateTime(year, month, day, time.hour, time.minute);
      addOrUpdateAlarmController.selectedTime.value = selectedDateTime.value;

      if (!settingsController.is24HrsEnabled.value) {
        if (selectedDateTime.value.hour == 0) {
          addOrUpdateAlarmController.hours.value = 12;
        } else if (selectedDateTime.value.hour > 12) {
          addOrUpdateAlarmController.hours.value =
              (selectedDateTime.value.hour - 12);
        } else {
          addOrUpdateAlarmController.hours.value = selectedDateTime.value.hour;
        }
      } else {
        addOrUpdateAlarmController.hours.value =
            convert24(selectedDateTime.value.hour);
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
    try {
      String hours = timerController.hours.value.toString();
      String minutes = timerController.minutes.value.toString();
      String seconds = timerController.seconds.value.toString();

      inputHoursControllerTimer.text = hours ;
      inputMinutesControllerTimer.text=minutes;
      inputSecondsControllerTimer.text = seconds ;
    } catch (e) {
      debugPrint(e.toString());
    }
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
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      var value = int.parse(newValue.text);
      if (value < minRange) {
        return TextEditingValue(text: minRange.toString());
      } else if (value > maxRange) {
        return TextEditingValue(text: maxRange.toString());
      }
      return newValue;
    } catch (e) {
      debugPrint(e.toString());
      return newValue;
    }
  }
}
