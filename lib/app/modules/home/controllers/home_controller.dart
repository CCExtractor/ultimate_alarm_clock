import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/main.dart';

class HomeController extends GetxController {
  late Stream<QuerySnapshot> firestoreStreamAlarms;
  late Stream isarStreamAlarms;
  late Stream streamAlarms;
  final alarmTime = 'No upcoming alarms!'.obs;
  bool refreshTimer = false;
  bool isEmpty = true;
  Timer? _timer;
  @override
  void onInit() async {
    super.onInit();
    firestoreStreamAlarms = FirestoreDb.getAlarms();
    isarStreamAlarms = FirestoreDb.getAlarms();
    streamAlarms = StreamZip([firestoreStreamAlarms, isarStreamAlarms])
        .asyncMap((List<dynamic> data) async {
      QuerySnapshot querySnapshot = data[0] as QuerySnapshot;
      List<DocumentSnapshot> firestoreDocuments = querySnapshot.docs;
      List firestoreAlarms = firestoreDocuments
          .map((DocumentSnapshot doc) =>
              AlarmModel.fromDocumentSnapshot(documentSnapshot: doc))
          .toList();

      List<AlarmModel> isarAlarms = await IsarDb.getAlarms();

      List<AlarmModel> alarms = [...firestoreAlarms, ...isarAlarms];
      alarms.sort((a, b) {
        // Compare the isEnabled property for each alarm
        int enabledComparison =
            a.isEnabled == b.isEnabled ? 0 : (a.isEnabled ? -1 : 1);
        if (enabledComparison != 0) {
          return enabledComparison;
        }

        // Get the current time
        final now = DateTime.now();
        final currentTimeInMinutes = now.hour * 60 + now.minute;
        final currentDay = now.weekday - 1; // Monday is 0

        // Calculate the time until the next occurrence of each alarm
        num timeUntilNextOccurrence(AlarmModel alarm) {
          // Check if the alarm can never repeat
          if (alarm.days.every((day) => !day)) {
            int timeUntilNextAlarm =
                alarm.minutesSinceMidnight - currentTimeInMinutes;
            return timeUntilNextAlarm < 0
                ? double.infinity
                : timeUntilNextAlarm;
          }

          // Check if the alarm repeats every day
          if (alarm.days.every((day) => day)) {
            int timeUntilNextAlarm =
                alarm.minutesSinceMidnight - currentTimeInMinutes;
            return timeUntilNextAlarm < 0
                ? timeUntilNextAlarm + 24 * 60
                : timeUntilNextAlarm;
          }

          // Calculate the time until the next occurrence for repeatable alarms
          int dayDifference =
              alarm.days.indexWhere((day) => day, currentDay) - currentDay;
          if (dayDifference < 0) {
            dayDifference += 7;
          }
          int timeUntilNextDay = dayDifference * 24 * 60;
          int timeUntilNextAlarm =
              alarm.minutesSinceMidnight - currentTimeInMinutes;
          if (timeUntilNextAlarm < 0) {
            timeUntilNextAlarm += 24 * 60;
            timeUntilNextDay += 24 * 60;
          }
          return timeUntilNextDay + timeUntilNextAlarm;
        }

        // Compare the time until the next occurrence for each alarm
        int arrivalComparison =
            timeUntilNextOccurrence(a).compareTo(timeUntilNextOccurrence(b));
        return arrivalComparison;
      });
      return alarms;
    });
  }

  @override
  void onReady() async {
    super.onReady();
    // Cancel timer if we have to refresh
    if (refreshTimer == true && isEmpty == false) {
      _timer!.cancel();
      refreshTimer = false;
    }
    // Fake object to get latest alarm
    AlarmModel alarmRecord = AlarmModel(
        days: [],
        isEnabled: false,
        isActivityEnabled: false,
        isLocationEnabled: false,
        isSharedAlarmEnabled: false,
        intervalToAlarm: 0,
        location: '',
        alarmTime: Utils.timeOfDayToString(TimeOfDay.now()),
        minutesSinceMidnight: Utils.timeOfDayToInt(TimeOfDay.now()));

    AlarmModel latestAlarm = await FirestoreDb.getLatestAlarm(alarmRecord);
    String timeToAlarm =
        Utils.timeUntilAlarm(Utils.stringToTimeOfDay(latestAlarm.alarmTime));
    alarmTime.value = "Rings in $timeToAlarm";
    if (latestAlarm.minutesSinceMidnight != alarmRecord.minutesSinceMidnight) {
      isEmpty = false;
      // Starting timer for live refresh
      _timer = Timer.periodic(
          Duration(
              milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                  DateTime.now().add(const Duration(minutes: 1)))), (timer) {
        timeToAlarm = Utils.timeUntilAlarm(
            Utils.stringToTimeOfDay(latestAlarm.alarmTime));
        alarmTime.value = "Rings in $timeToAlarm";
      });
    } else {
      alarmTime.value = 'No upcoming alarms!';
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
