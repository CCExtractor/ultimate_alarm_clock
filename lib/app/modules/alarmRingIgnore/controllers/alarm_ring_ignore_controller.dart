import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:app_minimizer/app_minimizer.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class AlarmControlIgnoreController extends GetxController
    with AlarmHandlerSetupModel {
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;
  @override
  void onInit() async {
    super.onInit();
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

    if (await FlutterForegroundTask.isRunningService == false) {
      // Starting service mandatorily!

      createForegroundTask(intervaltoAlarm);
      await startForegroundTask(latestAlarm);
    } else {
      await restartForegroundTask(latestAlarm, intervaltoAlarm);
    }
    FlutterAppMinimizer.minimize();

    FGBGType status = await FGBGEvents.stream.first;

    if (status == FGBGType.foreground) {
      Get.offNamed('/home');
    }
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
