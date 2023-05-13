import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isar/isar.dart';
part 'alarm_model.g.dart';

@Collection()
class AlarmModel {
  Id isarId = Isar.autoIncrement;

  String? id;
  late String alarmTime;
  late bool isEnabled;
  late bool isLocationEnabled;
  late bool isSharedAlarmEnabled;
  late int intervalToAlarm;
  late bool isActivityEnabled;
  late String location;
  int? activityInterval;
  late int minutesSinceMidnight;
  late List<bool> days;

  AlarmModel(
      {required this.alarmTime,
      this.isEnabled = true,
      required this.days,
      required this.intervalToAlarm,
      required this.isActivityEnabled,
      required this.minutesSinceMidnight,
      required this.isLocationEnabled,
      required this.isSharedAlarmEnabled,
      required this.location,
      this.activityInterval = 600000});

  AlarmModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    days = List<bool>.from(documentSnapshot['days']);
    alarmTime = documentSnapshot['alarmTime'];
    isEnabled = documentSnapshot['isEnabled'];
    intervalToAlarm = documentSnapshot['intervalToAlarm'];
    isActivityEnabled = documentSnapshot['isActivityEnabled'];
    activityInterval = documentSnapshot['activityInterval'];
    minutesSinceMidnight = documentSnapshot['minutesSinceMidnight'];
    isLocationEnabled = documentSnapshot['isLocationEnabled'];
    isSharedAlarmEnabled = documentSnapshot['isSharedAlarmEnabled'];
    location = documentSnapshot['location'];
  }

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    id = alarmData['id'];
    alarmTime = alarmData['alarmTime'];
    days = alarmData['days'];
    isEnabled = alarmData['isEnabled'];
    intervalToAlarm = alarmData['intervalToAlarm'];
    isActivityEnabled = alarmData['isActivityEnabled'];
    activityInterval = alarmData['activityInterval'];
    minutesSinceMidnight = alarmData['minutesSinceMidnight'];
    isLocationEnabled = alarmData['isLocationEnabled'];
    isSharedAlarmEnabled = alarmData['isSharedAlarmEnabled'];
    location = alarmData['location'];
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
      'days': alarmRecord.days,
      'alarmTime': alarmRecord.alarmTime,
      'intervalToAlarm': alarmRecord.intervalToAlarm,
      'isEnabled': alarmRecord.isEnabled,
      'isActivityEnabled': alarmRecord.isActivityEnabled,
      'activityInterval': alarmRecord.activityInterval,
      'minutesSinceMidnight': alarmRecord.minutesSinceMidnight,
      'isLocationEnabled': alarmRecord.isLocationEnabled,
      'location': alarmRecord.location,
      'isSharedAlarmEnabled': alarmRecord.isSharedAlarmEnabled
    };
  }
}
