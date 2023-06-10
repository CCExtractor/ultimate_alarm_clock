import 'dart:async';

import 'package:app_minimizer/app_minimizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmControlController extends GetxController
    with AlarmHandlerSetupModel {
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;
  @override
  void onInit() async {
    super.onInit();
    FlutterRingtonePlayer.playAlarm();
    TimeOfDay currentTime = TimeOfDay.now();

    Timer.periodic(
        Duration(
            milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                DateTime.now().add(const Duration(minutes: 1)))), (timer) {
      formattedDate.value = Utils.getFormattedDate(DateTime.now());
      timeNow.value =
          Utils.convertTo12HourFormat(Utils.timeOfDayToString(currentTime));
    });

    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();

    AlarmModel isarLatestAlarm = await IsarDb.getLatestAlarm(_alarmRecord);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_alarmRecord);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

    print("LATEST : ${latestAlarm.alarmTime}");

    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);

// This condition will never satisfy because this will only occur if fake model is returned as latest alarm
    if (latestAlarm.isEnabled == false) {
      print(
          "STOPPED IF CONDITION with latest = ${latestAlarmTimeOfDay.toString()} and current = ${currentTime.toString()}");
      await stopForegroundTask();
    } else {
      int intervaltoAlarm = Utils.getMillisecondsToAlarm(
          DateTime.now(), Utils.timeOfDayToDateTime(latestAlarmTimeOfDay));
      if (await FlutterForegroundTask.isRunningService == false) {
        createForegroundTask(intervaltoAlarm);
        await startForegroundTask(latestAlarm);
      } else {
        await restartForegroundTask(latestAlarm, intervaltoAlarm);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    FlutterRingtonePlayer.stop();
  }
}
