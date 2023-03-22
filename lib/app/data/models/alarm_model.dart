import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  String? id;
  late String alarmTime;
  late bool isEnabled;
  late bool isLocationEnabled;
  late int intervalToAlarm;
  late bool isActivityEnabled;
  late String location;
  int? activityInterval;
  late int minutesSinceMidnight;
  AlarmModel(
      {required this.alarmTime,
      this.isEnabled = true,
      required this.intervalToAlarm,
      required this.isActivityEnabled,
      required this.minutesSinceMidnight,
      required this.isLocationEnabled,
      required this.location,
      this.activityInterval = 600000});

  AlarmModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    alarmTime = documentSnapshot['alarmTime'];
    isEnabled = documentSnapshot['isEnabled'];
    intervalToAlarm = documentSnapshot['intervalToAlarm'];
    isActivityEnabled = documentSnapshot['isActivityEnabled'];
    activityInterval = documentSnapshot['activityInterval'];
    minutesSinceMidnight = documentSnapshot['minutesSinceMidnight'];
    isLocationEnabled = documentSnapshot['isLocationEnabled'];
    location = documentSnapshot['location'];
  }

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    id = alarmData['id'];
    alarmTime = alarmData['alarmTime'];
    isEnabled = alarmData['isEnabled'];
    intervalToAlarm = alarmData['intervalToAlarm'];
    isActivityEnabled = alarmData['isActivityEnabled'];
    activityInterval = alarmData['activityInterval'];
    minutesSinceMidnight = alarmData['minutesSinceMidnight'];
    isLocationEnabled = alarmData['isLocationEnabled'];
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
      'alarmTime': alarmRecord.alarmTime,
      'intervalToAlarm': alarmRecord.intervalToAlarm,
      'isEnabled': alarmRecord.isEnabled,
      'isActivityEnabled': alarmRecord.isActivityEnabled,
      'activityInterval': alarmRecord.activityInterval,
      'minutesSinceMidnight': alarmRecord.minutesSinceMidnight,
      'isLocationEnabled': alarmRecord.isLocationEnabled,
      'location': alarmRecord.location
    };
  }
}
