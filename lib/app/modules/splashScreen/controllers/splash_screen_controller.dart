import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../home/controllers/home_controller.dart';

class SplashScreenController extends GetxController {
  MethodChannel alarmChannel = const MethodChannel('ulticlock');
  MethodChannel timerChannel = const MethodChannel('timer');

  bool shouldAlarmRing = true;
  bool shouldNavigate = true;
  late HomeController homeController;
  late Rx<AlarmModel> currentlyRingingAlarm;

  getCurrentlyRingingAlarm() async {
    AlarmModel _alarmRecord = homeController.genFakeAlarmModel();
    AlarmModel latestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, false);
    debugPrint('CURRENT RINGING : ${latestAlarm.alarmTime}');
    return latestAlarm;
  }

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

  @override
  void onInit() async {
    super.onInit();
    
    // Safely get the HomeController (it's registered in the binding)
    try {
      homeController = Get.find<HomeController>();
    } catch (e) {
      debugPrint('❌ Could not find HomeController: $e');
      // Navigate to main screen even if HomeController isn't ready
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offNamed('/bottom-navigation-bar');
      });
      return;
    }
    
    currentlyRingingAlarm = homeController.genFakeAlarmModel().obs;
    
    // Wrap database fix in try-catch so it doesn't block navigation
    try {
      await IsarDb.fixMaxSnoozeCountInAlarms();
    } catch (e) {
      debugPrint('❌ Error fixing max snooze count: $e');
    }
    
    currentlyRingingAlarm.value = homeController.genFakeAlarmModel();
    alarmChannel.setMethodCallHandler((call) async {
      if (call.method == 'appStartup') {
        bool shouldAlarmRing = call.arguments['shouldAlarmRing'];
        bool isSharedAlarm = call.arguments['isSharedAlarm'] ?? false;
        print("shouldring: $shouldAlarmRing, isSharedAlarm: $isSharedAlarm");
        
        // This indicates the app was started through native code
        if (shouldAlarmRing == true) {
          shouldNavigate = false;
          bool isAlarmIgnored = call.arguments['alarmIgnore'];

          // This exists to implement auto-cancellation using screen for the alarm
          if (isAlarmIgnored == true) {
            shouldAlarmRing = false;
          }
          
            if (shouldAlarmRing) {
            // IMPORTANT: For shared alarms, don't refresh Firestore immediately
            // This prevents the "gone off" issue when the owner dismisses the alarm
            if (isSharedAlarm) {
              debugPrint('🔔 Shared alarm is firing - preventing immediate Firestore refresh');
              // Delay the Firestore refresh to allow alarm to ring properly
              homeController.handleSharedAlarmFiring();
            }
            
              // Get the currently ringing alarm based on its type
              if (isSharedAlarm) {
                // Get shared alarm from Firestore
                UserModel? userModel = await SecureStorageProvider().retrieveUserModel();
                AlarmModel sharedAlarmModel = homeController.genFakeAlarmModel();
                currentlyRingingAlarm.value = await FirestoreDb.getLatestAlarm(
                  userModel, 
                  sharedAlarmModel, 
                  false
                );
                debugPrint('Using SHARED alarm for ring screen: ${currentlyRingingAlarm.value.alarmTime}');
              } else {
                // Get local alarm from Isar
              currentlyRingingAlarm.value = await getCurrentlyRingingAlarm();
                debugPrint('Using LOCAL alarm for ring screen: ${currentlyRingingAlarm.value.alarmTime}');
              }
              
              // Set the flag in the alarm model to ensure correct handling downstream
              currentlyRingingAlarm.value.isSharedAlarmEnabled = isSharedAlarm;
              
              // Store the alarm type in HomeController for proper cleanup later
              homeController.lastScheduledAlarmIsShared = isSharedAlarm;
              
              // Update max snooze count from database if needed
              if (currentlyRingingAlarm.value.alarmID != null) {
                try {
                  final dbAlarm = await IsarDb.getAlarm(currentlyRingingAlarm.value.isarId);
                  if (dbAlarm != null && dbAlarm.maxSnoozeCount != currentlyRingingAlarm.value.maxSnoozeCount) {
                    currentlyRingingAlarm.value.maxSnoozeCount = dbAlarm.maxSnoozeCount;
                  }
                } catch (e) {
                  debugPrint('Error updating max snooze count: $e');
                }
              }
              
              // Navigate to the alarm ring screen
              Get.offNamed('/alarm-ring', arguments: currentlyRingingAlarm.value);
            } else {
              currentlyRingingAlarm.value = await getCurrentlyRingingAlarm();
              // If the alarm is set to NEVER repeat, then it will be chosen as
              // the next alarm to ring by default as it would ring the next day
              if (currentlyRingingAlarm.value.days
                  .every((element) => element == false)) {
                currentlyRingingAlarm.value.isEnabled = false;

                if (currentlyRingingAlarm.value.isSharedAlarmEnabled == false) {
                  IsarDb.updateAlarm(currentlyRingingAlarm.value);
                } else {
                  FirestoreDb.updateAlarm(
                    currentlyRingingAlarm.value.ownerId,
                    currentlyRingingAlarm.value,
                  );
                }
              }

              AlarmModel latestAlarm = await getNextAlarm();

              TimeOfDay latestAlarmTimeOfDay =
                  Utils.stringToTimeOfDay(latestAlarm.alarmTime);
// This condition will never satisfy because this will only occur if fake mode
// is returned as latest alarm
              if (latestAlarm.isEnabled == false) {
                debugPrint('STOPPED IF CONDITION with latest = '
                    '${latestAlarmTimeOfDay.toString()} and ');
                await alarmChannel.invokeMethod('cancelAllScheduledAlarms');
              } else {
                int intervaltoAlarm = Utils.getMillisecondsToAlarm(
                  DateTime.now(),
                  Utils.timeOfDayToDateTime(latestAlarmTimeOfDay),
                );

                try {
                  await alarmChannel.invokeMethod('scheduleAlarm', {
                    'isSharedAlarm': latestAlarm.isSharedAlarmEnabled,
                    'isActivityEnabled': latestAlarm.isActivityEnabled,
                    'isLocationEnabled': latestAlarm.isLocationEnabled,
                    'locationConditionType': latestAlarm.locationConditionType,
                    'isWeatherEnabled': latestAlarm.isWeatherEnabled,
                    'weatherConditionType': latestAlarm.weatherConditionType,
                    'intervalToAlarm': intervaltoAlarm,
                    'location': latestAlarm.location,
                    'weatherTypes': jsonEncode(latestAlarm.weatherTypes),
                    'smartControlCombinationType': latestAlarm.smartControlCombinationType,
                  });


                  print("Scheduled...");
                } on PlatformException catch (e) {
                  print("Failed to schedule alarm: ${e.message}");
                }
              }
              SystemNavigator.pop();
              Get.offNamed('/bottom-navigation-bar');

              alarmChannel.invokeMethod('minimizeApp');
          }
        }
      }
    });
    // Necessary when hot restarting — navigate to main screen
    // Use a slight delay to allow the method channel handler to register first
    Future.delayed(const Duration(milliseconds: 500), () {
      if (shouldNavigate == true) {
        Get.offNamed('/bottom-navigation-bar');
      }
    });
  }
}