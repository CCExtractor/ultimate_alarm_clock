import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/isar_provider.dart';
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
    Timer.periodic(
        Duration(
            milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                DateTime.now().add(const Duration(minutes: 1)))), (timer) {
      formattedDate.value = Utils.getFormattedDate(DateTime.now());
      timeNow.value =
          Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now()));
    });

    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();

    AlarmModel isarLatestAlarm = await IsarDb.getLatestAlarm(_alarmRecord);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_alarmRecord);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);

    int intervaltoAlarm = Utils.getMillisecondsToAlarm(
        DateTime.now(), Utils.timeOfDayToDateTime(latestAlarmTimeOfDay));
    print("INTERVAL TO ALARM: ${intervaltoAlarm}");

    if (await FlutterForegroundTask.isRunningService == false) {
      // Starting service mandatorily!

      createForegroundTask(intervaltoAlarm);
      await startForegroundTask(latestAlarm);
    } else {
      await restartForegroundTask(latestAlarm, intervaltoAlarm);
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
