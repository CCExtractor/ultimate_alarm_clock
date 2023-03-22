import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmControlController extends GetxController {
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;
  @override
  void onInit() {
    super.onInit();
    Timer.periodic(
        Duration(
            milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                DateTime.now().add(const Duration(minutes: 1)))), (timer) {
      formattedDate.value = Utils.getFormattedDate(DateTime.now());
      timeNow.value =
          Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now()))
              .obs;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
