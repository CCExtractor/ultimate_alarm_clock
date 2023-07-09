import 'dart:async';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class HomeController extends GetxController with AlarmHandlerSetupModel {
  Stream<QuerySnapshot>? firestoreStreamAlarms;
  Stream<QuerySnapshot>? sharedAlarmsStream;
  Stream? isarStreamAlarms;
  Stream? streamAlarms;
  List<AlarmModel> latestFirestoreAlarms = [];
  List<AlarmModel> latestIsarAlarms = [];
  List<AlarmModel> latestSharedAlarms = [];
  final alarmTime = 'No upcoming alarms!'.obs;
  bool refreshTimer = false;
  bool isEmpty = true;
  Timer _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {});
  List alarms = [].obs;
  int lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
  Timer? delayToSchedule;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxBool isUserSignedIn = false.obs;
  final floatingButtonKey = GlobalKey<ExpandableFabState>();
  final floatingButtonKeyLoggedOut = GlobalKey<ExpandableFabState>();

  final alarmIdController = TextEditingController();

  loginWithGoogle() async {
    // Logging in again to ensure right details if User has linked account
    if (await SecureStorageProvider().retrieveUserModel() != null) {
      if (await _googleSignIn.isSignedIn()) {
        GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signInSilently();
        String fullName = googleSignInAccount!.displayName.toString();
        List<String> parts = fullName.split(" ");
        String lastName = " ";
        if (parts.length == 3) {
          if (parts[parts.length - 1].length == 1) {
            lastName = parts[1].toLowerCase().capitalizeFirst.toString();
          } else {
            lastName = parts[parts.length - 1]
                .toLowerCase()
                .capitalizeFirst
                .toString();
          }
        } else {
          lastName =
              parts[parts.length - 1].toLowerCase().capitalizeFirst.toString();
        }
        String firstName = parts[0].toLowerCase().capitalizeFirst.toString();

        userModel.value = UserModel(
          id: googleSignInAccount.id,
          fullName: fullName,
          firstName: firstName,
          lastName: lastName,
          email: googleSignInAccount.email,
        );
        await SecureStorageProvider().storeUserModel(userModel.value!);
        isUserSignedIn.value = true;
      }
    }
  }

  initStream(UserModel? user) async {
    firestoreStreamAlarms = FirestoreDb.getAlarms(userModel.value);
    isarStreamAlarms = IsarDb.getAlarms();
    sharedAlarmsStream = FirestoreDb.getSharedAlarms(userModel.value);

    Stream<List<AlarmModel>> streamAlarms = rx.Rx.combineLatest3(
      firestoreStreamAlarms!,
      sharedAlarmsStream!,
      isarStreamAlarms!,
      (firestoreData, sharedData, isarData) {
        List<DocumentSnapshot> firestoreDocuments = firestoreData.docs;
        latestFirestoreAlarms = firestoreDocuments.map((doc) {
          return AlarmModel.fromDocumentSnapshot(
              documentSnapshot: doc, user: user);
        }).toList();

        List<DocumentSnapshot> sharedAlarmDocuments = sharedData.docs;
        latestSharedAlarms = sharedAlarmDocuments.map((doc) {
          return AlarmModel.fromDocumentSnapshot(
              documentSnapshot: doc, user: user);
        }).toList();

        latestFirestoreAlarms += latestSharedAlarms;
        latestIsarAlarms = isarData as List<AlarmModel>;

        List<AlarmModel> alarms = [
          ...latestFirestoreAlarms,
          ...latestIsarAlarms
        ];

        alarms.sort((a, b) {
          // First sort by isEnabled
          if (a.isEnabled != b.isEnabled) {
            return a.isEnabled ? -1 : 1;
          }

          // Then sort by upcoming time
          int aUpcomingTime = a.minutesSinceMidnight;
          int bUpcomingTime = b.minutesSinceMidnight;

          // Check if alarm repeats on any day
          bool aRepeats = a.days.any((day) => day);
          bool bRepeats = b.days.any((day) => day);

          // If alarm repeats on any day, find the next up+coming day
          if (aRepeats) {
            int currentDay = DateTime.now().weekday - 1;
            for (int i = 0; i < a.days.length; i++) {
              int dayIndex = (currentDay + i) % a.days.length;
              if (a.days[dayIndex]) {
                aUpcomingTime += i * Duration.minutesPerDay;
                break;
              }
            }
          } else {
            // If alarm is one-time and has already passed, set upcoming time to next day
            if (aUpcomingTime <=
                DateTime.now().hour * 60 + DateTime.now().minute) {
              aUpcomingTime += Duration.minutesPerDay;
            }
          }

          if (bRepeats) {
            int currentDay = DateTime.now().weekday - 1;
            for (int i = 0; i < b.days.length; i++) {
              int dayIndex = (currentDay + i) % b.days.length;
              if (b.days[dayIndex]) {
                bUpcomingTime += i * Duration.minutesPerDay;
                break;
              }
            }
          } else {
            // If alarm is one-time and has already passed, set upcoming time to next day
            if (bUpcomingTime <=
                DateTime.now().hour * 60 + DateTime.now().minute) {
              bUpcomingTime += Duration.minutesPerDay;
            }
          }

          return aUpcomingTime.compareTo(bUpcomingTime);
        });

        return alarms;
      },
    );

    return streamAlarms;
  }

  @override
  void onInit() async {
    super.onInit();
    if (!isUserSignedIn.value) await loginWithGoogle();
  }

  refreshUpcomingAlarms() async {
    // Check if 2 seconds have passed since the last call
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - lastRefreshTime < 2000) {
      delayToSchedule?.cancel();
    }

    if (delayToSchedule != null && delayToSchedule!.isActive) {
      return;
    }

    delayToSchedule = Timer(const Duration(seconds: 2), () async {
      lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
      // Cancel timer if we have to refresh
      if (refreshTimer == true && _timer.isActive) {
        _timer.cancel();
        refreshTimer = false;
      }

      // Fake object to get latest alarm
      AlarmModel alarmRecord = Utils.genFakeAlarmModel();
      AlarmModel isarLatestAlarm =
          await IsarDb.getLatestAlarm(alarmRecord, true);

      AlarmModel firestoreLatestAlarm =
          await FirestoreDb.getLatestAlarm(userModel.value, alarmRecord, true);
      AlarmModel latestAlarm =
          Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

      print("ISAR: ${isarLatestAlarm.alarmTime}");
      print("Fire: ${firestoreLatestAlarm.alarmTime}");

      String timeToAlarm = Utils.timeUntilAlarm(
          Utils.stringToTimeOfDay(latestAlarm.alarmTime), latestAlarm.days);
      alarmTime.value = "Rings in $timeToAlarm";

// This function is necessary when alarms are deleted/enabled
      await scheduleNextAlarm(
          alarmRecord, isarLatestAlarm, firestoreLatestAlarm, latestAlarm);

      if (latestAlarm.minutesSinceMidnight > -1) {
        // To account for difference between seconds upto the next minute
        DateTime now = DateTime.now();
        DateTime nextMinute =
            DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
        Duration delay = nextMinute.difference(now).inMilliseconds > 0
            ? nextMinute.difference(now)
            : Duration.zero;

        // Adding a delay till that difference between seconds upto the next minute
        await Future.delayed(delay);
        timeToAlarm = Utils.timeUntilAlarm(
            Utils.stringToTimeOfDay(latestAlarm.alarmTime), latestAlarm.days);
        alarmTime.value = "Rings in $timeToAlarm";
        _timer = Timer.periodic(
            Duration(
                milliseconds: Utils.getMillisecondsToAlarm(DateTime.now(),
                    DateTime.now().add(const Duration(minutes: 1)))), (timer) {
          timeToAlarm = Utils.timeUntilAlarm(
              Utils.stringToTimeOfDay(latestAlarm.alarmTime), latestAlarm.days);
          alarmTime.value = "Rings in $timeToAlarm";
        });
      } else {
        alarmTime.value = 'No upcoming alarms!';
      }
    });
  }

  scheduleNextAlarm(AlarmModel alarmRecord, AlarmModel isarLatestAlarm,
      AlarmModel firestoreLatestAlarm, AlarmModel latestAlarm) async {
    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);
    if (latestAlarm.isEnabled == false) {
      print(
          "STOPPED IF CONDITION with latest = ${latestAlarmTimeOfDay.toString()}");
      await stopForegroundTask();
    } else {
      int intervaltoAlarm = Utils.getMillisecondsToAlarm(
          DateTime.now(), Utils.timeOfDayToDateTime(latestAlarmTimeOfDay));
      if (await FlutterForegroundTask.isRunningService == false) {
        createForegroundTask(intervaltoAlarm);
        await startForegroundTask(latestAlarm);
      } else {
        await restartForegroundTask(latestAlarm, intervaltoAlarm);
      }
    }
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    delayToSchedule!.cancel();
  }
}
