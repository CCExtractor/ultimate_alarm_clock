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
  late int locationConditionType; 
  late bool isSharedAlarmEnabled;
  late bool isWeatherEnabled;
  late int weatherConditionType; 
  late int activityConditionType;
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
  late bool isSunriseEnabled;
  late int sunriseDuration;
  late double sunriseIntensity;
  late int sunriseColorScheme;
  late String timezoneId;
  late bool isTimezoneEnabled;
  late int targetTimezoneOffset;
  late int smartControlCombinationType;
  @ignore
  List<Map>? offsetDetails;

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
      required this.locationConditionType,
      required this.isSharedAlarmEnabled,
      required this.isWeatherEnabled,
      required this.weatherConditionType,
      required this.activityConditionType,
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
      this.offsetDetails = const [{}],
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
      required this.isCall,
      required this.isSunriseEnabled,
      required this.sunriseDuration,
      required this.sunriseIntensity,
      required this.sunriseColorScheme,
      this.timezoneId = '',
      this.isTimezoneEnabled = false,
      this.targetTimezoneOffset = 0,
      this.smartControlCombinationType = 0});

  AlarmModel.fromDocumentSnapshot({
    required firestore.DocumentSnapshot documentSnapshot,
    required UserModel? user,
  }) {
    // Making sure the alarms work with the offsets
    isSharedAlarmEnabled = documentSnapshot['isSharedAlarmEnabled'];
    
    
    final offsetDetailsRaw = documentSnapshot['offsetDetails'];
    if (offsetDetailsRaw is Map) {
    
      final offsetDetailsMap = Map<String, dynamic>.from(offsetDetailsRaw);
    
      offsetDetails = offsetDetailsMap.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value);
        data['userId'] = entry.key;
        return data;
      }).toList();
    } else if (offsetDetailsRaw is List) {
      
      offsetDetails = (offsetDetailsRaw as List<dynamic>)
    .map((item) => item as Map<String, dynamic>)
    .toList();
    } else {
      offsetDetails = null;
    }

    if (isSharedAlarmEnabled && user != null) {
      mainAlarmTime = documentSnapshot['alarmTime'];
      // Using offsetted time only if it is enabled

if (offsetDetails != null) {
  final userOffset = offsetDetails!
      .where((entry) => entry['userId'] == user.id)
      .toList();

  if (userOffset.isNotEmpty) {
    final data = userOffset.first;

    alarmTime = (data['offsetDuration'] != 0)
        ? data['offsettedTime']
        : documentSnapshot['alarmTime'];

    minutesSinceMidnight = Utils.timeOfDayToInt(
      Utils.stringToTimeOfDay(data['offsettedTime']),
    );
  }
}
    } else {
      alarmTime = documentSnapshot['alarmTime'];
      minutesSinceMidnight = documentSnapshot['minutesSinceMidnight'];
    }
    snoozeDuration = documentSnapshot['snoozeDuration'];
    maxSnoozeCount = documentSnapshot['maxSnoozeCount'] ?? 3;
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
    locationConditionType = documentSnapshot['locationConditionType'] ?? 2; 
    isWeatherEnabled = documentSnapshot['isWeatherEnabled'];
    weatherConditionType = documentSnapshot['weatherConditionType'] ?? 2; 
    activityConditionType = documentSnapshot['activityConditionType'] ?? 2; 
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

    activityMonitor = documentSnapshot['activityMonitor'];
    alarmDate = documentSnapshot['alarmDate'];
    profile = documentSnapshot['profile'];

    isGuardian = documentSnapshot['isGuardian'];
    guardianTimer = documentSnapshot['guardianTimer'];
    guardian = documentSnapshot['guardian'];
    isCall = documentSnapshot['isCall'];
    ringOn = documentSnapshot['ringOn'];
    isSunriseEnabled = documentSnapshot['isSunriseEnabled'] ?? false;
    sunriseDuration = documentSnapshot['sunriseDuration'] ?? 30;
    sunriseIntensity = documentSnapshot['sunriseIntensity'] ?? 1.0;
    sunriseColorScheme = documentSnapshot['sunriseColorScheme'] ?? 0;
    timezoneId = documentSnapshot['timezoneId'] ?? '';
    isTimezoneEnabled = documentSnapshot['isTimezoneEnabled'] ?? false;
    targetTimezoneOffset = documentSnapshot['targetTimezoneOffset'] ?? 0;
    // Handle smartControlCombinationType field safely
    final data = documentSnapshot.data() as Map<String, dynamic>?;
    smartControlCombinationType = data?['smartControlCombinationType'] ?? 0;
  }

  AlarmModel fromMapSQFlite(Map<String, dynamic> map) {
    return AlarmModel(
      alarmTime: map['alarmTime'],
      alarmID: map['alarmID'],
      isEnabled: map['isEnabled'] == 1,
      isLocationEnabled: map['isLocationEnabled'] == 1,
      locationConditionType: map['locationConditionType'] ?? 2, 
      isSharedAlarmEnabled: map['isSharedAlarmEnabled'] == 1,
      isWeatherEnabled: map['isWeatherEnabled'] == 1,
      weatherConditionType: map['weatherConditionType'] ?? 2, 
      activityConditionType: map['activityConditionType'] ?? 2, 
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
      isSunriseEnabled: map['isSunriseEnabled'] == 1,
      sunriseDuration: map['sunriseDuration'] ?? 30,
      sunriseIntensity: map['sunriseIntensity'] ?? 1.0,
      sunriseColorScheme: map['sunriseColorScheme'] ?? 0,
      timezoneId: map['timezoneId'] ?? '',
      isTimezoneEnabled: map['isTimezoneEnabled'] == 1,
      targetTimezoneOffset: map['targetTimezoneOffset'] ?? 0,
      smartControlCombinationType: map['smartControlCombinationType'] ?? 0,
    );
  }

  Map<String, dynamic> toSQFliteMap() {
    return {
      'firestoreId': firestoreId,
      'alarmTime': alarmTime,
      'alarmID': alarmID,
      'isEnabled': isEnabled ? 1 : 0,
      'isLocationEnabled': isLocationEnabled ? 1 : 0,
      'locationConditionType': locationConditionType,
      'isSharedAlarmEnabled': isSharedAlarmEnabled ? 1 : 0,
      'isWeatherEnabled': isWeatherEnabled ? 1 : 0,
      'weatherConditionType': weatherConditionType,
      'activityConditionType': activityConditionType,
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
      'isSunriseEnabled': isSunriseEnabled ? 1 : 0,
      'sunriseDuration': sunriseDuration,
      'sunriseIntensity': sunriseIntensity,
      'sunriseColorScheme': sunriseColorScheme,
      'timezoneId': timezoneId,
      'isTimezoneEnabled': isTimezoneEnabled ? 1 : 0,
      'targetTimezoneOffset': targetTimezoneOffset,
      'smartControlCombinationType': smartControlCombinationType,
    };
  }

  AlarmModel.fromMap(Map<String, dynamic> alarmData) {
    // Making sure the alarms work with the offsets
    mainAlarmTime = alarmData['alarmTime'];
    snoozeDuration = alarmData['snoozeDuration'];
    maxSnoozeCount = alarmData['maxSnoozeCount'] ?? 3;
    gradient = alarmData['gradient'];
    isSharedAlarmEnabled = alarmData['isSharedAlarmEnabled'];
    minutesSinceMidnight = alarmData['minutesSinceMidnight'];
    alarmTime = alarmData['alarmTime'];
    firestoreId = alarmData['firestoreId'];
    alarmID = alarmData['alarmID'];
    sharedUserIds = List<String>.from(alarmData['sharedUserIds']);
    lastEditedUserId = alarmData['lastEditedUserId'];
    mutexLock = alarmData['mutexLock'];
    ownerId = alarmData['ownerId'];
    ownerName = alarmData['ownerName'];
    days = List<bool>.from(alarmData['days']);
    isEnabled = alarmData['isEnabled'];
    intervalToAlarm = alarmData['intervalToAlarm'];
    isActivityEnabled = alarmData['isActivityEnabled'];
    activityInterval = alarmData['activityInterval'];

    isLocationEnabled = alarmData['isLocationEnabled'];
    locationConditionType = alarmData['locationConditionType'] ?? 2; 
    isWeatherEnabled = alarmData['isWeatherEnabled'];
    weatherConditionType = alarmData['weatherConditionType'] ?? 2; 
    activityConditionType = alarmData['activityConditionType'] ?? 2; 
    weatherTypes = List<int>.from(alarmData['weatherTypes']);
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

    activityMonitor = alarmData['activityMonitor'];
    alarmDate = alarmData['alarmDate'];
    profile = alarmData['profile'];

    isGuardian = alarmData['isGuardian'];
    guardianTimer = alarmData['guardianTimer'];
    guardian = alarmData['guardian'];
    isCall = alarmData['isCall'];
    ringOn = alarmData['ringOn'];
    isSunriseEnabled = alarmData['isSunriseEnabled'] ?? false;
    sunriseDuration = alarmData['sunriseDuration'] ?? 30;
    sunriseIntensity = alarmData['sunriseIntensity'] ?? 1.0;
    sunriseColorScheme = alarmData['sunriseColorScheme'] ?? 0;
    timezoneId = alarmData['timezoneId'] ?? '';
    isTimezoneEnabled = alarmData['isTimezoneEnabled'] ?? false;
    targetTimezoneOffset = alarmData['targetTimezoneOffset'] ?? 0;
    smartControlCombinationType = alarmData['smartControlCombinationType'] ?? 0;
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
      'weatherConditionType': alarmRecord.weatherConditionType,
      'activityConditionType': alarmRecord.activityConditionType,
      'activityInterval': alarmRecord.activityInterval,
      'minutesSinceMidnight': alarmRecord.minutesSinceMidnight,
      'isLocationEnabled': alarmRecord.isLocationEnabled,
      'locationConditionType': alarmRecord.locationConditionType,
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
      'ringOn': alarmRecord.ringOn,
      'isSunriseEnabled': alarmRecord.isSunriseEnabled,
      'sunriseDuration': alarmRecord.sunriseDuration,
      'sunriseIntensity': alarmRecord.sunriseIntensity,
      'sunriseColorScheme': alarmRecord.sunriseColorScheme,
      'timezoneId': alarmRecord.timezoneId,
      'isTimezoneEnabled': alarmRecord.isTimezoneEnabled,
      'targetTimezoneOffset': alarmRecord.targetTimezoneOffset,
      'smartControlCombinationType': alarmRecord.smartControlCombinationType,
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
}
