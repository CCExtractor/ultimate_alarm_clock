import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';

import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';

import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';

import '../../home/controllers/home_controller.dart';

class AlarmControlController extends GetxController {
  MethodChannel alarmChannel = MethodChannel('ulticlock');
  RxString note = ''.obs;
  Timer? vibrationTimer;
  late StreamSubscription<FGBGType> _subscription;
  TimeOfDay currentTime = TimeOfDay.now();
  late RxBool isSnoozing = false.obs;
  RxInt minutes = 1.obs;
  RxInt seconds = 0.obs;
  RxBool showButton = false.obs;
  HomeController homeController = Get.find<HomeController>();
  SettingsController settingsController = Get.find<SettingsController>();
  RxBool get is24HourFormat => settingsController.is24HrsEnabled;
  Rx<AlarmModel> currentlyRingingAlarm = Utils.alarmModelInit.obs;
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  final timeNow =
      Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now())).obs;
  final timeNow24Hr = Utils.timeOfDayToString(TimeOfDay.now()).obs;
  Timer? _currentTimeTimer;
  bool isAlarmActive = true;
  late double initialVolume;
  late Timer guardianTimer;
  RxInt guardianCoundown = 120.obs;

  getNextAlarm() async {
    UserModel? _userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel _alarmRecord = homeController.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, true);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_userModel, _alarmRecord, true);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    debugPrint('LATEST : ${latestAlarm.alarmTime}');

    return latestAlarm;
  }

  void addMinutes(int incrementMinutes) {
    minutes.value += incrementMinutes;
  }

  void startSnooze() async {
    Vibration.cancel();
    vibrationTimer!.cancel();
    isSnoozing.value = true;
    String ringtoneName = currentlyRingingAlarm.value.ringtoneName;
    AudioUtils.stopAlarm(ringtoneName: ringtoneName);

    if (_currentTimeTimer!.isActive) {
      _currentTimeTimer?.cancel();
    }

    _currentTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel();
        vibrationTimer =
            Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
          Vibration.vibrate(pattern: [500, 3000]);
        });

        AudioUtils.playAlarm(alarmRecord: currentlyRingingAlarm.value);

        startTimer();
      } else if (seconds.value == 0) {
        minutes.value--;
        seconds.value = 59;
      } else {
        seconds.value--;
      }
    });
  }

  void startTimer() {
    minutes.value = currentlyRingingAlarm.value.snoozeDuration;
    isSnoozing.value = false;
    _currentTimeTimer = Timer.periodic(
        Duration(
          milliseconds: Utils.getMillisecondsToAlarm(
            DateTime.now(),
            DateTime.now().add(const Duration(minutes: 1)),
          ),
        ), (timer) {
      formattedDate.value = Utils.getFormattedDate(DateTime.now());
      timeNow.value =
          Utils.convertTo12HourFormat(Utils.timeOfDayToString(TimeOfDay.now()));
    });
  }

  Future<void> _fadeInAlarmVolume() async {
    await FlutterVolumeController.setVolume(
      currentlyRingingAlarm.value.volMin / 10.0,
      stream: AudioStream.alarm,
    );
    await Future.delayed(const Duration(milliseconds: 2000));

    double vol = currentlyRingingAlarm.value.volMin / 10.0;
    double diff = (currentlyRingingAlarm.value.volMax -
            currentlyRingingAlarm.value.volMin) /
        10.0;
    int len = currentlyRingingAlarm.value.gradient * 1000;
    double steps = (diff / 0.01).abs();
    int stepLen = max(4, (steps > 0) ? len ~/ steps : len);
    int lastTick = DateTime.now().millisecondsSinceEpoch;

    Timer.periodic(Duration(milliseconds: stepLen), (Timer t) {
      if (!isAlarmActive) {
        t.cancel();
        return;
      }

      var now = DateTime.now().millisecondsSinceEpoch;
      var tick = (now - lastTick) / len;
      lastTick = now;
      vol += diff * tick;

      vol = max(currentlyRingingAlarm.value.volMin / 10.0, vol);
      vol = min(currentlyRingingAlarm.value.volMax / 10.0, vol);
      vol = (vol * 100).round() / 100;

      FlutterVolumeController.setVolume(
        vol,
        stream: AudioStream.alarm,
      );

      if (vol >= currentlyRingingAlarm.value.volMax / 10.0) {
        t.cancel();
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    currentlyRingingAlarm.value = Get.arguments;
    print('hwyooo ${currentlyRingingAlarm.value.isGuardian}');
    if (currentlyRingingAlarm.value.isGuardian) {
      guardianTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        print(guardianCoundown.value);
        if (guardianCoundown.value == 0) {
          currentlyRingingAlarm.value.isCall
              ? Utils.dialNumber(currentlyRingingAlarm.value.guardian)
              : Utils.sendSMS(currentlyRingingAlarm.value.guardian,
                  "Your Friend is not waking up \n - Ultimate Alarm Clock");
          timer.cancel();
        } else {
          guardianCoundown.value = guardianCoundown.value - 1;
        }
      });
    }

    showButton.value = true;
    initialVolume = await FlutterVolumeController.getVolume(
      stream: AudioStream.alarm,
    ) as double;

    FlutterVolumeController.updateShowSystemUI(false);

    // _fadeInAlarmVolume();     TODO fix volume fade-in

    if (currentlyRingingAlarm.value.deleteAfterGoesOff == true) {
      if (currentlyRingingAlarm.value.isSharedAlarmEnabled) {
        FirestoreDb.deleteOneTimeAlarm(
          currentlyRingingAlarm.value.ownerId,
          currentlyRingingAlarm.value.firestoreId,
        );
      } else {
        IsarDb.deleteAlarm(currentlyRingingAlarm.value.isarId);
      }
    }
    vibrationTimer =
        Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
      Vibration.vibrate(pattern: [500, 3000]);
    });

    // Preventing app from being minimized!
    _subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        alarmChannel.invokeMethod('bringAppToForeground');
      }
    });

    startTimer();
    // if (Get.arguments == null) {
    //   currentlyRingingAlarm.value = await getCurrentlyRingingAlarm();
    //   showButton.value = true;
    //   // If the alarm is set to NEVER repeat, then it will
    //   // be chosen as the next alarm to ring by default as
    //   // it would ring the next day
    //   if (currentlyRingingAlarm.value.days
    //       .every((element) => element == false)) {
    //     currentlyRingingAlarm.value.isEnabled = false;
    //
    //     if (currentlyRingingAlarm.value.isSharedAlarmEnabled == false) {
    //       IsarDb.updateAlarm(currentlyRingingAlarm.value);
    //     } else {
    //       FirestoreDb.updateAlarm(
    //         currentlyRingingAlarm.value.ownerId,
    //         currentlyRingingAlarm.value,
    //       );
    //     }
    //   } else if (currentlyRingingAlarm.value.isOneTime == true) {
    //     // If the alarm has to repeat on one day, but ring just once, we will
    //     // keep seting its days to false until it will never ring
    //     int currentDay = DateTime.now().weekday - 1;
    //     currentlyRingingAlarm.value.days[currentDay] = false;
    //
    //     if (currentlyRingingAlarm.value.days
    //         .every((element) => element == false)) {
    //       currentlyRingingAlarm.value.isEnabled = false;
    //     }
    //
    //     if (currentlyRingingAlarm.value.isSharedAlarmEnabled == false) {
    //       IsarDb.updateAlarm(currentlyRingingAlarm.value);
    //     } else {
    //       FirestoreDb.updateAlarm(
    //         currentlyRingingAlarm.value.ownerId,
    //         currentlyRingingAlarm.value,
    //       );
    //     }
    //   }
    // } else {
    //   currentlyRingingAlarm.value = Get.arguments;
    //   showButton.value = true;
    // }

    AudioUtils.playAlarm(alarmRecord: currentlyRingingAlarm.value);

    // Setting snooze duration
    minutes.value = currentlyRingingAlarm.value.snoozeDuration;

    // Scheduling next alarm if it's not in preview mode
    if (Get.arguments == null) {
      // Finding the next alarm to ring
      AlarmModel latestAlarm = await getNextAlarm();
      TimeOfDay latestAlarmTimeOfDay =
          Utils.stringToTimeOfDay(latestAlarm.alarmTime);

      // }
      // This condition will never satisfy because this will only
      // occur if fake model is returned as latest alarm
      if (latestAlarm.isEnabled == false) {
        debugPrint(
          'STOPPED IF CONDITION with latest = '
          '${latestAlarmTimeOfDay.toString()} and '
          'current = ${currentTime.toString()}',
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
            'activityMonitor': latestAlarm.activityMonitor
          });
          print("Scheduled...");
        } on PlatformException catch (e) {
          print("Failed to schedule alarm: ${e.message}");
        }
      }
    }
  }

  @override
  void onClose() async {
    super.onClose();
    Vibration.cancel();
    vibrationTimer!.cancel();
    isAlarmActive = false;
    String ringtoneName = currentlyRingingAlarm.value.ringtoneName;
    AudioUtils.stopAlarm(ringtoneName: ringtoneName);
    await FlutterVolumeController.setVolume(
      initialVolume,
      stream: AudioStream.alarm,
    );
    _subscription.cancel();
    _currentTimeTimer?.cancel();
  }
}
