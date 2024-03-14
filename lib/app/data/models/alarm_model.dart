import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

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
  late bool isPedometerEnabled;
  late int intervalToAlarm;
  late bool isActivityEnabled;
  late String location;
  late int activityInterval;
  late int minutesSinceMidnight;
  late List<bool> days;
  late List<int> weatherTypes;
  late int shakeTimes;
  late int numberOfSteps;
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
  late int snoozeDuration;
  late int gradient;
  late String ringtoneName;
  late String note;
  late bool deleteAfterGoesOff;
  late bool showMotivationalQuote;

  late double volMax;
  late double volMin;

  @ignore
  Map? offsetDetails;

  AlarmModel({
    required this.alarmTime,
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
    required this.isPedometerEnabled,
    required this.numberOfSteps,
    required this.activityInterval,
    this.offsetDetails = const {},
    required this.mainAlarmTime,
    required this.label,
    required this.isOneTime,
    required this.snoozeDuration,
    required this.gradient,
    required this.ringtoneName,
    required this.note,
    required this.deleteAfterGoesOff,
    required this.showMotivationalQuote,
    required this.volMax,
    required this.volMin,
  });

  AlarmModel.fromDocumentSnapshot({
    required firestore.DocumentSnapshot documentSnapshot,
    required UserModel? user,
  }) {
    // Making sure the alarms work with the offsets
    isSharedAlarmEnabled = documentSnapshot['isSharedAlarmEnabled'];
    offsetDetails = documentSnapshot['offsetDetails'];

    if (isSharedAlarmEnabled && user != null) {
      mainAlarmTime = documentSnapshot['alarmTime'];
      // Using offsetted time only if it is enabled

      alarmTime = (offsetDetails![user.id]['offsetDuration'] != 0)
          ? offsetDetails![user.id]['offsettedTime']
          : documentSnapshot['alarmTime'];
      minutesSinceMidnight = Utils.timeOfDayToInt(
        Utils.stringToTimeOfDay(offsetDetails![user.id]['offsettedTime']),
      );
    } else {
      alarmTime = documentSnapshot['alarmTime'];
      minutesSinceMidnight = documentSnapshot['minutesSinceMidnight'];
    }
    snoozeDuration = documentSnapshot['snoozeDuration'];
    gradient = documentSnapshot['gradient'];
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
    isPedometerEnabled = documentSnapshot['isPedometerEnabled'];
    numberOfSteps = documentSnapshot['numberOfSteps'];
    ringtoneName = documentSnapshot['ringtoneName'];
    note = documentSnapshot['note'];
    deleteAfterGoesOff = documentSnapshot['deleteAfterGoesOff'];
    showMotivationalQuote = documentSnapshot['showMotivationalQuote'];

    volMax = documentSnapshot['volMax'];
    volMin = documentSnapshot['volMin'];
  }

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    // Making sure the alarms work with the offsets
    snoozeDuration = alarmData['snoozeDuration'];
    gradient = alarmData['gradient'];
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
    isPedometerEnabled = alarmData['isPedometerEnabled'];
    numberOfSteps = alarmData['numberOfSteps'];
    label = alarmData['label'];
    isOneTime = alarmData['isOneTime'];
    ringtoneName = alarmData['ringtoneName'];
    note = alarmData['note'];
    deleteAfterGoesOff = alarmData['deleteAfterGoesOff'];
    showMotivationalQuote = alarmData['showMotivationalQuote'];

    volMin = alarmData['volMin'];
    volMax = alarmData['volMax'];
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
      'isPedometerEnabled': alarmRecord.isPedometerEnabled,
      'numberOfSteps': alarmRecord.numberOfSteps,
      'snoozeDuration': alarmRecord.snoozeDuration,
      'gradient': alarmRecord.gradient,
      'ringtoneName': alarmRecord.ringtoneName,
      'note': alarmRecord.note,
      'deleteAfterGoesOff': alarmRecord.deleteAfterGoesOff,
      'showMotivationalQuote': alarmRecord.showMotivationalQuote,
      'volMin': alarmRecord.volMin,
      'volMax': alarmRecord.volMax,
    };

    if (alarmRecord.isSharedAlarmEnabled) {
      alarmMap['mainAlarmTime'] = alarmRecord.mainAlarmTime;
      alarmMap['offsetDetails'] = alarmRecord.offsetDetails;
    }
    return alarmMap;
  }
}
