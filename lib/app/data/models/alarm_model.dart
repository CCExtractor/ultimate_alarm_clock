import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isar/isar.dart';
part 'alarm_model.g.dart';

@collection
class AlarmModel {
  Id isarId = Isar.autoIncrement;

  String? firestoreId;
  late String alarmTime;
  late String alarmID;
  late bool isEnabled;
  late bool isLocationEnabled;
  late bool isSharedAlarmEnabled;
  late bool isWeatherEnabled;
  late bool isMathsEnabled;
  late bool isShakeEnabled;
  late bool isQrEnabled;
  late int intervalToAlarm;
  late bool isActivityEnabled;
  late String location;
  late int activityInterval;
  late int minutesSinceMidnight;
  late List<bool> days;
  late List<int> weatherTypes;
  late int shakeTimes;
  late int numMathsQuestions;
  late int mathsDifficulty;
  late String qrValue;
  List<String>? sharedUserIds;
  late String ownerId;
  late String ownerName;

  AlarmModel(
      {required this.alarmTime,
      required this.alarmID,
      this.sharedUserIds = const [],
      required this.ownerId,
      required this.ownerName,
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
      required this.isMathsEnabled,
      required this.mathsDifficulty,
      required this.numMathsQuestions,
      required this.isShakeEnabled,
      required this.shakeTimes,
      required this.isQrEnabled,
      required this.qrValue,
      required this.activityInterval});

  AlarmModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    firestoreId = documentSnapshot.id;
    alarmID = documentSnapshot['alarmID'];
    sharedUserIds = List<String>.from(documentSnapshot['sharedUserIds']);
    ownerId = documentSnapshot['ownerId'];
    ownerName = documentSnapshot['ownerName'];
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
    isMathsEnabled = documentSnapshot['isMathsEnabled'];
    mathsDifficulty = documentSnapshot['mathsDifficulty'];
    numMathsQuestions = documentSnapshot['numMathsQuestions'];
    isQrEnabled = documentSnapshot['isQrEnabled'];
    qrValue = documentSnapshot['qrValue'];
    isShakeEnabled = documentSnapshot['isShakeEnabled'];
    shakeTimes = documentSnapshot['shakeTimes'];
  }

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    firestoreId = alarmData['firestoreId'];
    alarmID = alarmData['alarmID'];
    sharedUserIds = alarmData['sharedUserIds'];
    ownerId = alarmData['ownerId'];
    ownerName = alarmData['ownerName'];
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

    isMathsEnabled = alarmData['isMathsEnabled'];
    mathsDifficulty = alarmData['mathsDifficulty'];
    numMathsQuestions = alarmData['numMathsQuestions'];
    isQrEnabled = alarmData['isQrEnabled'];
    qrValue = alarmData['qrValue'];
    isShakeEnabled = alarmData['isShakeEnabled'];
    shakeTimes = alarmData['shakeTimes'];
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
      'alarmID': alarmRecord.alarmID,
      'ownerId': alarmRecord.ownerId,
      'ownerName': alarmRecord.ownerName,
      'sharedUserIds': alarmRecord.sharedUserIds,
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
      'isSharedAlarmEnabled': alarmRecord.isSharedAlarmEnabled,
      'isMathsEnabled': alarmRecord.isMathsEnabled,
      'mathsDifficulty': alarmRecord.mathsDifficulty,
      'numMathsQuestions': alarmRecord.numMathsQuestions,
      'isQrEnabled': alarmRecord.isQrEnabled,
      'qrValue': alarmRecord.qrValue,
      'isShakeEnabled': alarmRecord.isShakeEnabled,
      'shakeTimes': alarmRecord.shakeTimes,
    };
  }
}
