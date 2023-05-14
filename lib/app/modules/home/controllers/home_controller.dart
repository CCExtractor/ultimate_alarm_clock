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

        // If alarm repeats on any day, find the next upcoming day
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
          if (aUpcomingTime <
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
          if (bUpcomingTime <
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

    print("ISAR: ${isarLatestAlarm.alarmTime}");
    print("Fire: ${firestoreLatestAlarm.alarmTime}");

    String timeToAlarm = Utils.timeUntilAlarm(
        Utils.stringToTimeOfDay(latestAlarm.alarmTime), latestAlarm.days);
    alarmTime.value = "Rings in $timeToAlarm";

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
