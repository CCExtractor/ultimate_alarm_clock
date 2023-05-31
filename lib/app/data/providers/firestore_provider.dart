import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class FirestoreDb {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final CollectionReference _alarmsCollection =
      _firebaseFirestore.collection('alarms');

  static addAlarm(AlarmModel alarmRecord) async {
    await _alarmsCollection
        .add(AlarmModel.toMap(alarmRecord))
        .then((value) => alarmRecord.firestoreId = value.id);
    return alarmRecord;
  }

  static getTriggeredAlarm(String time) async {
    QuerySnapshot snapshot = await _alarmsCollection
        .where('isEnabled', isEqualTo: true)
        .where('alarmTime', isEqualTo: time)
        .get();

    List list = snapshot.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
    }).toList();

    return list[0];
  }

  static Future<AlarmModel> getLatestAlarm(AlarmModel alarmRecord) async {
    int nowInMinutes = Utils.timeOfDayToInt(TimeOfDay(
        hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1));

    late List<AlarmModel> alarms;

    // Get all enabled alarms
    QuerySnapshot snapshot =
        await _alarmsCollection.where('isEnabled', isEqualTo: true).get();
    alarms = snapshot.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
    }).toList();

    if (alarms.isEmpty) {
      alarmRecord.minutesSinceMidnight = -1;
      return alarmRecord;
    } else {
      // Get the closest alarm to the current time
      AlarmModel closestAlarm = alarms.reduce((a, b) {
        int aTimeUntilNextAlarm = a.minutesSinceMidnight - nowInMinutes;
        int bTimeUntilNextAlarm = b.minutesSinceMidnight - nowInMinutes;

        // Check if alarm repeats on any day
        bool aRepeats = a.days.any((day) => day);
        bool bRepeats = b.days.any((day) => day);

        // If alarm is one-time and has already passed, set time until next alarm to next day
        if (!aRepeats && aTimeUntilNextAlarm < 0) {
          aTimeUntilNextAlarm += Duration.minutesPerDay;
        }
        if (!bRepeats && bTimeUntilNextAlarm < 0) {
          bTimeUntilNextAlarm += Duration.minutesPerDay;
        }

        // If alarm repeats on any day, find the next upcoming day
        if (aRepeats) {
          int currentDay = DateTime.now().weekday - 1;
          for (int i = 0; i < a.days.length; i++) {
            int dayIndex = (currentDay + i) % a.days.length;
            if (a.days[dayIndex]) {
              aTimeUntilNextAlarm += i * Duration.minutesPerDay;
              break;
            }
          }
        }

        if (bRepeats) {
          int currentDay = DateTime.now().weekday - 1;
          for (int i = 0; i < b.days.length; i++) {
            int dayIndex = (currentDay + i) % b.days.length;
            if (b.days[dayIndex]) {
              bTimeUntilNextAlarm += i * Duration.minutesPerDay;
              break;
            }
          }
        }

        return aTimeUntilNextAlarm < bTimeUntilNextAlarm ? a : b;
      });
      return closestAlarm;
    }
  }

  static updateAlarm(AlarmModel alarmRecord) async => await _alarmsCollection
      .doc(alarmRecord.firestoreId)
      .update(AlarmModel.toMap(alarmRecord));

  static getAlarm(String id) async => await _alarmsCollection.doc(id).get();

  static getAlarms() => _alarmsCollection
      .orderBy('minutesSinceMidnight', descending: false)
      .snapshots();

  static deleteAlarm(String id) async =>
      await _alarmsCollection.doc(id).delete();
}
