import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:app_minimizer/app_minimizer.dart';

class AlarmControlIgnoreController extends GetxController
    with AlarmHandlerSetupModel {
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;
  final Rx<AlarmModel> currentlyRingingAlarm = Utils.genFakeAlarmModel().obs;
  getCurrentlyRingingAlarm() async {
    UserModel? userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(alarmRecord, false);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(userModel, alarmRecord, false);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    print("CURRENT RINGING : ${latestAlarm.alarmTime}");

    return latestAlarm;
  }

  getNextAlarm() async {
    UserModel? userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(alarmRecord, true);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(userModel, alarmRecord, true);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    print("LATEST : ${latestAlarm.alarmTime}");

    return latestAlarm;
  }

  @override
  void onInit() async {
    super.onInit();

    currentlyRingingAlarm.value = await getCurrentlyRingingAlarm();
    // If the alarm is set to NEVER repeat, then it will be chosen as the next alarm to ring by default as it would ring the next day
    if (currentlyRingingAlarm.value.days.every((element) => element == false)) {
      currentlyRingingAlarm.value.isEnabled = false;

      if (currentlyRingingAlarm.value.isSharedAlarmEnabled == false) {
        IsarDb.updateAlarm(currentlyRingingAlarm.value);
      } else {
        FirestoreDb.updateAlarm(
            currentlyRingingAlarm.value.ownerId, currentlyRingingAlarm.value);
      }
    } else if (currentlyRingingAlarm.value.isOneTime == true) {
      // If the alarm has to repeat on one day, but ring just once, we will keep seting its days to false until it will never ring
      int currentDay = DateTime.now().weekday - 1;
      currentlyRingingAlarm.value.days[currentDay] = false;

      if (currentlyRingingAlarm.value.days
          .every((element) => element == false)) {
        currentlyRingingAlarm.value.isEnabled = false;
      }

      if (currentlyRingingAlarm.value.isSharedAlarmEnabled == false) {
        IsarDb.updateAlarm(currentlyRingingAlarm.value);
      } else {
        FirestoreDb.updateAlarm(
            currentlyRingingAlarm.value.ownerId, currentlyRingingAlarm.value);
      }
    }

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


}
