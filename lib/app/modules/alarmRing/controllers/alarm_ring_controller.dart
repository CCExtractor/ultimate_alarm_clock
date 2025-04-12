import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/quote_model.dart';

import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';

import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
  StreamSubscription? _sensorSubscription;
  HomeController homeController = Get.find<HomeController>();
  ThemeController themeController = Get.find<ThemeController>();
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
  RxBool isPreviewMode = false.obs;
  RxInt snoozeCount = 0.obs;

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
    int maxCount = currentlyRingingAlarm.value.maxSnoozeCount > 0 ? 
                  currentlyRingingAlarm.value.maxSnoozeCount : 3;
                  
    if (snoozeCount.value >= maxCount) {
      Get.snackbar(
        'Maximum Snooze Limit Reached',
        'You have reached the maximum number of snoozes allowed for this alarm.',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        colorText: themeController.primaryTextColor.value,
        backgroundColor: themeController.secondaryBackgroundColor.value,
      );
      return;
    }
    snoozeCount.value++;
    
    Vibration.cancel();
    vibrationTimer!.cancel();
    isSnoozing.value = true;
    String ringtoneName = currentlyRingingAlarm.value.ringtoneName;
    AudioUtils.stopAlarm(ringtoneName: ringtoneName);

    if (_currentTimeTimer != null && _currentTimeTimer!.isActive) {
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
  void startListeningToFlip() {
    _sensorSubscription = accelerometerEvents.listen((event) {
      if (event.z < -8) { // Device is flipped (screen down)
        if (!isSnoozing.value && settingsController.isFlipToSnooze.value == true) {
          startSnooze();
        }
      }
    });
  }

  void showQuotePopup(Quote quote) {
    Get.defaultDialog(
      title: 'Motivational Quote',
      titlePadding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      backgroundColor: themeController.secondaryBackgroundColor.value,
      titleStyle: TextStyle(
        color: themeController.primaryTextColor.value,
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          Obx(
            () => Text(
              quote.getQuote(),
              style: TextStyle(
                color: themeController.primaryTextColor.value,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => Text(
                quote.getAuthor(),
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
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
                color: themeController.secondaryTextColor.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() async {
    super.onInit();
    startListeningToFlip();

    final args = Get.arguments;
    if (args is Map) {
      currentlyRingingAlarm.value = args['alarm'];
      isPreviewMode.value = args['preview'] ?? false;
    } else {
      currentlyRingingAlarm.value = args;
      isPreviewMode.value = false;
    }

    if (currentlyRingingAlarm.value.isGuardian) {
      guardianTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

    vibrationTimer =
        Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
          Vibration.vibrate(pattern: [500, 3000]);
        });

    _subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        alarmChannel.invokeMethod('bringAppToForeground');
      }
    });

    startTimer();

    AudioUtils.playAlarm(alarmRecord: currentlyRingingAlarm.value);

    if(currentlyRingingAlarm.value.showMotivationalQuote) {
      Quote quote = Utils.getRandomQuote();
      showQuotePopup(quote);
    }

    minutes.value = currentlyRingingAlarm.value.snoozeDuration;

    if (Get.arguments == null) {
      AlarmModel latestAlarm = await getNextAlarm();
      TimeOfDay latestAlarmTimeOfDay =
      Utils.stringToTimeOfDay(latestAlarm.alarmTime);

      if (latestAlarm.isEnabled == false) {
        await alarmChannel.invokeMethod('cancelAllScheduledAlarms');
      } else {
        int intervaltoAlarm = Utils.getMillisecondsToAlarm(
          DateTime.now(),
          Utils.timeOfDayToDateTime(latestAlarmTimeOfDay),
        );

        await alarmChannel.invokeMethod('scheduleAlarm', {
          'milliSeconds': intervaltoAlarm,
          'activityMonitor': latestAlarm.activityMonitor
        });
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
    
    if (!isPreviewMode.value) {
      if (currentlyRingingAlarm.value.deleteAfterGoesOff == true) {
        if (currentlyRingingAlarm.value.isSharedAlarmEnabled && 
            currentlyRingingAlarm.value.ownerId != null && 
            currentlyRingingAlarm.value.firestoreId != null) {  
          await FirestoreDb.deleteOneTimeAlarm(
            currentlyRingingAlarm.value.ownerId,
            currentlyRingingAlarm.value.firestoreId,
          );
        } else if (currentlyRingingAlarm.value.isarId > 0) {
          await IsarDb.deleteAlarm(currentlyRingingAlarm.value.isarId);
        }
      } 
      else if (currentlyRingingAlarm.value.days.every((element) => element == false)) {
        currentlyRingingAlarm.value.isEnabled = false;
        if (!currentlyRingingAlarm.value.isSharedAlarmEnabled && 
            currentlyRingingAlarm.value.isarId > 0) {
          await IsarDb.updateAlarm(currentlyRingingAlarm.value);
        } else if (currentlyRingingAlarm.value.ownerId != null) {
          await FirestoreDb.updateAlarm(
            currentlyRingingAlarm.value.ownerId,
            currentlyRingingAlarm.value,
          );
        }
      }
    }
    _subscription.cancel();
    _currentTimeTimer?.cancel();
    _sensorSubscription?.cancel();
  }
}
