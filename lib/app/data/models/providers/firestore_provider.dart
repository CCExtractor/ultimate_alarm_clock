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
        .then((value) => alarmRecord.id = value.id);
    return alarmRecord;
  }

  static getLatestAlarm(AlarmModel alarmRecord) async {
    int nowInMinutes = Utils.timeOfDayToInt(TimeOfDay.now());
    late List list;
    late QuerySnapshot snapshot;
// Alarm is set for a value in the future
    if (alarmRecord.minutesSinceMidnight >= nowInMinutes) {
      // We'll find the alarm that's in future but least and schedule it
      snapshot = await _alarmsCollection
          .where('isEnabled', isEqualTo: true)
          .where('minutesSinceMidnight', isGreaterThanOrEqualTo: nowInMinutes)
          .orderBy('minutesSinceMidnight', descending: false)
          .get();

      list = snapshot.docs.map((DocumentSnapshot document) {
        return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
      }).toList();
    } else {
      // We are sure that the alarm is set in the past, so we'll find the least value among all alarms before this date
      snapshot = await _alarmsCollection
          .where('isEnabled', isEqualTo: true)
          .where('minutesSinceMidnight',
              isLessThanOrEqualTo: alarmRecord.minutesSinceMidnight)
          .orderBy('minutesSinceMidnight', descending: false)
          .get();

      list = snapshot.docs.map((DocumentSnapshot document) {
        return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
      }).toList();
    }
// For past :
    // All these alarms are set in the past, so will be scheduled for the next day, same time via getMilliSeconds()
    // If empty, the set alarm is the least value othwerwise there's a least alarm set
// For future :
    // If list is empty, the set alarm is the only one in future
    // Otherwise, there's an alarm set before this
    if (list.isEmpty == true) {
      return alarmRecord;
    } else {
      return list.first;
    }
  }

  static updateAlarm(AlarmModel alarmRecord) async => await _alarmsCollection
      .doc(alarmRecord.id)
      .update(AlarmModel.toMap(alarmRecord));

  static getAlarm(String id) async => await _alarmsCollection.doc(id).get();

  static getAlarms() => _alarmsCollection
      .orderBy('minutesSinceMidnight', descending: false)
      .snapshots();

  static deleteAlarm(String id) async =>
      await _alarmsCollection.doc(id).delete();
}
