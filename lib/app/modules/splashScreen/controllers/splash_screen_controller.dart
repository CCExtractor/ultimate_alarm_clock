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
  HomeController homeController = Get.find<HomeController>();
  late Rx<AlarmModel> currentlyRingingAlarm =
      homeController.genFakeAlarmModel().obs;

  getCurrentlyRingingAlarm() async {
    AlarmModel alarmRecord = homeController.genFakeAlarmModel();
    AlarmModel latestAlarm = await IsarDb.getLatestAlarm(alarmRecord, false);
    debugPrint('CURRENT RINGING : ${latestAlarm.alarmTime}');
    return latestAlarm;
  }

  getNextAlarm() async {
    UserModel? userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel alarmRecord = homeController.genFakeAlarmModel();
    AlarmModel isarLatestAlarm = await IsarDb.getLatestAlarm(alarmRecord, true);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(userModel, alarmRecord, true);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    debugPrint('LATEST : ${latestAlarm.alarmTime}');

    return latestAlarm;
  }

  // Future<bool> checkWeatherCondition(
  //   LatLng location,
  //   List<int> weatherTypeInt,
  // ) async {
  //   List<WeatherTypes> weatherTypes =
  //       Utils.getWeatherTypesFromInt(weatherTypeInt);
  //   String? apiKey =
  //       await SecureStorageProvider().retrieveApiKey(ApiKeys.openWeatherMap);
  //   WeatherFactory weatherFactory = WeatherFactory(apiKey!);
  //   try {
  //     Weather weatherData = await weatherFactory.currentWeatherByLocation(
  //       location.latitude,
  //       location.longitude,
  //     );
  //     for (var weatherType in weatherTypes) {
  //       bool isConditionMet = false;
  //       switch (weatherType) {
  //         case WeatherTypes.sunny:
  //           isConditionMet =
  //               weatherData.weatherMain?.toLowerCase().contains('clear') ??
  //                   false;
  //           break;
  //         case WeatherTypes.cloudy:
  //           isConditionMet =
  //               weatherData.weatherMain?.toLowerCase().contains('cloud') ??
  //                   false;
  //           break;
  //         case WeatherTypes.rainy:
  //           isConditionMet =
  //               weatherData.weatherMain?.toLowerCase().contains('rain') ??
  //                   false;
  //           break;
  //         case WeatherTypes.windy:
  //           isConditionMet =
  //               weatherData.windSpeed != null && weatherData.windSpeed! >= 15;
  //           break;
  //         case WeatherTypes.stormy:
  //           isConditionMet =
  //               weatherData.weatherMain?.toLowerCase().contains('storm') ??
  //                   false;
  //           break;
  //       }
  //
  //       if (isConditionMet) {
  //         return true;
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('An error occurred while fetching the weather: $e');
  //   }
  //
  //   return false;
  // }

  @override
  void onInit() async {
    super.onInit();
    currentlyRingingAlarm.value = homeController.genFakeAlarmModel();
    alarmChannel.setMethodCallHandler((call) async {
      if (call.method == 'appStartup') {
        bool shouldAlarmRing = call.arguments['shouldAlarmRing'];
        print('shouldring: $shouldAlarmRing');
        // This indicates the app was started through native code
        if (shouldAlarmRing == true) {
          shouldNavigate = false;
          bool isAlarmIgnored = call.arguments['alarmIgnore'];

          // This exists to implement auto-cancellation using screen for the alarm
          if (isAlarmIgnored == true) {
            shouldAlarmRing = false;
          } else {
            if (shouldAlarmRing) {
              currentlyRingingAlarm.value = await getCurrentlyRingingAlarm();
              Get.offNamed('/alarm-ring',
                  arguments: currentlyRingingAlarm.value);
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
              } else if (currentlyRingingAlarm.value.isOneTime == true) {
                // If the alarm has to repeat on one day, but ring just once,
                // we will keep seting its days to false until it will never ring
                int currentDay = DateTime.now().weekday - 1;
                currentlyRingingAlarm.value.days[currentDay] = false;

                if (currentlyRingingAlarm.value.days
                    .every((element) => element == false)) {
                  currentlyRingingAlarm.value.isEnabled = false;
                }

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
                    'milliSeconds': intervaltoAlarm,
                    'activityMonitor': latestAlarm.activityMonitor,
                  });
                  print('Scheduled...');
                } on PlatformException catch (e) {
                  print('Failed to schedule alarm: ${e.message}');
                }
              }
              SystemNavigator.pop();
              Get.offNamed('/bottom-navigation-bar');

              alarmChannel.invokeMethod('minimizeApp');
            }
          }
        }
      }
    });
    // Necessary when hot restarting
    Future.delayed(const Duration(seconds: 0), () {
      if (shouldNavigate == true) {
        Get.offNamed('/bottom-navigation-bar');
      }
    });
  }
}
