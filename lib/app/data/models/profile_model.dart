import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import 'package:isar/isar.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
part 'profile_model.g.dart';

@collection
class ProfileModel {
  Id isarId = Isar.autoIncrement;
  late String profileName;
  String? firestoreId;
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
  late int activityMonitor;
  @ignore
  Map? offsetDetails;

  ProfileModel(
      {
        required this.profileName,
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
        required this.activityMonitor});

  ProfileModel.fromDocumentSnapshot({
    required firestore.DocumentSnapshot documentSnapshot,
    required UserModel? user,
  }) {
    // Making sure the profiles work with the offsets
    isSharedAlarmEnabled = documentSnapshot['isSharedAlarmEnabled'];
    offsetDetails = documentSnapshot['offsetDetails'];

    if (isSharedAlarmEnabled && user != null) {
      // Using offsetted time only if it is enabled

      minutesSinceMidnight = Utils.timeOfDayToInt(
        Utils.stringToTimeOfDay(offsetDetails![user.id]['offsettedTime']),
      );
    } else {
      minutesSinceMidnight = documentSnapshot['minutesSinceMidnight'];
    }
    snoozeDuration = documentSnapshot['snoozeDuration'];
    gradient = documentSnapshot['gradient'];
    label = documentSnapshot['label'];
    isOneTime = documentSnapshot['isOneTime'];
    firestoreId = documentSnapshot.id;
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

    activityMonitor = documentSnapshot['activityMonitor'];
  }
  ProfileModel fromMapSQFlite(Map<String, dynamic> map) {
    return ProfileModel(
        profileName: map['profileName'],
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
        label: map['label'],
        isOneTime: map['isOneTime'] == 1,
        snoozeDuration: map['snoozeDuration'],
        gradient: map['gradient'],
        ringtoneName: map['ringtoneName'],
        note: map['note'],
        deleteAfterGoesOff: map['deleteAfterGoesOff'] == 1,
        showMotivationalQuote: map['showMotivationalQuote'] == 1,
        volMin: map['volMin'],
        volMax: map['volMax'],
        activityMonitor: map['activityMonitor']);
  }

  Map<String, dynamic> toSQFliteMap() {
    return {
      'profileName': profileName,
      'firestoreId': firestoreId,
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
      'label': label,
      'isOneTime': isOneTime ? 1 : 0,
      'snoozeDuration': snoozeDuration,
      'gradient': gradient,
      'ringtoneName': ringtoneName,
      'note': note,
      'deleteAfterGoesOff': deleteAfterGoesOff ? 1 : 0,
      'showMotivationalQuote': showMotivationalQuote ? 1 : 0,
      'volMin': volMin,
      'volMax': volMax,
      'activityMonitor' : activityMonitor
    };
  }

  ProfileModel.fromMap(Map<String, dynamic> profileData) {
    // Making sure the profiles work with the offsets
    profileName = profileData['profileName'];
    snoozeDuration = profileData['snoozeDuration'];
    gradient = profileData['gradient'];
    isSharedAlarmEnabled = profileData['isSharedAlarmEnabled'];
    minutesSinceMidnight = profileData['minutesSinceMidnight'];
    firestoreId = profileData['firestoreId'];
    sharedUserIds = profileData['sharedUserIds'];
    lastEditedUserId = profileData['lastEditedUserId'];
    mutexLock = profileData['mutexLock'];
    ownerId = profileData['ownerId'];
    ownerName = profileData['ownerName'];
    days = profileData['days'];
    isEnabled = profileData['isEnabled'];
    intervalToAlarm = profileData['intervalToAlarm'];
    isActivityEnabled = profileData['isActivityEnabled'];
    isWeatherEnabled = profileData['isWeatherEnabled'];
    weatherTypes = profileData['weatherTypes'];

    activityInterval = profileData['activityInterval'];
    isLocationEnabled = profileData['isLocationEnabled'];
    isSharedAlarmEnabled = profileData['isSharedAlarmEnabled'];
    location = profileData['location'];

    isMathsEnabled = profileData['isMathsEnabled'];
    mathsDifficulty = profileData['mathsDifficulty'];
    numMathsQuestions = profileData['numMathsQuestions'];
    isQrEnabled = profileData['isQrEnabled'];
    qrValue = profileData['qrValue'];
    isShakeEnabled = profileData['isShakeEnabled'];
    shakeTimes = profileData['shakeTimes'];
    isPedometerEnabled = profileData['isPedometerEnabled'];
    numberOfSteps = profileData['numberOfSteps'];
    label = profileData['label'];
    isOneTime = profileData['isOneTime'];
    ringtoneName = profileData['ringtoneName'];
    note = profileData['note'];
    deleteAfterGoesOff = profileData['deleteAfterGoesOff'];
    showMotivationalQuote = profileData['showMotivationalQuote'];

    volMin = profileData['volMin'];
    volMax = profileData['volMax'];
    activityMonitor = profileData['activityMonitor'];
  }

  ProfileModel.fromJson(String profileData, UserModel? user) {
    ProfileModel.fromMap(jsonDecode(profileData));
  }

  static String toJson(ProfileModel profileRecord) {
    return jsonEncode(ProfileModel.toMap(profileRecord));
  }

  static Map<String, dynamic> toMap(ProfileModel profileRecord) {
    final profileMap = <String, dynamic>{
      'profileName' : profileRecord.profileName,
      'firestoreId': profileRecord.firestoreId,
      'ownerId': profileRecord.ownerId,
      'lastEditedUserId': profileRecord.lastEditedUserId,
      'mutexLock': profileRecord.mutexLock,
      'isOneTime': profileRecord.isOneTime,
      'label': profileRecord.label,
      'ownerName': profileRecord.ownerName,
      'sharedUserIds': profileRecord.sharedUserIds,
      'days': profileRecord.days,
      'intervalToAlarm': profileRecord.intervalToAlarm,
      'isEnabled': profileRecord.isEnabled,
      'isActivityEnabled': profileRecord.isActivityEnabled,
      'weatherTypes': profileRecord.weatherTypes,
      'isWeatherEnabled': profileRecord.isWeatherEnabled,
      'activityInterval': profileRecord.activityInterval,
      'minutesSinceMidnight': profileRecord.minutesSinceMidnight,
      'isLocationEnabled': profileRecord.isLocationEnabled,
      'location': profileRecord.location,
      'isSharedAlarmEnabled': profileRecord.isSharedAlarmEnabled,
      'isMathsEnabled': profileRecord.isMathsEnabled,
      'mathsDifficulty': profileRecord.mathsDifficulty,
      'numMathsQuestions': profileRecord.numMathsQuestions,
      'isQrEnabled': profileRecord.isQrEnabled,
      'qrValue': profileRecord.qrValue,
      'isShakeEnabled': profileRecord.isShakeEnabled,
      'shakeTimes': profileRecord.shakeTimes,
      'isPedometerEnabled': profileRecord.isPedometerEnabled,
      'numberOfSteps': profileRecord.numberOfSteps,
      'snoozeDuration': profileRecord.snoozeDuration,
      'gradient': profileRecord.gradient,
      'ringtoneName': profileRecord.ringtoneName,
      'note': profileRecord.note,
      'deleteAfterGoesOff': profileRecord.deleteAfterGoesOff,
      'showMotivationalQuote': profileRecord.showMotivationalQuote,
      'volMin': profileRecord.volMin,
      'volMax': profileRecord.volMax,
      'activityMonitor' : profileRecord.activityMonitor
    };

    if (profileRecord.isSharedAlarmEnabled) {
      profileMap['offsetDetails'] = profileRecord.offsetDetails;
    }
    return profileMap;
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
