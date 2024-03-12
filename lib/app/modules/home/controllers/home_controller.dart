import 'dart:async';
import 'package:flutter/services.dart';
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
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

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
  int lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
  Timer? delayToSchedule;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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

  loginWithGoogle() async {
    // Logging in again to ensure right details if User has linked account
    if (await SecureStorageProvider().retrieveUserModel() != null) {
      if (await _googleSignIn.isSignedIn()) {
        GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signInSilently();
        String fullName = googleSignInAccount!.displayName.toString();
        List<String> parts = fullName.split(' ');
        String lastName = ' ';
        if (parts.length == 3) {
          if (parts[parts.length - 1].length == 1) {
            lastName = parts[1].toLowerCase().capitalizeFirst.toString();
          } else {
            lastName = parts[parts.length - 1].toLowerCase().capitalizeFirst.toString();
          }
        } else {
          lastName = parts[parts.length - 1].toLowerCase().capitalizeFirst.toString();
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
            documentSnapshot: doc,
            user: user,
          );
        }).toList();

        List<DocumentSnapshot> sharedAlarmDocuments = sharedData.docs;
        latestSharedAlarms = sharedAlarmDocuments.map((doc) {
          return AlarmModel.fromDocumentSnapshot(
            documentSnapshot: doc,
            user: user,
          );
        }).toList();

        latestFirestoreAlarms += latestSharedAlarms;
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
              if (aUpcomingTime <= DateTime.now().hour * 60 + DateTime.now().minute) {
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
              if (bUpcomingTime <= DateTime.now().hour * 60 + DateTime.now().minute) {
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

  @override
  void onInit() async {
    super.onInit();

    if (!isUserSignedIn.value) await loginWithGoogle();

    isSortedAlarmListEnabled.value =
        await SecureStorageProvider().readSortedAlarmListValue(key: 'sorted_alarm_list');

    scrollController.addListener(() {
      final offset = scrollController.offset;
      const maxOffset = 100.0;
      const minFactor = 0.8;
      const maxFactor = 1.0;

      final newFactor = 1.0 - (offset / maxOffset).clamp(0.0, 1.0);
      scalingFactor.value = (minFactor + (maxFactor - minFactor) * newFactor);
    });

    if (Get.arguments != null) {
      bool showMotivationalQuote = Get.arguments.showMotivationalQuote;

      if (showMotivationalQuote) {
        Quote quote = Utils.getRandomQuote();
        showQuotePopup(quote);
      }
    }
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
      AlarmModel alarmRecord = Utils.genFakeAlarmModel();
      AlarmModel isarLatestAlarm = await IsarDb.getLatestAlarm(alarmRecord, true);

      AlarmModel firestoreLatestAlarm =
          await FirestoreDb.getLatestAlarm(userModel.value, alarmRecord, true);
      AlarmModel latestAlarm = Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

      debugPrint('ISAR: ${isarLatestAlarm.alarmTime}');
      debugPrint('Fire: ${firestoreLatestAlarm.alarmTime}');

      if (!latestAlarm.isTimer) {
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
          DateTime nextMinute = DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
          Duration delay = nextMinute.difference(now).inMilliseconds > 0
              ? nextMinute.difference(now)
              : Duration.zero;

          // Adding a delay till that difference between seconds upto the next
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
            // upto date with the real time for next alarm
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
      } else {
        await scheduleNextAlarm(
          alarmRecord,
          isarLatestAlarm,
          firestoreLatestAlarm,
          latestAlarm,
        );
      }
    });
  }

  scheduleNextAlarm(
    AlarmModel alarmRecord,
    AlarmModel isarLatestAlarm,
    AlarmModel firestoreLatestAlarm,
    AlarmModel latestAlarm,
  ) async {
    bool isTimer = latestAlarm.isTimer;

    if (isTimer) {
      DateTime? latestAlarmDateTime = Utils.stringToDateTime(latestAlarm.alarmTime);
      if (latestAlarmDateTime != null) {
        if (latestAlarm.isEnabled == false) {
          debugPrint(
            'STOPPED IF CONDITION with latest = ${latestAlarmDateTime.toString()}',
          );
          await alarmChannel.invokeMethod('cancelAllScheduledAlarms');
        } else {
          int intervaltoAlarm = Utils.getMillisecondsToAlarm(
            DateTime.now(),
            latestAlarmDateTime,
          );
          try {
            await alarmChannel.invokeMethod('scheduleAlarm', {'milliSeconds': intervaltoAlarm});
            print("Scheduled...");
          } on PlatformException catch (e) {
            print("Failed to schedule alarm: ${e.message}");
          }
        }
      }
    } else {
      TimeOfDay latestAlarmTimeOfDay = Utils.stringToTimeOfDay(latestAlarm.alarmTime);
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
          await alarmChannel.invokeMethod('scheduleAlarm', {'milliSeconds': intervaltoAlarm});
          print('Scheduled...');
        } on PlatformException catch (e) {
          print('Failed to schedule alarm: ${e.message}');
        }
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
    for (var alarm in selectedAlarmSet) {
      var alarmId = alarm.first;
      var isSharedAlarmEnabled = alarm.second;

      isSharedAlarmEnabled
          ? await FirestoreDb.deleteAlarm(
              userModel.value,
              alarmId,
            )
          : await IsarDb.deleteAlarm(alarmId);
    }
  }

  void showQuotePopup(Quote quote) {
    Get.defaultDialog(
      title: 'Motivational Quote',
      titlePadding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      backgroundColor: themeController.isLightMode.value
          ? kLightSecondaryBackgroundColor
          : ksecondaryBackgroundColor,
      titleStyle: TextStyle(
        color: themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor,
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          Text(
            quote.getQuote(),
            style: TextStyle(
              color: themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              quote.getAuthor(),
              style: TextStyle(
                color:
                    themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                kprimaryColor,
              ),
            ),
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Dismiss',
              style: TextStyle(
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor
                    : ksecondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
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
      backgroundColor: themeController.isLightMode.value
          ? kLightSecondaryBackgroundColor
          : ksecondaryBackgroundColor,
      title: 'Are you sure you want to delete these alarms?'.tr,
      titleStyle: Theme.of(context).textTheme.displaySmall,
      content: Column(
        children: [
          Text(
            'This action will permanently delete these alarms from your device.'.tr,
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
                OutlinedButton(
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
                      color: themeController.isLightMode.value
                          ? Colors.red.withOpacity(0.9)
                          : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Okay'.tr,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: themeController.isLightMode.value
                              ? Colors.red.withOpacity(0.9)
                              : Colors.red,
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
}
