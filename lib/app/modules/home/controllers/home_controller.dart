import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/main.dart';

class HomeController extends GetxController {
  late Stream<QuerySnapshot> firestoreStreamAlarms;
  late Stream isarStreamAlarms;
  late Stream streamAlarms;
  List<AlarmModel> latestFirestoreAlarms = [];
  List<AlarmModel> latestIsarAlarms = [];
  final alarmTime = 'No upcoming alarms!'.obs;
  bool refreshTimer = false;
  bool isEmpty = true;
  Timer _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {});
  List alarms = [].obs;
  @override
  void onInit() async {
    super.onInit();
    firestoreStreamAlarms = FirestoreDb.getAlarms();
    isarStreamAlarms = IsarDb.getAlarms();

    streamAlarms = StreamGroup.merge([firestoreStreamAlarms, isarStreamAlarms])
        .map((data) {
      if (data is QuerySnapshot) {
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

    refreshUpcomingAlarms();
  }

  refreshUpcomingAlarms() async {
    // Cancel timer if we have to refresh
    if (refreshTimer == true && _timer.isActive) {
      _timer.cancel();
      refreshTimer = false;
    }
    // Fake object to get latest alarm
    AlarmModel alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm = await IsarDb.getLatestAlarm(alarmRecord);

    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(alarmRecord);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

    String timeToAlarm =
        Utils.timeUntilAlarm(Utils.stringToTimeOfDay(latestAlarm.alarmTime));
    alarmTime.value = "Rings in $timeToAlarm";

    if (latestAlarm.minutesSinceMidnight > -1) {
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
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
