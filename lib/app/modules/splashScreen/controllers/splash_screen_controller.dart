import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:weather/weather.dart';

class SplashScreenController extends GetxController {
  MethodChannel alarmChannel = MethodChannel('ulticlock');

  bool shouldAlarmRing = true;
  bool shouldNavigate = true;

  getCurrentlyRingingAlarm() async {
    UserModel? _userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, false);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_userModel, _alarmRecord, false);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    debugPrint('CURRENT RINGING : ${latestAlarm.alarmTime}');

    return latestAlarm;
  }

  Future<bool> checkWeatherCondition(
    LatLng location,
    List<int> weatherTypeInt,
  ) async {
    List<WeatherTypes> weatherTypes =
        Utils.getWeatherTypesFromInt(weatherTypeInt);
    String? apiKey =
        await SecureStorageProvider().retrieveApiKey(ApiKeys.openWeatherMap);
    WeatherFactory weatherFactory = WeatherFactory(apiKey!);
    try {
      Weather weatherData = await weatherFactory.currentWeatherByLocation(
        location.latitude,
        location.longitude,
      );
      for (var weatherType in weatherTypes) {
        bool isConditionMet = false;
        switch (weatherType) {
          case WeatherTypes.sunny:
            isConditionMet =
                weatherData.weatherMain?.toLowerCase().contains('clear') ??
                    false;
            break;
          case WeatherTypes.cloudy:
            isConditionMet =
                weatherData.weatherMain?.toLowerCase().contains('cloud') ??
                    false;
            break;
          case WeatherTypes.rainy:
            isConditionMet =
                weatherData.weatherMain?.toLowerCase().contains('rain') ??
                    false;
            break;
          case WeatherTypes.windy:
            isConditionMet =
                weatherData.windSpeed != null && weatherData.windSpeed! >= 15;
            break;
          case WeatherTypes.stormy:
            isConditionMet =
                weatherData.weatherMain?.toLowerCase().contains('storm') ??
                    false;
            break;
        }

        if (isConditionMet) {
          return true;
        }
      }
    } catch (e) {
      debugPrint('An error occurred while fetching the weather: $e');
    }

    return false;
  }

  @override
  void onInit() async {
    super.onInit();
    alarmChannel.setMethodCallHandler((call) async {
      if (call.method == 'appStartup') {
        bool shouldAlarmRing = call.arguments['shouldAlarmRing'];
        // This indicates the app was started through native code
        if (shouldAlarmRing == true) {
          shouldNavigate = false;
          bool isAlarmIgnored = call.arguments['alarmIgnore'];

          // This exists to implement auto-cancellation using screen for the alarm
          if (isAlarmIgnored == true) {
            shouldAlarmRing = false;
          } else {
            AlarmModel latestAlarm = await getCurrentlyRingingAlarm();

            // Deciding to ring if weather is enabled
            if (latestAlarm.isLocationEnabled == true) {
              LatLng destination = LatLng(0, 0);
              LatLng source = Utils.stringToLatLng(latestAlarm.location);
              destination = await FlLocation.getLocationStream().first.then(
                    (value) => Utils.stringToLatLng(
                        '${value.latitude}, ${value.longitude}'),
                  );

              if (Utils.isWithinRadius(source, destination, 500)) {
                shouldAlarmRing = false;
              }
            }

            // Deciding to ring if weather is enabled
            if (latestAlarm.isWeatherEnabled == true) {
              LatLng currentLocation = LatLng(0, 0);

              currentLocation = await FlLocation.getLocationStream().first.then(
                    (value) => Utils.stringToLatLng(
                        '${value.latitude}, ${value.longitude}'),
                  );
              bool isWeatherTypeMatching = await checkWeatherCondition(
                currentLocation,
                latestAlarm.weatherTypes,
              );
              if (isWeatherTypeMatching == true) {
                shouldAlarmRing = false;
              }
            }

            if (shouldAlarmRing) {
              Get.offNamed('/alarm-ring');
            } else {
              Get.offNamed('/alarm-ring-ignore');
            }
          }
        }
      }
    });
    // Necessary when hot restarting
    Future.delayed(const Duration(seconds: 0), () {
      if (shouldNavigate == true) {
        Get.offNamed('/home');
      }
    });
  }
}
