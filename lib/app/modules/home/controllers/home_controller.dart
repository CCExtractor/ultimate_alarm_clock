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
