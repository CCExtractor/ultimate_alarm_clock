import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';

import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmControlController extends GetxController
    with AlarmHandlerSetupModel {
  late StreamSubscription<FGBGType> _subscription;
  TimeOfDay currentTime = TimeOfDay.now();
  late RxBool isSnoozing = false.obs;
  RxInt minutes = 1.obs;
  RxInt seconds = 0.obs;
  final Rx<AlarmModel> currentlyRingingAlarm = Utils.genFakeAlarmModel().obs;
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;
  Timer? _currentTimeTimer;

  getCurrentlyRingingAlarm() async {
    UserModel? _userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, false);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_userModel, _alarmRecord, false);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    print("CURRENT RINGING : ${latestAlarm.alarmTime}");

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
    print("LATEST : ${latestAlarm.alarmTime}");

    return latestAlarm;
  }

  void startSnooze() {
    isSnoozing.value = true;
    FlutterRingtonePlayer.stop();

    if (_currentTimeTimer!.isActive) {
      _currentTimeTimer?.cancel();
    }

    _currentTimeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel();
        FlutterRingtonePlayer.playAlarm();
        startTimer();
      } else if (seconds.value == 0) {
        minutes.value--;
        seconds.value = 59;
      } else {
        seconds.value--;
      }
    });
  }

  void startTimer() {
    minutes.value = currentlyRingingAlarm.value.snoozeDuration;
    isSnoozing.value = false;
    _currentTimeTimer = Timer.periodic(
        Duration(
            milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                DateTime.now().add(const Duration(minutes: 1)))), (timer) {
      formattedDate.value = Utils.getFormattedDate(DateTime.now());
      timeNow.value =
          Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now()));
    });
  }

  @override
  void onInit() async {
    super.onInit();

    FlutterRingtonePlayer.playAlarm();

    // Preventing app from being minimized!
    _subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        FlutterForegroundTask.launchApp();
      }
    });

    startTimer();
    if (Get.arguments == null) {
      currentlyRingingAlarm.value = await getCurrentlyRingingAlarm();
    } else {
      currentlyRingingAlarm.value = Get.arguments;
    }

    // Setting snooze duration
    minutes.value = currentlyRingingAlarm.value.snoozeDuration;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
    // Scheduling next alarm if it's not in preview mode
//     if (Get.arguments == null) {
//       AlarmModel latestAlarm = await getNextAlarm();

//       TimeOfDay latestAlarmTimeOfDay =
//           Utils.stringToTimeOfDay(latestAlarm.alarmTime);
// // This condition will never satisfy because this will only occur if fake model is returned as latest alarm
//       if (latestAlarm.isEnabled == false) {
//         print(
//             "STOPPED IF CONDITION with latest = ${latestAlarmTimeOfDay.toString()} and current = ${currentTime.toString()}");
//         await stopForegroundTask();
//       } else {
//         int intervaltoAlarm = Utils.getMillisecondsToAlarm(
//             DateTime.now(), Utils.timeOfDayToDateTime(latestAlarmTimeOfDay));
//         if (await FlutterForegroundTask.isRunningService == false) {
//           createForegroundTask(intervaltoAlarm);
//           await startForegroundTask(latestAlarm);
//         } else {
//           await restartForegroundTask(latestAlarm, intervaltoAlarm);
//         }
//       }
//     }
    await FlutterRingtonePlayer.stop();
    _subscription.cancel();
    _currentTimeTimer?.cancel();
  }
}
