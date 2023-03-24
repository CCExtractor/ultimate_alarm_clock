import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/main.dart';

class HomeController extends GetxController {
  late Stream<QuerySnapshot> streamAlarms;
  final alarmTime = 'No upcoming alarms!'.obs;
  @override
  void onInit() {
    super.onInit();
    streamAlarms = FirestoreDb.getAlarms();
  }

  @override
  void onReady() async {
    super.onReady();

    // Fake object to get latest alarm
    AlarmModel alarmRecord = AlarmModel(
        isEnabled: false,
        isActivityEnabled: false,
        isLocationEnabled: false,
        intervalToAlarm: 0,
        location: '',
        alarmTime: Utils.timeOfDayToString(TimeOfDay.now()),
        minutesSinceMidnight: Utils.timeOfDayToInt(TimeOfDay.now()));

    AlarmModel latestAlarm = await FirestoreDb.getLatestAlarm(alarmRecord);
    String timeToAlarm =
        Utils.timeUntilAlarm(Utils.stringToTimeOfDay(latestAlarm.alarmTime));
    alarmTime.value = "Rings in $timeToAlarm";
    if (latestAlarm.minutesSinceMidnight != alarmRecord.minutesSinceMidnight) {
      // Starting timer for live refresh
      Timer.periodic(
          Duration(
              milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                  DateTime.now().add(const Duration(minutes: 1)))), (timer) {
        timeToAlarm = Utils.timeUntilAlarm(
            Utils.stringToTimeOfDay(latestAlarm.alarmTime));
        alarmTime.value = "Rings in $timeToAlarm";
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
