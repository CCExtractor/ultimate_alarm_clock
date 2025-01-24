import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'dart:math' show min;

Widget presetButton(BuildContext context, String label, Duration duration) {
  final TimerController timerController = Get.find<TimerController>();
  final ThemeController themeController = Get.find<ThemeController>();

  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  return Container(
    constraints: BoxConstraints(
      maxWidth: min(width * 0.25, 120),
    ),
    child: ElevatedButton(
      onPressed: () {
        timerController.remainingTime.value = duration;
        timerController.createTimer();
        Get.back();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: min(width * 0.02, 12.0),
          vertical: min(height * 0.01, 8.0),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(min(height * 0.02, 16.0)),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            fontSize: min(height * 0.02, 14.0),
            color: kprimaryDisabledTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
