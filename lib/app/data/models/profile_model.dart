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
  late String alarmDate;
  late bool ringOn;
  late int activityMonitor;
  late bool isGuardian;
  late int guardianTimer;
  late String guardian;
  late bool isCall;
  @ignore
  List<Map>? offsetDetails;

  ProfileModel(
      {required this.profileName,
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
      this.offsetDetails = const [{}],
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
      required this.activityMonitor,
      required this.alarmDate,
      required this.ringOn,
      required this.isGuardian,
      required this.guardianTimer,
      required this.guardian,
      required this.isCall});

  ProfileModel.fromDocumentSnapshot({
    required firestore.DocumentSnapshot documentSnapshot,
    required UserModel? user,
  }) {
    // Making sure the profiles work with the offsets
    isSharedAlarmEnabled = documentSnapshot['isSharedAlarmEnabled'];
    offsetDetails = documentSnapshot['offsetDetails'];

    if (isSharedAlarmEnabled && user != null) {
      // Using offsetted time only if it is enabled

if (offsetDetails != null) {
  final userOffset = offsetDetails!
      .where((entry) => entry['userId'] == user.id)
      .toList();

  if (userOffset.isNotEmpty) {
    final data = userOffset.first;
    minutesSinceMidnight = Utils.timeOfDayToInt(
      Utils.stringToTimeOfDay(data['offsettedTime']),
    );
  }
}
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

    alarmDate = documentSnapshot['alarmDate'];
    isGuardian = documentSnapshot['isGuardian'];
    guardianTimer = documentSnapshot['guardianTimer'];
    guardian = documentSnapshot['guardian'];
    isGuardian = documentSnapshot['isGuardian'];
    guardianTimer = documentSnapshot['guardianTimer'];
    guardian = documentSnapshot['guardian'];
    isCall = documentSnapshot['isCall'];
  }

  ProfileModel.fromMap(Map<String, dynamic> profileData) {
    // Making sure the profiles work with the offsets
    profileName = profileData['profileName'];
    snoozeDuration = profileData['snoozeDuration'];
    gradient = profileData['gradient'];
    isSharedAlarmEnabled = profileData['isSharedAlarmEnabled'];
    minutesSinceMidnight = profileData['minutesSinceMidnight'];
    firestoreId = profileData['firestoreId'];
    sharedUserIds = List<String>.from(profileData['sharedUserIds']);
    lastEditedUserId = profileData['lastEditedUserId'];
    mutexLock = profileData['mutexLock'];
    ownerId = profileData['ownerId'];
    ownerName = profileData['ownerName'];
    days = List<bool>.from(profileData['days']);
    isEnabled = profileData['isEnabled'];
    intervalToAlarm = profileData['intervalToAlarm'];
    isActivityEnabled = profileData['isActivityEnabled'];
    isWeatherEnabled = profileData['isWeatherEnabled'];
    weatherTypes = List<int>.from(profileData['weatherTypes']);

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
    alarmDate = profileData['alarmDate'];
    isGuardian = profileData['isGuardian'];
    guardianTimer = profileData['guardianTimer'];
    guardian = profileData['guardian'];
    isCall = profileData['isCall'];
    ringOn = profileData['ringOn'];
  }

  ProfileModel.fromJson(String profileData, UserModel? user) {
    ProfileModel.fromMap(jsonDecode(profileData));
  }

  static String toJson(ProfileModel profileRecord) {
    return jsonEncode(ProfileModel.toMap(profileRecord));
  }

  static Map<String, dynamic> toMap(ProfileModel profileRecord) {
    final profileMap = <String, dynamic>{
      'profileName': profileRecord.profileName,
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
      'activityMonitor': profileRecord.activityMonitor,
      'alarmDate': profileRecord.alarmDate,
      'isGuardian': profileRecord.isGuardian,
      'guardianTimer': profileRecord.guardianTimer,
      'guardian': profileRecord.guardian,
      'isCall': profileRecord.isCall,
      'ringOn': profileRecord.ringOn
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

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
