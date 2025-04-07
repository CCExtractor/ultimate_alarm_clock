import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/calendar/v3.dart' as CalendarApi;
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/quote_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../../data/models/profile_model.dart';
import '../../../data/providers/google_cloud_api_provider.dart';

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);
}

class HomeController extends GetxController {
  MethodChannel alarmChannel = const MethodChannel('ulticlock');

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
  Timer? _delayTimer;
  Timer _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {});
  List alarms = [].obs;
  List notifications = [].obs;

  int lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
  Timer? delayToSchedule;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      CalendarApi.CalendarApi.calendarScope,
    ],
  );
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxBool isUserSignedIn = false.obs;
  final floatingButtonKey = GlobalKey<ExpandableFabState>();
  final floatingButtonKeyLoggedOut = GlobalKey<ExpandableFabState>();

  final alarmIdController = TextEditingController();

  ScrollController scrollController = ScrollController();
  RxDouble scalingFactor = 1.0.obs;

  RxBool isSortedAlarmListEnabled = true.obs;
  RxBool inMultipleSelectMode = false.obs;
  RxBool isAnyAlarmHolded = false.obs;
  RxBool isAllAlarmsSelected = false.obs;
  RxInt numberOfAlarmsSelected = 0.obs;
  Pair<List<AlarmModel>, List<RxBool>> alarmListPairs = Pair([], []);

  Set<Pair<dynamic, bool>> selectedAlarmSet = {};

  final RxInt duration = 3.obs;
  final RxDouble selecteddurationDouble = 0.0.obs;

  ThemeController themeController = Get.find<ThemeController>();
  RxList Calendars = [].obs;
  RxList Events = [].obs;
  final RxString calendarFetchStatus = 'Loading'.obs;
  final RxString selectedCalendar = ''.obs;
  RxBool isCalender = true.obs;
  RxBool expandProfile = false.obs;

  RxBool isProfile = false.obs;
  RxString selectedProfile = ''.obs;
  Rx<ProfileModel> profileModel = Utils.genDefaultProfileModel().obs;

  final storage = Get.find<GetStorageProvider>();

  RxBool isProfileUpdate = false.obs;

  loginWithGoogle() async {
    // Logging in again to ensure right details if User has linked account
    if (await SecureStorageProvider().retrieveUserModel() != null) {
      if (await _googleSignIn.isSignedIn()) {
        GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signInSilently();
        String fullName = googleSignInAccount!.displayName.toString();
        List<String> parts = fullName.split(' ');
        String lastName = ' ';
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
    isarStreamAlarms = IsarDb.getAlarms(selectedProfile.value);
    sharedAlarmsStream = FirestoreDb.getSharedAlarms(userModel.value);
    Stream<List<AlarmModel>> streamAlarms = rx.Rx.combineLatest2(
      firestoreStreamAlarms!,
      isarStreamAlarms!,
      (firestoreData, isarData) {
        List<DocumentSnapshot> firestoreDocuments = firestoreData.docs;
        latestFirestoreAlarms = firestoreDocuments.map((doc) {
          return AlarmModel.fromDocumentSnapshot(
            documentSnapshot: doc,
            user: user,
          );
        }).toList();

        latestIsarAlarms = isarData as List<AlarmModel>;

        List<AlarmModel> alarms = [
          ...latestFirestoreAlarms,
          ...latestIsarAlarms,
        ];

        if (isSortedAlarmListEnabled.value) {
          alarms.sort((a, b) {
            final String timeA = a.alarmTime;
            final String timeB = b.alarmTime;

            // Convert the alarm time strings to DateTime objects for comparison
            DateTime dateTimeA = DateFormat('HH:mm').parse(timeA);
            DateTime dateTimeB = DateFormat('HH:mm').parse(timeB);

            // Compare the DateTime objects to sort in ascending order
            return dateTimeA.compareTo(dateTimeB);
          });
        } else {
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
              // If alarm is one-time and has already passed, set upcoming time
              // to next day
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
              // If alarm is one-time and has already passed, set upcoming time
              // to next day
              if (bUpcomingTime <=
                  DateTime.now().hour * 60 + DateTime.now().minute) {
                bUpcomingTime += Duration.minutesPerDay;
              }
            }

            return aUpcomingTime.compareTo(bUpcomingTime);
          });
        }

        return alarms;
      },
    );

    return streamAlarms;
  }

  void readProfileName() async {
    String profileName = await storage.readProfile();
    selectedProfile.value = profileName;
    ProfileModel? p = await IsarDb.getProfile(profileName);
    if (p != null)
    {
      profileModel.value = p!;
    }
    
  }

  void writeProfileName(String name) async {
    await storage.writeProfile(name);
    selectedProfile.value = name;
    ProfileModel? p = await IsarDb.getProfile(name);
    if (p != null)
    {
      profileModel.value = p!;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    final checkDefault = await IsarDb.getProfile('Default');
    if (checkDefault == null) {
      IsarDb.addProfile(Utils.genDefaultProfileModel());
      await storage.writeProfile("Default");
      profileModel.value = Utils.genDefaultProfileModel();
    }
    readProfileName();

    userModel.value = await SecureStorageProvider().retrieveUserModel();
    if (userModel.value == null){
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        isUserSignedIn.value = false;
      } else {
        isUserSignedIn.value = true;
      }
    });
    }
    else {
        isUserSignedIn.value = true;
    }


    isSortedAlarmListEnabled.value = await SecureStorageProvider()
        .readSortedAlarmListValue(key: 'sorted_alarm_list');

    scrollController.addListener(() {
      final offset = scrollController.offset;
      const maxOffset = 100.0;
      const minFactor = 0.8;
      const maxFactor = 1.0;

      final newFactor = 1.0 - (offset / maxOffset).clamp(0.0, 1.0);
      scalingFactor.value = (minFactor + (maxFactor - minFactor) * newFactor);
    });

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

    delayToSchedule = Timer(const Duration(seconds: 1), () async {
      lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
      // Cancel timer if we have to refresh
      if (refreshTimer == true) {
        if (_timer.isActive) _timer.cancel();
        if (_delayTimer != null) _delayTimer?.cancel();
        refreshTimer = false;
      }

      // Fake object to get latest alarm
      AlarmModel alarmRecord = genFakeAlarmModel();
      AlarmModel isarLatestAlarm =
          await IsarDb.getLatestAlarm(alarmRecord, true);

      AlarmModel firestoreLatestAlarm =
          await FirestoreDb.getLatestAlarm(userModel.value, alarmRecord, true);
      AlarmModel latestAlarm =
          Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

      debugPrint('ISAR: ${isarLatestAlarm.alarmTime}');
      debugPrint('Fire: ${firestoreLatestAlarm.alarmTime}');

      String timeToAlarm = Utils.timeUntilAlarm(
        Utils.stringToTimeOfDay(latestAlarm.alarmTime),
        latestAlarm.days,
      );
      alarmTime.value = 'Rings in $timeToAlarm';
      // This function is necessary when alarms are deleted/enabled
      await scheduleNextAlarm(
        alarmRecord,
        isarLatestAlarm,
        firestoreLatestAlarm,
        latestAlarm,
      );

      if (latestAlarm.minutesSinceMidnight > -1) {
        // To account for difference between seconds upto the next minute
        DateTime now = DateTime.now();
        DateTime nextMinute =
            DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
        Duration delay = nextMinute.difference(now).inMilliseconds > 0
            ? nextMinute.difference(now)
            : Duration.zero;

        // Adding a delay till that difference between seconds up to the next
        // minute
        _delayTimer = Timer(delay, () {
          // Update the value of timeToAlarm only once till it settles it's time
          // with the upcoming alarm
          // Doing this because of an bug :
          // If we are not doing the below three lines of code the
          // time is not updating for 2 min after running
          // Why is it happening?? -> BECAUSE OUR VALUE WILL BE UPDATED
          // AFTER 1 MIN ACCORDING TO BELOW TIMER WHICH WILL CAUSE
          // MISCALCULATION FOR INITIAL MINUTES
          // This is just to make sure that our calculated time-to-alarm is
          // up to date with the real time for next alarm
          timeToAlarm = Utils.timeUntilAlarm(
            Utils.stringToTimeOfDay(latestAlarm.alarmTime),
            latestAlarm.days,
          );
          alarmTime.value = 'Rings in $timeToAlarm';

          // Running a timer of periodic one minute as it is now in sync with
          // the current time
          _timer = Timer.periodic(
              Duration(
                milliseconds: Utils.getMillisecondsToAlarm(
                  DateTime.now(),
                  DateTime.now().add(const Duration(minutes: 1)),
                ),
              ), (timer) {
            timeToAlarm = Utils.timeUntilAlarm(
              Utils.stringToTimeOfDay(latestAlarm.alarmTime),
              latestAlarm.days,
            );
            alarmTime.value = 'Rings in $timeToAlarm';
          });
        });
      } else {
        alarmTime.value = 'No upcoming alarms!';
      }
    });
  }

  scheduleNextAlarm(
    AlarmModel alarmRecord,
    AlarmModel isarLatestAlarm,
    AlarmModel firestoreLatestAlarm,
    AlarmModel latestAlarm,
  ) async {
    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);
    if (latestAlarm.isEnabled == false) {
      debugPrint(
        'STOPPED IF CONDITION with latest = ${latestAlarmTimeOfDay.toString()}',
      );
      await alarmChannel.invokeMethod('cancelAllScheduledAlarms');
    } else {
      int intervaltoAlarm = Utils.getMillisecondsToAlarm(
        DateTime.now(),
        Utils.timeOfDayToDateTime(latestAlarmTimeOfDay),
      );
      try {
        await alarmChannel.invokeMethod('scheduleAlarm', {
          'milliSeconds': intervaltoAlarm,
          'activityMonitor': latestAlarm.activityMonitor,
        });
        print('Scheduled...');
      } on PlatformException catch (e) {
        print('Failed to schedule alarm: ${e.message}');
      }
    }
  }

  @override
  void onClose() {
    super.onClose();

    if (delayToSchedule != null) {
      delayToSchedule!.cancel();
    }
  }

  Future<void> fetchGoogleCalendars() async {
    Calendars.value = (await GoogleCloudProvider.getCalenders()) ?? [];
    if (Calendars.value == []) {
      calendarFetchStatus.value = 'Empty';
    } else {
      calendarFetchStatus.value = 'Loaded';
    }
  }

  Future<void> fetchEvents(String calenderId) async {
    Events.value = await GoogleCloudProvider.getEvents(calenderId) ?? [];
    if (Events.value == []) {
      calendarFetchStatus.value = 'Empty';
      Get.snackbar('Events', 'No events available');
    } else {
      calendarFetchStatus.value = 'Loaded';
      isCalender.value = false;
    }
    print(Events.value);
  }

  Future<void> setAlarmFromEvent(CalendarApi.Event event, String date) async {
    AlarmModel alarmModel = genFakeAlarmModel();
    alarmModel.alarmTime = Utils.formatDateTimeToHHMMSS(
      event.start?.dateTime?.toLocal() ?? event.start!.date!.toLocal(),
    );
    alarmModel.isEnabled = true;
    alarmModel.intervalToAlarm = Utils.calculateTimeDifference(
      event.start?.dateTime ?? event.start!.date!,
    );
    alarmModel.ringOn = true;

    alarmModel.label = event.summary!;
    alarmModel.isOneTime = true;
    isProfile.value = false;
    Get.toNamed(
      '/add-update-alarm',
      arguments: alarmModel,
    );
  }

  // Add all alarms to seleted alarm set
  void addAllAlarmsToSelectedAlarmSet() {
    for (int index = 0; index < alarmListPairs.first.length; index++) {
      AlarmModel alarm = alarmListPairs.first[index];
      alarmListPairs.second[index].value = true;
      selectedAlarmSet.add(
        alarm.isSharedAlarmEnabled
            ? Pair(
                alarm.firestoreId,
                true,
              )
            : Pair(
                alarm.isarId,
                false,
              ),
      );
    }
  }

  // Remove all alarms from the selected alarm set
  void removeAllAlarmsFromSelectedAlarmSet() {
    for (int index = 0; index < alarmListPairs.first.length; index++) {
      alarmListPairs.second[index].value = false;
      selectedAlarmSet.clear();
    }
  }

  // Delete alarms mentioned in the selected alarm set
  Future<void> deleteAlarms() async {
    try {
      if (selectedAlarmSet.isEmpty) {
        Get.snackbar(
          'Error',
          'No alarms selected for deletion',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      int successCount = 0;
      List<AlarmModel> deletedAlarms = [];

      for (var alarm in selectedAlarmSet) {
        var alarmId = alarm.first;
        var isSharedAlarmEnabled = alarm.second;

        try {
          if (isSharedAlarmEnabled) {
            
            AlarmModel? alarmToDelete = await FirestoreDb.getAlarm(userModel.value, alarmId);
            if (alarmToDelete != null) {
              deletedAlarms.add(alarmToDelete);
              await FirestoreDb.deleteAlarm(userModel.value, alarmId);
              successCount++;
            }
          } else {
            
            AlarmModel? alarmToDelete = await IsarDb.getAlarm(alarmId);
            if (alarmToDelete != null) {
              deletedAlarms.add(alarmToDelete);
              await IsarDb.deleteAlarm(alarmId);
              successCount++;
            }
          }
        } catch (e) {
          debugPrint('Error deleting alarm: $e');
          continue;
        }
      }

      if (successCount > 0) {
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }

        Get.snackbar(
          'Success',
          '$successCount ${successCount == 1 ? 'alarm' : 'alarms'} deleted',
          duration: Duration(seconds: duration.toInt()),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          mainButton: TextButton(
            onPressed: () async {
              
              for (var alarm in deletedAlarms) {
                if (alarm.isSharedAlarmEnabled) {
                  await FirestoreDb.addAlarm(userModel.value, alarm);
                } else {
                  await IsarDb.addAlarm(alarm);
                }
              }
              
              refreshTimer = true;
              refreshUpcomingAlarms();
            },
            child: Text(
              'Undo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

        
        selectedAlarmSet.clear();
        numberOfAlarmsSelected.value = 0;
      } else {
        Get.snackbar(
          'Error',
          'No alarms were deleted',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error in deleteAlarms: $e');
      Get.snackbar(
        'Error',
        'Failed to delete alarms',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> swipeToDeleteAlarm(UserModel? user, AlarmModel alarm) async {
    AlarmModel? alarmToDelete;

    if (alarm.isSharedAlarmEnabled == true) {
      alarmToDelete = await FirestoreDb.getAlarm(user, alarm.firestoreId!);
      await FirestoreDb.deleteAlarm(user, alarm.firestoreId!);
    } else {
      alarmToDelete = await IsarDb.getAlarm(alarm.isarId);
      await IsarDb.deleteAlarm(alarm.isarId);
    }

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.snackbar(
      'Alarm deleted',
      'The alarm has been deleted.',
      duration: Duration(seconds: duration.toInt()),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      mainButton: TextButton(
        onPressed: () async {
          if (alarm.isSharedAlarmEnabled == true) {
            await FirestoreDb.addAlarm(user, alarmToDelete!);
          } else {
            await IsarDb.addAlarm(alarmToDelete!);
          }
        },
        child: Text('Undo'.tr),
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) async {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      backgroundColor: themeController.secondaryBackgroundColor.value,
      title: 'Are you sure you want to delete these alarms?'.tr,
      titleStyle: Theme.of(context).textTheme.displaySmall,
      content: Column(
        children: [
          Text(
            'This action will permanently delete these alarms from your device.'
                .tr,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kprimaryColor),
                  ),
                  child: Text(
                    'Cancel'.tr,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: kprimaryBackgroundColor,
                        ),
                  ),
                ),
                Obx(
                  () => OutlinedButton(
                    onPressed: () async {
                      await deleteAlarms();

                      // Closing the multiple select mode
                      inMultipleSelectMode.value = false;
                      isAnyAlarmHolded.value = false;
                      isAllAlarmsSelected.value = false;

                      numberOfAlarmsSelected.value = 0;
                      selectedAlarmSet.clear();
                      // After deleting alarms, refreshing to schedule latest one
                      refreshTimer = true;
                      refreshUpcomingAlarms();

                      Get.offNamedUntil(
                        '/bottom-navigation-bar',
                        (route) => route.settings.name == '/splash-screen',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Okay'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getCurrentProfileModel() async {
    profileModel.value = (await IsarDb.getProfile(selectedProfile.value))!;
  }

  AlarmModel genFakeAlarmModel() {
    return AlarmModel(
        volMax: profileModel.value.volMax,
        volMin: profileModel.value.volMin,
        snoozeDuration: profileModel.value.snoozeDuration,
        gradient: profileModel.value.gradient,
        label: profileModel.value.label,
        isOneTime: profileModel.value.isOneTime,
        deleteAfterGoesOff: profileModel.value.deleteAfterGoesOff,
        offsetDetails: profileModel.value.offsetDetails,
        mainAlarmTime: Utils.timeOfDayToString(TimeOfDay.now()),
        lastEditedUserId: profileModel.value.lastEditedUserId,
        mutexLock: profileModel.value.mutexLock,
        ownerName: profileModel.value.ownerName,
        ownerId: profileModel.value.ownerId,
        alarmID: '',
        activityInterval: profileModel.value.activityInterval,
        isMathsEnabled: profileModel.value.isMathsEnabled,
        numMathsQuestions: profileModel.value.numMathsQuestions,
        mathsDifficulty: profileModel.value.mathsDifficulty,
        qrValue: profileModel.value.qrValue,
        isQrEnabled: profileModel.value.isQrEnabled,
        isShakeEnabled: profileModel.value.isShakeEnabled,
        shakeTimes: profileModel.value.shakeTimes,
        isPedometerEnabled: profileModel.value.isPedometerEnabled,
        numberOfSteps: profileModel.value.numberOfSteps,
        days: profileModel.value.days,
        weatherTypes: profileModel.value.weatherTypes,
        isWeatherEnabled: profileModel.value.isWeatherEnabled,
        isEnabled: profileModel.value.isEnabled,
        isActivityEnabled: profileModel.value.isActivityEnabled,
        isLocationEnabled: profileModel.value.isLocationEnabled,
        isSharedAlarmEnabled: profileModel.value.isSharedAlarmEnabled,
        intervalToAlarm: 0,
        location: profileModel.value.location,
        alarmTime: Utils.timeOfDayToString(TimeOfDay.now()),
        minutesSinceMidnight: Utils.timeOfDayToInt(TimeOfDay.now()),
        ringtoneName: profileModel.value.ringtoneName,
        note: profileModel.value.note,
        showMotivationalQuote: profileModel.value.showMotivationalQuote,
        activityMonitor: profileModel.value.activityMonitor,
        alarmDate: profileModel.value.alarmDate,
        profile: profileModel.value.profileName,
        isGuardian: profileModel.value.isGuardian,
        guardianTimer: profileModel.value.guardianTimer,
        guardian: profileModel.value.guardian,
        isCall: profileModel.value.isCall,
        ringOn: false);
  }
}
