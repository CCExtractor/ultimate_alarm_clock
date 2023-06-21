import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:isar/isar.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
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
  late String lastEditedUserId;
  late bool mutexLock;
  String? mainAlarmTime;
  late String label;
  late bool isOneTime;
  @ignore
  Map? offsetDetails;

  AlarmModel(
      {required this.alarmTime,
      required this.alarmID,
      this.sharedUserIds = const [],
      required this.ownerId,
      required this.ownerName,
      required this.lastEditedUserId,
      required this.mutexLock,
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
      required this.activityInterval,
      this.offsetDetails = const {},
      required this.mainAlarmTime,
      required this.label,
      required this.isOneTime});

  AlarmModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot, required UserModel? user}) {
    // Making sure the alarms work with the offsets
    isSharedAlarmEnabled = documentSnapshot['isSharedAlarmEnabled'];
    offsetDetails = documentSnapshot['offsetDetails'];

    if (isSharedAlarmEnabled && user != null) {
      mainAlarmTime = documentSnapshot['alarmTime'];
      alarmTime = offsetDetails![user.id]['offsettedTime'];
      minutesSinceMidnight = Utils.timeOfDayToInt(
          Utils.stringToTimeOfDay(offsetDetails![user.id]['offsettedTime']));
    } else {
      alarmTime = documentSnapshot['alarmTime'];
      minutesSinceMidnight = documentSnapshot['minutesSinceMidnight'];
    }
    label = documentSnapshot['label'];
    isOneTime = documentSnapshot['isOneTime'];
    firestoreId = documentSnapshot.id;
    alarmID = documentSnapshot['alarmID'];
    sharedUserIds = List<String>.from(documentSnapshot['sharedUserIds']);
    lastEditedUserId = documentSnapshot['lastEditedUserId'];
    mutexLock = documentSnapshot['mutexLock'];
    ownerId = documentSnapshot['ownerId'];
    ownerName = documentSnapshot['ownerName'];
    days = List<bool>.from(documentSnapshot['days']);
    isEnabled = documentSnapshot['isEnabled'];
    intervalToAlarm = documentSnapshot['intervalToAlarm'];
    isActivityEnabled = documentSnapshot['isActivityEnabled'];
    activityInterval = documentSnapshot['activityInterval'];

    isLocationEnabled = documentSnapshot['isLocationEnabled'];
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
    // Making sure the alarms work with the offsets
    isSharedAlarmEnabled = alarmData['isSharedAlarmEnabled'];
    minutesSinceMidnight = alarmData['minutesSinceMidnight'];
    alarmTime = alarmData['alarmTime'];
    firestoreId = alarmData['firestoreId'];
    alarmID = alarmData['alarmID'];
    sharedUserIds = alarmData['sharedUserIds'];
    lastEditedUserId = alarmData['lastEditedUserId'];
    mutexLock = alarmData['mutexLock'];
    ownerId = alarmData['ownerId'];
    ownerName = alarmData['ownerName'];
    days = alarmData['days'];
    isEnabled = alarmData['isEnabled'];
    intervalToAlarm = alarmData['intervalToAlarm'];
    isActivityEnabled = alarmData['isActivityEnabled'];
    isWeatherEnabled = alarmData['isWeatherEnabled'];
    weatherTypes = alarmData['weatherTypes'];

    activityInterval = alarmData['activityInterval'];
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
    label = alarmData['label'];
    isOneTime = alarmData['isOneTime'];
  }

  AlarmModel.fromJson(String alarmData, UserModel? user) {
    AlarmModel.fromMap(jsonDecode(alarmData));
  }

  static String toJson(AlarmModel alarmRecord) {
    return jsonEncode(AlarmModel.toMap(alarmRecord));
  }

  static Map<String, dynamic> toMap(AlarmModel alarmRecord) {
    final alarmMap = <String, dynamic>{
      'firestoreId': alarmRecord.firestoreId,
      'alarmID': alarmRecord.alarmID,
      'ownerId': alarmRecord.ownerId,
      'lastEditedUserId': alarmRecord.lastEditedUserId,
      'mutexLock': alarmRecord.mutexLock,
      'isOneTime': alarmRecord.isOneTime,
      'label': alarmRecord.label,
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

    if (alarmRecord.isSharedAlarmEnabled) {
      alarmMap['mainAlarmTime'] = alarmRecord.mainAlarmTime;
      alarmMap['offsetDetails'] = alarmRecord.offsetDetails;
    }
    return alarmMap;
  }
}
