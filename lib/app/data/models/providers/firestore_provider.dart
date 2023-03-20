import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

class FirestoreDb {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final CollectionReference _alarmsCollection =
      _firebaseFirestore.collection('alarms');

  static addAlarm(AlarmModel alarmRecord) async {
    late String id;
    await _alarmsCollection
        .add(AlarmModel.toMap(alarmRecord))
        .then((value) => id = value.id);
    return id;
  }

  static updateAlarm(AlarmModel alarmRecord) async => await _alarmsCollection
      .doc(alarmRecord.id)
      .update(AlarmModel.toMap(alarmRecord));

  static getAlarm(String id) => _alarmsCollection.doc(id).get();

  static getAlarms() => _firebaseFirestore.collection('alarms').snapshots();

  static deleteAlarm(String id) async =>
      await _alarmsCollection.doc(id).delete();
}
