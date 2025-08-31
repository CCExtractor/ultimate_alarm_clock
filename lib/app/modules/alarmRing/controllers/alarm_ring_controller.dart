
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_fgbg/flutter_fgbg.dart'; // Temporarily disabled
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
import 'package:ultimate_alarm_clock/app/utils/constants.dart' hide Status;

import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../home/controllers/home_controller.dart';

class AlarmRingController extends GetxController {
  MethodChannel alarmChannel = MethodChannel('ulticlock');
  RxString note = ''.obs;
  Timer? vibrationTimer;
  // StreamSubscription<FGBGType>? _subscription; // Temporarily disabled flutter_fgbg
  TimeOfDay currentTime = TimeOfDay.now();
  late RxBool isSnoozing = false.obs;
  RxInt minutes = 1.obs;
  RxInt seconds = 0.obs;
  RxInt snoozeCount = 0.obs;
<<<<<<< HEAD
  RxInt maxSnoozeCount = 3.obs; // Will be initialized from alarm model
=======
>>>>>>> upstream/gsoc-final-project-2025
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
  
  // Sunrise effect variables
  RxBool isSunriseActive = false.obs;
  double _originalScreenBrightness = 0.5;

  Future<AlarmModel> getNextAlarm() async {
    UserModel? _userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel _alarmRecord = homeController.genFakeAlarmModel();
    
  
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, true);
    
  
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_userModel, _alarmRecord, true);
    
  
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    
  
    if (latestAlarm.isSharedAlarmEnabled) {
      debugPrint('Next alarm is a SHARED alarm from Firestore: ${latestAlarm.alarmTime}');
    } else {
      debugPrint('Next alarm is a LOCAL alarm from Isar: ${latestAlarm.alarmTime}');
    }

    return latestAlarm;
  }

  void addMinutes(int incrementMinutes) {
    minutes.value += incrementMinutes;
  }

  void startSnooze() async {
<<<<<<< HEAD
    debugPrint('🔔 Snooze attempt: ${snoozeCount.value + 1}/${maxSnoozeCount.value}');
    if (snoozeCount.value >= maxSnoozeCount.value) {
      debugPrint('🔔 Max snooze limit reached: ${snoozeCount.value}/${maxSnoozeCount.value}');
=======
    int actualMaxSnoozeCount = currentlyRingingAlarm.value.maxSnoozeCount;
  
    if (currentlyRingingAlarm.value.isarId > 0) {
      final dbAlarm = await IsarDb.getAlarm(currentlyRingingAlarm.value.isarId);
      if (dbAlarm != null) {
        actualMaxSnoozeCount = dbAlarm.maxSnoozeCount;
      }
    }
    
    if (snoozeCount.value >= actualMaxSnoozeCount) {
>>>>>>> upstream/gsoc-final-project-2025
      Get.snackbar(
        "Max Snooze Limit",
        "You've reached the maximum snooze limit",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: themeController.secondaryBackgroundColor.value,
        colorText: themeController.primaryTextColor.value,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    snoozeCount.value++;
<<<<<<< HEAD
    debugPrint('🔔 Snoozed successfully: ${snoozeCount.value}/${maxSnoozeCount.value}');
=======
>>>>>>> upstream/gsoc-final-project-2025
    
    Vibration.cancel();
    vibrationTimer!.cancel();
    isSnoozing.value = true;
    String ringtoneName = currentlyRingingAlarm.value.ringtoneName;
    AudioUtils.stopAlarm(ringtoneName: ringtoneName);

    if (_currentTimeTimer!.isActive) {
      _currentTimeTimer?.cancel();
    }

    // Set snooze duration - default to 5 minutes if it's 0
    int snoozeDurationMinutes = currentlyRingingAlarm.value.snoozeDuration;
    if (snoozeDurationMinutes <= 0) {
      snoozeDurationMinutes = 5; // Default to 5 minutes when snooze duration is 0
      debugPrint('🔔 Snooze duration was 0, defaulting to 5 minutes');
    }
    minutes.value = snoozeDurationMinutes;

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
    // Set snooze duration - default to 5 minutes if it's 0
    int snoozeDurationMinutes = currentlyRingingAlarm.value.snoozeDuration;
    if (snoozeDurationMinutes <= 0) {
      snoozeDurationMinutes = 5; // Default to 5 minutes when snooze duration is 0
      debugPrint('🔔 Snooze duration was 0, defaulting to 5 minutes in startTimer()');
    }
    minutes.value = snoozeDurationMinutes;
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
    debugPrint('🔊 Starting ascending volume: ${currentlyRingingAlarm.value.volMin}% → ${currentlyRingingAlarm.value.volMax}% over ${currentlyRingingAlarm.value.gradient}s');
    
    // Set initial volume
    double startVolume = currentlyRingingAlarm.value.volMin / 10.0;
    double endVolume = currentlyRingingAlarm.value.volMax / 10.0;
    int durationMs = currentlyRingingAlarm.value.gradient * 1000;
    
    await FlutterVolumeController.setVolume(startVolume, stream: AudioStream.alarm);
    debugPrint('🔊 Initial volume set to: ${(startVolume * 100).toInt()}%');
    
    // Wait a moment for the alarm to start playing
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculate step parameters
    double volumeDifference = endVolume - startVolume;
    int updateIntervalMs = 100; // Update every 100ms for smooth transition
    int totalSteps = durationMs ~/ updateIntervalMs;
    double volumeStepSize = volumeDifference / totalSteps;
    
    double currentVolume = startVolume;
    int stepCount = 0;
    
    debugPrint('🔊 Volume gradient params: steps=$totalSteps, stepSize=${(volumeStepSize * 100).toStringAsFixed(1)}%, interval=${updateIntervalMs}ms');

    Timer.periodic(Duration(milliseconds: updateIntervalMs), (Timer timer) {
      if (!isAlarmActive) {
        debugPrint('🔊 Alarm no longer active, stopping volume gradient');
        timer.cancel();
        return;
      }

      stepCount++;
      currentVolume = startVolume + (volumeStepSize * stepCount);
      
      // Clamp volume within bounds
      currentVolume = currentVolume.clamp(startVolume, endVolume);
      
      // Round to 2 decimal places for cleaner volume values
      currentVolume = (currentVolume * 100).round() / 100;

      FlutterVolumeController.setVolume(currentVolume, stream: AudioStream.alarm);
      
      debugPrint('🔊 Step $stepCount/$totalSteps: Volume = ${(currentVolume * 100).toInt()}%');

      // Stop when we reach the end volume or complete all steps
      if (currentVolume >= endVolume || stepCount >= totalSteps) {
        debugPrint('🔊 Volume gradient completed at ${(currentVolume * 100).toInt()}%');
        timer.cancel();
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
  
  Future<void> _initializeSunriseEffect() async {
    if (currentlyRingingAlarm.value.isSunriseEnabled) {
      try {
        // Store original brightness for restoration later
        _originalScreenBrightness = await ScreenBrightness().current;
        isSunriseActive.value = true;
        debugPrint('🌅 Sunrise effect initialized - original brightness: $_originalScreenBrightness');
      } catch (e) {
        debugPrint('🌅 Error initializing sunrise effect: $e');
      }
    }
  }
  
  Future<void> _restoreOriginalBrightness() async {
    if (isSunriseActive.value) {
      try {
        await ScreenBrightness().setScreenBrightness(_originalScreenBrightness);
        isSunriseActive.value = false;
        debugPrint('🌅 Original screen brightness restored: $_originalScreenBrightness');
      } catch (e) {
        debugPrint('🌅 Error restoring brightness: $e');
      }
    }
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
    
    // Extract alarm and preview flag from arguments
    final args = Get.arguments;
    if (args is Map) {
      currentlyRingingAlarm.value = args['alarm'];
      isPreviewMode.value = args['preview'] ?? false;
    } else {
      currentlyRingingAlarm.value = args;
      isPreviewMode.value = false;
    }

<<<<<<< HEAD
    // Initialize maxSnoozeCount with the correct value from alarm model
    // For local alarms, try to get fresh data from database
    // For shared alarms, use the value from the alarm model
    if (currentlyRingingAlarm.value.isarId > 0 && 
        !currentlyRingingAlarm.value.isSharedAlarmEnabled) {
      final dbAlarm = await IsarDb.getAlarm(currentlyRingingAlarm.value.isarId);
      if (dbAlarm != null) {
        maxSnoozeCount.value = dbAlarm.maxSnoozeCount;
        currentlyRingingAlarm.value.maxSnoozeCount = dbAlarm.maxSnoozeCount;
        debugPrint('🔔 Set maxSnoozeCount to ${dbAlarm.maxSnoozeCount} '
            'from local database');
      } else {
        maxSnoozeCount.value = currentlyRingingAlarm.value.maxSnoozeCount;
        debugPrint('🔔 Set maxSnoozeCount to '
            '${currentlyRingingAlarm.value.maxSnoozeCount} '
            'from alarm model (db not found)');
      }
    } else {
      maxSnoozeCount.value = currentlyRingingAlarm.value.maxSnoozeCount;
      debugPrint('🔔 Set maxSnoozeCount to '
          '${currentlyRingingAlarm.value.maxSnoozeCount} '
          'from alarm model (shared or no isar ID)');
    }
    
    // Initialize sunrise effect if enabled
    await _initializeSunriseEffect();
    
    // Don't start guardian functionality in preview mode
    if (currentlyRingingAlarm.value.isGuardian && !isPreviewMode.value) {
      // Use the actual guardianTimer value from the alarm, default to 120 if not set
      int timerDuration = currentlyRingingAlarm.value.guardianTimer > 0 
          ? currentlyRingingAlarm.value.guardianTimer 
          : 120;
      guardianCoundown.value = timerDuration;
      
=======
    if (currentlyRingingAlarm.value.isarId > 0) {
      final dbAlarm = await IsarDb.getAlarm(currentlyRingingAlarm.value.isarId);
      if (dbAlarm != null && dbAlarm.maxSnoozeCount != currentlyRingingAlarm.value.maxSnoozeCount) {
        currentlyRingingAlarm.value.maxSnoozeCount = dbAlarm.maxSnoozeCount;
      }
    }
    
    if (currentlyRingingAlarm.value.isGuardian) {
>>>>>>> upstream/gsoc-final-project-2025
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

    // Don't update system UI or start alarm functionality in preview mode
    if (!isPreviewMode.value) {
      FlutterVolumeController.updateShowSystemUI(false);

      // Start ascending volume if enabled
      if (currentlyRingingAlarm.value.gradient > 0) {
        _fadeInAlarmVolume();
      }

      vibrationTimer =
          Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
            Vibration.vibrate(pattern: [500, 3000]);
          });

      // Preventing app from being minimized!
      // _subscription = FGBGEvents.stream.listen((event) {
      //   if (event == FGBGType.background) {
      //     alarmChannel.invokeMethod('bringAppToForeground');
      //   }
      // }); // Temporarily disabled flutter_fgbg

      AudioUtils.playAlarm(alarmRecord: currentlyRingingAlarm.value);
      
      // Log detailed alarm ringing (NORMAL - always visible)
      String alarmType = currentlyRingingAlarm.value.isSharedAlarmEnabled ? 'SHARED' : 'LOCAL';
      String ringMessage = IsarDb.buildDetailedAlarmRingMessage(currentlyRingingAlarm.value, alarmType);
      await IsarDb().insertLog(ringMessage, status: Status.success, type: LogType.normal, hasRung: 1);
    }

    startTimer();

    if(currentlyRingingAlarm.value.showMotivationalQuote) {
      Quote quote = Utils.getRandomQuote();
      showQuotePopup(quote);
    }

    // Setting snooze duration - default to 5 minutes if it's 0
    int snoozeDurationMinutes = currentlyRingingAlarm.value.snoozeDuration;
    if (snoozeDurationMinutes <= 0) {
      snoozeDurationMinutes = 5; // Default to 5 minutes when snooze duration is 0
      debugPrint('🔔 Snooze duration was 0, defaulting to 5 minutes in onInit()');
    }
    minutes.value = snoozeDurationMinutes;
    
    // Note: We've removed the alarm scheduling code from here
    // since it's already handled in the dismiss button handler
    // This prevents duplicate alarms from being created
  }

  @override
  void onClose() async {
    super.onClose();
    debugPrint('🔔 Alarm ring view is closing...');
    
    // Stop vibration and sound only if not in preview mode (or if they were started)
    if (!isPreviewMode.value) {
      Vibration.cancel();
      if (vibrationTimer != null) {
        vibrationTimer!.cancel();
      }
      isAlarmActive = false;
      String ringtoneName = currentlyRingingAlarm.value.ringtoneName;
      AudioUtils.stopAlarm(ringtoneName: ringtoneName);
      
      // Reset volume to initial level
      await FlutterVolumeController.setVolume(
        initialVolume,
        stream: AudioStream.alarm,
      );
    }
    
    // Always restore original screen brightness
    await _restoreOriginalBrightness();
    
    if (!isPreviewMode.value) {
      debugPrint('🔔 Processing alarm dismissal...');
      
      // Track the alarm type (shared or local) in the home controller
      // so we only cancel the specific type when clearing
      bool isShared = currentlyRingingAlarm.value.isSharedAlarmEnabled;
      homeController.lastScheduledAlarmIsShared = isShared;
      debugPrint('🔔 Setting HomeController.lastScheduledAlarmIsShared to $isShared');
      
      // If this is a shared alarm, block just this specific alarm from being rescheduled
      if (isShared) {
        // Remember and block this specific alarm to prevent immediate rescheduling
        rememberDismissedAlarm();
        debugPrint('🔔 Blocked shared alarm from immediate rescheduling');
      }
      
      // Handle one-time alarm deletion if needed
      if (currentlyRingingAlarm.value.deleteAfterGoesOff == true) {
        debugPrint('🔔 Handling one-time alarm deletion');
        if (isShared && 
            currentlyRingingAlarm.value.ownerId != null && 
            currentlyRingingAlarm.value.firestoreId != null) {  
          // For shared alarms, don't delete immediately - mark as dismissed by this user
          // This allows other users with offsets to still receive their alarms
          await FirestoreDb.markSharedAlarmDismissedByUser(
            currentlyRingingAlarm.value.firestoreId!,
            homeController.userModel.value?.id ?? '',
          );
          debugPrint('🔔 Marked one-time shared alarm as dismissed by current user');
        } else if (currentlyRingingAlarm.value.isarId > 0) {
          await IsarDb.deleteAlarm(currentlyRingingAlarm.value.isarId);
          debugPrint('🔔 Deleted one-time local alarm from Isar');
        }
      } 
      // Update one-time alarm state if needed
      else if (currentlyRingingAlarm.value.days.every((element) => element == false)) {
        debugPrint('🔔 Handling one-time alarm after ring');
        if (isShared && currentlyRingingAlarm.value.firestoreId != null) {
          // For shared one-time alarms, mark as dismissed by this user instead of disabling globally
          await FirestoreDb.markSharedAlarmDismissedByUser(
            currentlyRingingAlarm.value.firestoreId!,
            homeController.userModel.value?.id ?? '',
          );
          debugPrint('🔔 Marked one-time shared alarm as dismissed by current user');
        } else if (!isShared && currentlyRingingAlarm.value.isarId > 0) {
          // For local one-time alarms, disable normally
        currentlyRingingAlarm.value.isEnabled = false;
          await IsarDb.updateAlarm(currentlyRingingAlarm.value);
          debugPrint('🔔 Updated one-time local alarm in Isar');
        }
      }
      
      // Cancel only the specific alarm that just rang (shared or local)
      // This will preserve any other scheduled alarms
      await homeController.clearLastScheduledAlarm();
      debugPrint('🔔 Cleared last scheduled alarm');
      
      // Make sure we're also clearing all alarms if needed
      // This is a safeguard to ensure we don't have lingering alarms
      if (isShared) {
        // For shared alarms, don't cancel everything as it might cancel scheduled local alarms
        debugPrint('🔔 Cleared last scheduled shared alarm');
      } else {
        // For local alarms, just clear the local tracking
        debugPrint('🔔 Cleared last scheduled local alarm');
      }
      
      // Set flag for HomeController to handle scheduling on its own cycle
      // This prevents duplicate alarms from being scheduled
      homeController.refreshTimer = true;
      debugPrint('🔔 Set refresh flag for next alarm scheduling cycle');
      
      // Add a small delay to ensure all processes are complete
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    // _subscription?.cancel(); // Temporarily disabled flutter_fgbg
    _currentTimeTimer?.cancel();
    _sensorSubscription?.cancel();
    debugPrint('🔔 Alarm ring cleanup complete');
  }

  // Save dismissed alarm details to prevent immediate rescheduling of the same alarm
  void rememberDismissedAlarm() {
    debugPrint('🔔 Remembering dismissed alarm (isShared=${currentlyRingingAlarm.value.isSharedAlarmEnabled})');
    
    if (currentlyRingingAlarm.value.isSharedAlarmEnabled) {
      // Block this specific alarm from being rescheduled
      homeController.blockSharedAlarmRescheduling(
        currentlyRingingAlarm.value.firestoreId,
        currentlyRingingAlarm.value.alarmTime
      );
      
      // Also store the ID for backward compatibility
      homeController.lastDismissedSharedAlarmId = currentlyRingingAlarm.value.firestoreId;
      homeController.lastDismissedSharedAlarmTime = Utils.stringToTimeOfDay(currentlyRingingAlarm.value.alarmTime);
      
      debugPrint('🔔 Remembered and blocked dismissed shared alarm: ${currentlyRingingAlarm.value.alarmTime}, ID: ${currentlyRingingAlarm.value.firestoreId}');
    } else {
      debugPrint('🔔 Dismissed a local alarm - no need to block: ${currentlyRingingAlarm.value.alarmTime}');
    }
  }
}
