import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

class TimerInputTimeController extends GetxController {
  TimerController timerController = Get.find<TimerController>();
  SettingsController settingsController = Get.find<SettingsController>();
  
  final isTimePickerTimer = false.obs;
  TextEditingController inputHoursControllerTimer = TextEditingController();
  TextEditingController inputMinutesControllerTimer = TextEditingController();
  TextEditingController inputSecondsControllerTimer = TextEditingController();
  bool isInputtingTime = false;

  @override
  void onInit() {
    isTimePickerTimer.value = true;
    inputHoursControllerTimer.text = timerController.hours.value.toString();
    inputMinutesControllerTimer.text = timerController.minutes.value.toString();
    inputSecondsControllerTimer.text = timerController.seconds.value.toString();
    super.onInit();
  }

  changeTimePickerTimer() {
    isTimePickerTimer.value = !isTimePickerTimer.value;
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

      inputHoursControllerTimer.text = hours;
      inputMinutesControllerTimer.text = minutes;
      inputSecondsControllerTimer.text = seconds;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() {
    inputHoursControllerTimer.dispose();
    inputMinutesControllerTimer.dispose();
    inputSecondsControllerTimer.dispose();
    super.onClose();
  }
}
