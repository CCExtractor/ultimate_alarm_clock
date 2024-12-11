import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

Widget presetButton(BuildContext context, String label, Duration duration) {
  final TimerController timerController = Get.find<TimerController>();
  return ElevatedButton(
    onPressed: () {
      timerController.remainingTime.value = duration;
      timerController.createTimer();
    },
    
    style: ElevatedButton.styleFrom(
      
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      backgroundColor: kprimaryColor,
      fixedSize: const Size(160, 70), 
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50), 
      ),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: ksecondaryBackgroundColor, 
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
