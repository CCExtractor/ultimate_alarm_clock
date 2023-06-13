import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class HomeController extends GetxController with AlarmHandlerSetupModel {
  Stream<QuerySnapshot>? firestoreStreamAlarms;
  Stream? isarStreamAlarms;
  Stream? streamAlarms;
  List<AlarmModel> latestFirestoreAlarms = [];
  List<AlarmModel> latestIsarAlarms = [];
  final alarmTime = 'No upcoming alarms!'.obs;
  bool refreshTimer = false;
  bool isEmpty = true;
  Timer _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {});
  List alarms = [].obs;
  int lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
  Timer? delayToSchedule;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel? userModel;

  loginWithGoogle() async {
    // Logging in again to ensure right details if User has linked account
    if (await SecureStorageProvider().retrieveUserModel() != null) {
      if (await _googleSignIn.isSignedIn()) {
        GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signInSilently();
        String fullName = googleSignInAccount!.displayName.toString();
        List<String> parts = fullName.split(" ");
        String lastName = " ";
        if (parts.length == 3) {
          if (parts[parts.length - 1].length == 1) {
            lastName = parts[1].toLowerCase().capitalizeFirst.toString();
          } else {
            lastName = parts[parts.length - 1]
                .toLowerCase()
                .capitalizeFirst
                .toString();
          }
        } else {
          lastName =
              parts[parts.length - 1].toLowerCase().capitalizeFirst.toString();
        }
        String firstName = parts[0].toLowerCase().capitalizeFirst.toString();

        userModel = UserModel(
          id: googleSignInAccount.id,
          fullName: fullName,
          firstName: firstName,
          lastName: lastName,
          email: googleSignInAccount.email,
        );
        await SecureStorageProvider().storeUserModel(userModel!);
      }
    }
  }

  initStream() async {
    await loginWithGoogle();
    firestoreStreamAlarms = FirestoreDb.getAlarms(userModel);
    isarStreamAlarms = IsarDb.getAlarms();

    streamAlarms =
        StreamGroup.merge([firestoreStreamAlarms!, isarStreamAlarms!])
            .map((data) {
      print(data.runtimeType);
      if (data is QuerySnapshot) {
        print('firestore gave');
        List<DocumentSnapshot> firestoreDocuments = data.docs;
        latestFirestoreAlarms = firestoreDocuments
            .map((DocumentSnapshot doc) =>
                AlarmModel.fromDocumentSnapshot(documentSnapshot: doc))
            .toList();
      } else {
        latestIsarAlarms = data as List<AlarmModel>;
      }

      List<AlarmModel> alarms = [...latestFirestoreAlarms, ...latestIsarAlarms];
      alarms.sort((a, b) {
        // First sort by isEnabled
        if (a.isEnabled != b.isEnabled) {
          return a.isEnabled ? -1 : 1;
        }

        // Then sort by upcoming time
        int aUpcomingTime = a.minutesSinceMidnight;
        int bUpcomingTime = b.minutesSinceMidnight;

        // Check if alarm repeats on any day
        bool aRepeats = a.days.any((day) => day);
        bool bRepeats = b.days.any((day) => day);

        // If alarm repeats on any day, find the next up+coming day
        if (aRepeats) {
          int currentDay = DateTime.now().weekday - 1;
          for (int i = 0; i < a.days.length; i++) {
            int dayIndex = (currentDay + i) % a.days.length;
            if (a.days[dayIndex]) {
              aUpcomingTime += i * Duration.minutesPerDay;
              break;
            }
          }
        } else {
          // If alarm is one-time and has already passed, set upcoming time to next day
          if (aUpcomingTime <=
              DateTime.now().hour * 60 + DateTime.now().minute) {
            aUpcomingTime += Duration.minutesPerDay;
          }
        }

        if (bRepeats) {
          int currentDay = DateTime.now().weekday - 1;
          for (int i = 0; i < b.days.length; i++) {
            int dayIndex = (currentDay + i) % b.days.length;
            if (b.days[dayIndex]) {
              bUpcomingTime += i * Duration.minutesPerDay;
              break;
            }
          }
        } else {
          // If alarm is one-time and has already passed, set upcoming time to next day
          if (bUpcomingTime <=
              DateTime.now().hour * 60 + DateTime.now().minute) {
            bUpcomingTime += Duration.minutesPerDay;
          }
        }

        return aUpcomingTime.compareTo(bUpcomingTime);
      });

      return alarms;
    });

    refreshUpcomingAlarms();
  }

  @override
  void onInit() {
    super.onInit();
  }

  refreshUpcomingAlarms() async {
    // Check if 2 seconds have passed since the last call
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - lastRefreshTime < 2000) {
      delayToSchedule?.cancel();
    }

    if (delayToSchedule != null && delayToSchedule!.isActive) {
      return;
    }

    delayToSchedule = Timer(const Duration(seconds: 2), () async {
      lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
      // Cancel timer if we have to refresh
      if (refreshTimer == true && _timer.isActive) {
        _timer.cancel();
        refreshTimer = false;
      }

      // Fake object to get latest alarm
      AlarmModel alarmRecord = Utils.genFakeAlarmModel();
      AlarmModel isarLatestAlarm =
          await IsarDb.getLatestAlarm(alarmRecord, true);

      AlarmModel firestoreLatestAlarm =
          await FirestoreDb.getLatestAlarm(userModel, alarmRecord, true);
      AlarmModel latestAlarm =
          Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

      print("ISAR: ${isarLatestAlarm.alarmTime}");
      print("Fire: ${firestoreLatestAlarm.alarmTime}");

      String timeToAlarm = Utils.timeUntilAlarm(
          Utils.stringToTimeOfDay(latestAlarm.alarmTime), latestAlarm.days);
      alarmTime.value = "Rings in $timeToAlarm";

// This function is necessary when alarms are deleted/enabled

      await scheduleNextAlarm(
          alarmRecord, isarLatestAlarm, firestoreLatestAlarm, latestAlarm);

      if (latestAlarm.minutesSinceMidnight > -1) {
        // Starting timer for live refresh
        _timer = Timer.periodic(
            Duration(
                milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                    DateTime.now().add(const Duration(minutes: 1)))), (timer) {
          timeToAlarm = Utils.timeUntilAlarm(
              Utils.stringToTimeOfDay(latestAlarm.alarmTime), latestAlarm.days);
          alarmTime.value = "Rings in $timeToAlarm";
        });
      } else {
        alarmTime.value = 'No upcoming alarms!';
      }
    });
  }

  scheduleNextAlarm(AlarmModel alarmRecord, AlarmModel isarLatestAlarm,
      AlarmModel firestoreLatestAlarm, AlarmModel latestAlarm) async {
    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);
    if (latestAlarm.isEnabled == false) {
      print(
          "STOPPED IF CONDITION with latest = ${latestAlarmTimeOfDay.toString()}");
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
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    delayToSchedule!.cancel();
  }
}
