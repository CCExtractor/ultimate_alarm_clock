import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AlarmModel {
  String? id;
  late String alarmTime;
  late bool isEnabled;
  late int intervalToAlarm;
  late bool isActivityEnabled;
  int? activityInterval;
  AlarmModel(
      {required this.alarmTime,
      this.isEnabled = true,
      required this.intervalToAlarm,
      required this.isActivityEnabled,
      this.activityInterval = 600000});

  AlarmModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    alarmTime = documentSnapshot['alarmTime'];
    isEnabled = documentSnapshot['isEnabled'];
    intervalToAlarm = documentSnapshot['intervalToAlarm'];
    isActivityEnabled = documentSnapshot['isActivityEnabled'];
    activityInterval = documentSnapshot['activityInterval'];
  }

  static Map<String, dynamic> toMap(AlarmModel alarmRecord) {
    return {
      'alarmTime': alarmRecord.alarmTime,
      'intervalToAlarm': alarmRecord.intervalToAlarm,
      'isEnabled': alarmRecord.isEnabled,
      'isActivityEnabled': alarmRecord.isActivityEnabled,
      'activityInterval': alarmRecord.activityInterval
    };
  }
}
