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
  late int maxSnoozeCount;
  late int gradient;
  late String ringtoneName;
  late String note;
  late bool deleteAfterGoesOff;
  late bool showMotivationalQuote;
  late double volMax;
  late double volMin;
  late int activityMonitor;
  late String alarmDate;
  late bool ringOn;
  late String profile;
  late bool isGuardian;
  late int guardianTimer;
  late String guardian;
  late bool isCall;
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
      required this.isPedometerEnabled,
      required this.numberOfSteps,
      required this.activityInterval,
      this.offsetDetails = const {},
      required this.mainAlarmTime,
      required this.label,
      required this.isOneTime,
      required this.snoozeDuration,
      this.maxSnoozeCount = 3,
      required this.gradient,
      required this.ringtoneName,
      required this.note,
      required this.deleteAfterGoesOff,
      required this.showMotivationalQuote,
      required this.volMax,
      required this.volMin,
      required this.activityMonitor,
      required this.ringOn,
      required this.alarmDate,
      required this.profile,
      required this.isGuardian,
      required this.guardianTimer,
      required this.guardian,
      required this.isCall});

  AlarmModel.fromDocumentSnapshot({
    required firestore.DocumentSnapshot documentSnapshot,
    required UserModel? user,
  }) {
    final data = Map<String, dynamic>.from(
      documentSnapshot.data() as Map<String, dynamic>,
    );

    // Making sure the alarms work with the offsets
    isSharedAlarmEnabled = _asBool(data['isSharedAlarmEnabled'], false);
    offsetDetails = _asMap(data['offsetDetails']);

    if (isSharedAlarmEnabled && user != null && offsetDetails?[user.id] != null) {
      mainAlarmTime = _asString(data['alarmTime'], '00:00');
      // Using offsetted time only if it is enabled
      final userOffset = _asMap(offsetDetails?[user.id]);
      final offsetDuration = _asInt(userOffset?['offsetDuration'], 0);
      final offsettedTime = _asString(
        userOffset?['offsettedTime'],
        _asString(data['alarmTime'], '00:00'),
      );

      alarmTime =
          (offsetDuration != 0) ? offsettedTime : _asString(data['alarmTime'], '00:00');
      minutesSinceMidnight = Utils.timeOfDayToInt(
        Utils.stringToTimeOfDay(offsettedTime),
      );
    } else {
      alarmTime = _asString(data['alarmTime'], '00:00');
      minutesSinceMidnight = _asInt(data['minutesSinceMidnight'], 0);
    }
    snoozeDuration = _asInt(data['snoozeDuration'], 0);
    maxSnoozeCount = _asInt(data['maxSnoozeCount'], 3);
    gradient = _asInt(data['gradient'], 0);
    label = _asString(data['label'], '');
    isOneTime = _asBool(data['isOneTime'], false);
    firestoreId = documentSnapshot.id;
    alarmID = _asString(data['alarmID'], documentSnapshot.id);
    sharedUserIds = _asStringList(data['sharedUserIds']);
    lastEditedUserId = _asString(data['lastEditedUserId'], '');
    mutexLock = _asBool(data['mutexLock'], false);
    ownerId = _asString(data['ownerId'], '');
    ownerName = _asString(data['ownerName'], '');
    days = _asBoolList(data['days']);
    isEnabled = _asBool(data['isEnabled'], true);
    intervalToAlarm = _asInt(data['intervalToAlarm'], 0);
    isActivityEnabled = _asBool(data['isActivityEnabled'], false);
    activityInterval = _asInt(data['activityInterval'], 0);

    isLocationEnabled = _asBool(data['isLocationEnabled'], false);
    isWeatherEnabled = _asBool(data['isWeatherEnabled'], false);
    weatherTypes = _asIntList(data['weatherTypes']);
    location = _asString(data['location'], '0.0,0.0');
    isMathsEnabled = _asBool(data['isMathsEnabled'], false);
    mathsDifficulty = _asInt(data['mathsDifficulty'], 0);
    numMathsQuestions = _asInt(data['numMathsQuestions'], 0);
    isQrEnabled = _asBool(data['isQrEnabled'], false);
    qrValue = _asString(data['qrValue'], '');
    isShakeEnabled = _asBool(data['isShakeEnabled'], false);
    shakeTimes = _asInt(data['shakeTimes'], 0);
    isPedometerEnabled = _asBool(data['isPedometerEnabled'], false);
    numberOfSteps = _asInt(data['numberOfSteps'], 0);
    ringtoneName = _asString(data['ringtoneName'], 'Digital Alarm 1');
    note = _asString(data['note'], '');
    deleteAfterGoesOff = _asBool(data['deleteAfterGoesOff'], false);
    showMotivationalQuote = _asBool(data['showMotivationalQuote'], false);

    volMax = _asDouble(data['volMax'], 1.0);
    volMin = _asDouble(data['volMin'], 0.0);

    activityMonitor = _asInt(data['activityMonitor'], 0);
    alarmDate = _asString(data['alarmDate'], '');
    profile = _asString(data['profile'], 'Default');

    isGuardian = _asBool(data['isGuardian'], false);
    guardianTimer = _asInt(data['guardianTimer'], 0);
    guardian = _asString(data['guardian'], '');
    isCall = _asBool(data['isCall'], false);
    ringOn = _asBool(data['ringOn'], false);
  }

  AlarmModel fromMapSQFlite(Map<String, dynamic> map) {
    return AlarmModel(
      alarmTime: map['alarmTime'],
      alarmID: map['alarmID'],
      isEnabled: map['isEnabled'] == 1,
      isLocationEnabled: map['isLocationEnabled'] == 1,
      isSharedAlarmEnabled: map['isSharedAlarmEnabled'] == 1,
      isWeatherEnabled: map['isWeatherEnabled'] == 1,
      location: map['location'],
      activityInterval: map['activityInterval'],
      minutesSinceMidnight: map['minutesSinceMidnight'],
      days: stringToBoolList(map['days']),
      weatherTypes: List<int>.from(jsonDecode(map['weatherTypes'])),
      isMathsEnabled: map['isMathsEnabled'] == 1,
      mathsDifficulty: map['mathsDifficulty'],
      numMathsQuestions: map['numMathsQuestions'],
      isShakeEnabled: map['isShakeEnabled'] == 1,
      shakeTimes: map['shakeTimes'],
      isQrEnabled: map['isQrEnabled'] == 1,
      qrValue: map['qrValue'],
      isPedometerEnabled: map['isPedometerEnabled'] == 1,
      numberOfSteps: map['numberOfSteps'],
      intervalToAlarm: map['intervalToAlarm'],
      isActivityEnabled: map['isActivityEnabled'] == 1,
      sharedUserIds: map['sharedUserIds'] != null
          ? List<String>.from(jsonDecode(map['sharedUserIds']))
          : null,
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
      lastEditedUserId: map['lastEditedUserId'],
      mutexLock: map['mutexLock'] == 1,
      mainAlarmTime: map['mainAlarmTime'],
      label: map['label'],
      isOneTime: map['isOneTime'] == 1,
      snoozeDuration: map['snoozeDuration'],
      maxSnoozeCount: map['maxSnoozeCount'] ?? 3,
      gradient: map['gradient'],
      ringtoneName: map['ringtoneName'],
      note: map['note'],
      deleteAfterGoesOff: map['deleteAfterGoesOff'] == 1,
      showMotivationalQuote: map['showMotivationalQuote'] == 1,
      volMin: map['volMin'],
      volMax: map['volMax'],
      activityMonitor: map['activityMonitor'],
      alarmDate: map['alarmDate'],
      profile: map['profile'],
      isGuardian: map['isGuardian'] == 1,
      guardianTimer: map['guardianTimer'],
      guardian: map['guardian'],
      isCall: map['isCall'] == 1,
      ringOn: map['ringOn'] == 1,
    );
  }

  Map<String, dynamic> toSQFliteMap() {
    return {
      'firestoreId': firestoreId,
      'alarmTime': alarmTime,
      'alarmID': alarmID,
      'isEnabled': isEnabled ? 1 : 0,
      'isLocationEnabled': isLocationEnabled ? 1 : 0,
      'isSharedAlarmEnabled': isSharedAlarmEnabled ? 1 : 0,
      'isWeatherEnabled': isWeatherEnabled ? 1 : 0,
      'location': location,
      'activityInterval': activityInterval,
      'minutesSinceMidnight': minutesSinceMidnight,
      'days': boolListToString(days),
      'weatherTypes': jsonEncode(weatherTypes),
      'isMathsEnabled': isMathsEnabled ? 1 : 0,
      'mathsDifficulty': mathsDifficulty,
      'numMathsQuestions': numMathsQuestions,
      'isShakeEnabled': isShakeEnabled ? 1 : 0,
      'shakeTimes': shakeTimes,
      'isQrEnabled': isQrEnabled ? 1 : 0,
      'qrValue': qrValue,
      'isPedometerEnabled': isPedometerEnabled ? 1 : 0,
      'numberOfSteps': numberOfSteps,
      'intervalToAlarm': intervalToAlarm,
      'isActivityEnabled': isActivityEnabled ? 1 : 0,
      'sharedUserIds': sharedUserIds != null ? jsonEncode(sharedUserIds) : null,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'lastEditedUserId': lastEditedUserId,
      'mutexLock': mutexLock ? 1 : 0,
      'mainAlarmTime': mainAlarmTime,
      'label': label,
      'isOneTime': isOneTime ? 1 : 0,
      'snoozeDuration': snoozeDuration,
      'maxSnoozeCount': maxSnoozeCount,
      'gradient': gradient,
      'ringtoneName': ringtoneName,
      'note': note,
      'deleteAfterGoesOff': deleteAfterGoesOff ? 1 : 0,
      'showMotivationalQuote': showMotivationalQuote ? 1 : 0,
      'volMin': volMin,
      'volMax': volMax,
      'activityMonitor': activityMonitor,
      'alarmDate': alarmDate,
      'ringOn': ringOn ? 1 : 0,
      'profile': profile,
      'isGuardian': isGuardian ? 1 : 0,
      'guardianTimer': guardianTimer,
      'guardian': guardian,
      'isCall': isCall ? 1 : 0,
    };
  }

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    // Making sure the alarms work with the offsets
    final data = Map<String, dynamic>.from(alarmData);
    snoozeDuration = _asInt(data['snoozeDuration'], 0);
    maxSnoozeCount = _asInt(data['maxSnoozeCount'], 3);
    gradient = _asInt(data['gradient'], 0);
    isSharedAlarmEnabled = _asBool(data['isSharedAlarmEnabled'], false);
    minutesSinceMidnight = _asInt(data['minutesSinceMidnight'], 0);
    alarmTime = _asString(data['alarmTime'], '00:00');
    firestoreId = alarmData['firestoreId'];
    alarmID = _asString(data['alarmID'], '');
    sharedUserIds = _asStringList(data['sharedUserIds']);
    lastEditedUserId = _asString(data['lastEditedUserId'], '');
    mutexLock = _asBool(data['mutexLock'], false);
    ownerId = _asString(data['ownerId'], '');
    ownerName = _asString(data['ownerName'], '');
    days = _asBoolList(data['days']);
    isEnabled = _asBool(data['isEnabled'], true);
    intervalToAlarm = _asInt(data['intervalToAlarm'], 0);
    isActivityEnabled = _asBool(data['isActivityEnabled'], false);
    activityInterval = _asInt(data['activityInterval'], 0);

    isLocationEnabled = _asBool(data['isLocationEnabled'], false);
    isWeatherEnabled = _asBool(data['isWeatherEnabled'], false);
    weatherTypes = _asIntList(data['weatherTypes']);
    location = _asString(data['location'], '0.0,0.0');

    isMathsEnabled = _asBool(data['isMathsEnabled'], false);
    mathsDifficulty = _asInt(data['mathsDifficulty'], 0);
    numMathsQuestions = _asInt(data['numMathsQuestions'], 0);
    isQrEnabled = _asBool(data['isQrEnabled'], false);
    qrValue = _asString(data['qrValue'], '');
    isShakeEnabled = _asBool(data['isShakeEnabled'], false);
    shakeTimes = _asInt(data['shakeTimes'], 0);
    isPedometerEnabled = _asBool(data['isPedometerEnabled'], false);
    numberOfSteps = _asInt(data['numberOfSteps'], 0);
    label = _asString(data['label'], '');
    isOneTime = _asBool(data['isOneTime'], false);
    ringtoneName = _asString(data['ringtoneName'], 'Digital Alarm 1');
    note = _asString(data['note'], '');
    deleteAfterGoesOff = _asBool(data['deleteAfterGoesOff'], false);
    showMotivationalQuote = _asBool(data['showMotivationalQuote'], false);

    volMin = _asDouble(data['volMin'], 0.0);
    volMax = _asDouble(data['volMax'], 1.0);

    activityMonitor = _asInt(data['activityMonitor'], 0);
    alarmDate = _asString(data['alarmDate'], '');
    profile = _asString(data['profile'], 'Default');

    isGuardian = _asBool(data['isGuardian'], false);
    guardianTimer = _asInt(data['guardianTimer'], 0);
    guardian = _asString(data['guardian'], '');
    isCall = _asBool(data['isCall'], false);
    ringOn = _asBool(data['ringOn'], false);
    mainAlarmTime = data['mainAlarmTime'] != null
        ? _asString(data['mainAlarmTime'], alarmTime)
        : null;
    offsetDetails = _asMap(data['offsetDetails']);
  }

  AlarmModel.fromJson(String alarmData, UserModel? user)
      : this.fromMap(jsonDecode(alarmData) as Map<String, dynamic>);

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
      'maxSnoozeCount': alarmRecord.maxSnoozeCount,
      'gradient': alarmRecord.gradient,
      'ringtoneName': alarmRecord.ringtoneName,
      'note': alarmRecord.note,
      'deleteAfterGoesOff': alarmRecord.deleteAfterGoesOff,
      'showMotivationalQuote': alarmRecord.showMotivationalQuote,
      'volMin': alarmRecord.volMin,
      'volMax': alarmRecord.volMax,
      'activityMonitor': alarmRecord.activityMonitor,
      'alarmDate': alarmRecord.alarmDate,
      'profile': alarmRecord.profile,
      'isGuardian': alarmRecord.isGuardian,
      'guardianTimer': alarmRecord.guardianTimer,
      'guardian': alarmRecord.guardian,
      'isCall': alarmRecord.isCall,
      'ringOn': alarmRecord.ringOn
    };

    if (alarmRecord.isSharedAlarmEnabled) {
      alarmMap['mainAlarmTime'] = alarmRecord.mainAlarmTime;
      alarmMap['offsetDetails'] = alarmRecord.offsetDetails;
    }
    return alarmMap;
  }

  String boolListToString(List<bool> boolList) {
    // Rotate the list to start with Sunday
    var rotatedList =
        [boolList.last] + boolList.sublist(0, boolList.length - 1);
    // Convert the list of bools to a string of 1s and 0s
    return rotatedList.map((b) => b ? '1' : '0').join();
  }

  List<bool> stringToBoolList(String s) {
    // Rotate the string to start with Monday
    final rotatedString = s.substring(1) + s[0];
    // Convert the rotated string to a list of boolean values
    return rotatedString.split('').map((c) => c == '1').toList();
  }

  static bool _asBool(dynamic value, bool fallback) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    return fallback;
  }

  static int _asInt(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return fallback;
  }

  static double _asDouble(dynamic value, double fallback) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return fallback;
  }

  static String _asString(dynamic value, String fallback) {
    if (value is String) return value;
    return fallback;
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return [];
  }

  static List<bool> _asBoolList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => _asBool(item, false))
          .toList()
          .cast<bool>();
    }
    return List<bool>.filled(7, false);
  }

  static List<int> _asIntList(dynamic value) {
    if (value is List) {
      return value.map((item) => _asInt(item, 0)).toList().cast<int>();
    }
    return [];
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }
}
