import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AlarmControlIgnoreController extends GetxController {
  MethodChannel alarmChannel = MethodChannel('ulticlock');

  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;
  final Rx<AlarmModel> currentlyRingingAlarm = Utils.genFakeAlarmModel().obs;
  getCurrentlyRingingAlarm() async {
    UserModel? _userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, false);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_userModel, _alarmRecord, false);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    debugPrint('CURRENT RINGING : ${latestAlarm.alarmTime}');

    return latestAlarm;
  }

  getNextAlarm() async {
    UserModel? _userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, true);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_userModel, _alarmRecord, true);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    debugPrint('LATEST : ${latestAlarm.alarmTime}');

    return latestAlarm;
  }

  @override
  void onInit() async {
    super.onInit();

    currentlyRingingAlarm.value = await getCurrentlyRingingAlarm();
    // If the alarm is set to NEVER repeat, then it will be chosen as
    // the next alarm to ring by default as it would ring the next day
    if (currentlyRingingAlarm.value.days.every((element) => element == false)) {
      currentlyRingingAlarm.value.isEnabled = false;

      if (currentlyRingingAlarm.value.isSharedAlarmEnabled == false) {
        IsarDb.updateAlarm(currentlyRingingAlarm.value);
      } else {
        FirestoreDb.updateAlarm(
          currentlyRingingAlarm.value.ownerId,
          currentlyRingingAlarm.value,
        );
      }
    } else if (currentlyRingingAlarm.value.isOneTime == true) {
      // If the alarm has to repeat on one day, but ring just once,
      // we will keep seting its days to false until it will never ring
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
          currentlyRingingAlarm.value.ownerId,
          currentlyRingingAlarm.value,
        );
      }
    }

    AlarmModel latestAlarm = await getNextAlarm();

    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);
// This condition will never satisfy because this will only occur if fake mode
// is returned as latest alarm
    if (latestAlarm.isEnabled == false) {
      debugPrint('STOPPED IF CONDITION with latest = '
          '${latestAlarmTimeOfDay.toString()} and ');
      await alarmChannel.invokeMethod('cancelAllScheduledAlarms');
    } else {
      int intervaltoAlarm = Utils.getMillisecondsToAlarm(
        DateTime.now(),
        Utils.timeOfDayToDateTime(latestAlarmTimeOfDay),
      );

      try {
        await alarmChannel
            .invokeMethod('scheduleAlarm', {'milliSeconds': intervaltoAlarm});
        print("Scheduled...");
      } on PlatformException catch (e) {
        print("Failed to schedule alarm: ${e.message}");
      }
    }

    FlutterAppMinimizer.minimize();
  }
}
