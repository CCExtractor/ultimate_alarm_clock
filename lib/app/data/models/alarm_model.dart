import 'dart:convert';

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

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    id = alarmData['id'];
    alarmTime = alarmData['alarmTime'];
    isEnabled = alarmData['isEnabled'];
    intervalToAlarm = alarmData['intervalToAlarm'];
    isActivityEnabled = alarmData['isActivityEnabled'];
    activityInterval = alarmData['activityInterval'];
  }

  AlarmModel.fromJson(String alarmData) {
    AlarmModel.fromMap(jsonDecode(alarmData));
  }

  static String toJson(AlarmModel alarmRecord) {
    return jsonEncode(AlarmModel.toMap(alarmRecord));
  }

  static Map<String, dynamic> toMap(AlarmModel alarmRecord) {
    return {
      'id': alarmRecord.id,
      'alarmTime': alarmRecord.alarmTime,
      'intervalToAlarm': alarmRecord.intervalToAlarm,
      'isEnabled': alarmRecord.isEnabled,
      'isActivityEnabled': alarmRecord.isActivityEnabled,
      'activityInterval': alarmRecord.activityInterval
    };
  }
}
