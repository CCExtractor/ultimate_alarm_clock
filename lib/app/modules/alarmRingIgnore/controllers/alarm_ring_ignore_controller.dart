import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:app_minimizer/app_minimizer.dart';

class AlarmControlIgnoreController extends GetxController
    with AlarmHandlerSetupModel {
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;

  getNextAlarm() async {
    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, true);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_alarmRecord, true);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    print("LATEST : ${latestAlarm.alarmTime}");

    return latestAlarm;
  }

  @override
  void onInit() async {
    super.onInit();

    AlarmModel latestAlarm = await getNextAlarm();
    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);
// This condition will never satisfy because this will only occur if fake model is returned as latest alarm
    if (latestAlarm.isEnabled == false) {
      print(
          "STOPPED IF CONDITION with latest = ${latestAlarmTimeOfDay.toString()} ");
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

    FlutterAppMinimizer.minimize();
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
