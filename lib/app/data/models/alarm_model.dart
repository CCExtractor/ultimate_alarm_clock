import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isar/isar.dart';
part 'alarm_model.g.dart';

@collection
class AlarmModel {
  Id isarId = Isar.autoIncrement;

  String? firestoreId;
  late String alarmTime;
  late bool isEnabled;
  late bool isLocationEnabled;
  late bool isSharedAlarmEnabled;
  late bool isWeatherEnabled;
  late int intervalToAlarm;
  late bool isActivityEnabled;
  late String location;
  int? activityInterval;
  late int minutesSinceMidnight;
  late List<bool> days;
  late List<int> weatherTypes;

  AlarmModel(
      {required this.alarmTime,
      this.isEnabled = true,
      required this.days,
      required this.intervalToAlarm,
      required this.isActivityEnabled,
      required this.minutesSinceMidnight,
      required this.isLocationEnabled,
      required this.isSharedAlarmEnabled,
      required this.isWeatherEnabled,
      required this.location,
      required this.weatherTypes,
      this.activityInterval = 600000});

  AlarmModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    firestoreId = documentSnapshot.id;
    days = List<bool>.from(documentSnapshot['days']);
    alarmTime = documentSnapshot['alarmTime'];
    isEnabled = documentSnapshot['isEnabled'];
    intervalToAlarm = documentSnapshot['intervalToAlarm'];
    isActivityEnabled = documentSnapshot['isActivityEnabled'];
    activityInterval = documentSnapshot['activityInterval'];
    minutesSinceMidnight = documentSnapshot['minutesSinceMidnight'];
    isLocationEnabled = documentSnapshot['isLocationEnabled'];
    isSharedAlarmEnabled = documentSnapshot['isSharedAlarmEnabled'];
    isWeatherEnabled = documentSnapshot['isWeatherEnabled'];
    weatherTypes = List<int>.from(documentSnapshot['weatherTypes']);
    location = documentSnapshot['location'];
  }

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    firestoreId = alarmData['firestoreId'];
    alarmTime = alarmData['alarmTime'];
    days = alarmData['days'];
    isEnabled = alarmData['isEnabled'];
    intervalToAlarm = alarmData['intervalToAlarm'];
    isActivityEnabled = alarmData['isActivityEnabled'];
    isWeatherEnabled = alarmData['isWeatherEnabled'];
    weatherTypes = alarmData['weatherTypes'];

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
      'firestoreId': alarmRecord.firestoreId,
      'days': alarmRecord.days,
      'alarmTime': alarmRecord.alarmTime,
      'intervalToAlarm': alarmRecord.intervalToAlarm,
      'isEnabled': alarmRecord.isEnabled,
      'isActivityEnabled': alarmRecord.isActivityEnabled,
      'weatherTypes': alarmRecord.weatherTypes,
      'isWeatherEnabled': alarmRecord.isWeatherEnabled,
      'activityInterval': alarmRecord.activityInterval,
      'minutesSinceMidnight': alarmRecord.minutesSinceMidnight,
      'isLocationEnabled': alarmRecord.isLocationEnabled,
      'location': alarmRecord.location,
      'isSharedAlarmEnabled': alarmRecord.isSharedAlarmEnabled
    };
  }
}
