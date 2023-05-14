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

  static getLatestAlarm(AlarmModel alarmRecord) async {
    int nowInMinutes = Utils.timeOfDayToInt(TimeOfDay.now());
    late List list;
    late QuerySnapshot snapshot;

    // Find the next alarm that is scheduled after the current time
    snapshot = await _alarmsCollection
        .where('isEnabled', isEqualTo: true)
        .where('minutesSinceMidnight', isGreaterThanOrEqualTo: nowInMinutes)
        .orderBy('minutesSinceMidnight', descending: false)
        .get();

    list = snapshot.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
    }).toList();

    // If no alarms are found that are scheduled after the current time,
    // find the next alarm that is scheduled before the current time
    if (list.isEmpty) {
      snapshot = await _alarmsCollection
          .where('isEnabled', isEqualTo: true)
          .orderBy('minutesSinceMidnight', descending: false)
          .get();

      list = snapshot.docs.map((DocumentSnapshot document) {
        return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
      }).toList();
    }

    // If no alarms are found, return the original alarmRecord object
    if (list.isEmpty) {
      alarmRecord.minutesSinceMidnight = -1;
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
