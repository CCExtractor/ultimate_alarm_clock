import 'dart:async';
import 'dart:isolate';

import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';
import 'package:screen_state/screen_state.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:weather/weather.dart';

class AlarmHandlerModel extends TaskHandler {
  Screen? _screen;
  // ignore: unused_field
  StreamSubscription<ScreenStateEvent>? _subscription;
  late bool isNewAlarm;
  late AlarmModel alarmRecord;
  SendPort? _sendPort;
  Stopwatch? _stopwatch;
  late ReceivePort _uiReceivePort;

  bool isScreenActive = true;

  Future<bool> checkWeatherCondition(
      LatLng location, List<int> weatherTypeInt) async {
    List<WeatherTypes> weatherTypes =
        Utils.getWeatherTypesFromInt(weatherTypeInt);
    String? apiKey =
        await SecureStorageProvider().retrieveApiKey(ApiKeys.openWeatherMap);
    WeatherFactory weatherFactory = WeatherFactory(apiKey!);
    try {
      Weather weatherData = await weatherFactory.currentWeatherByLocation(
          location.latitude, location.longitude);
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
      print('An error occurred while fetching the weather: $e');
    }

    return false;
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    isNewAlarm = true;

    _sendPort = sendPort;
    _uiReceivePort = ReceivePort();

    _sendPort?.send(_uiReceivePort.sendPort);

    _uiReceivePort.listen((message) async {
      if (message is Map<String, dynamic>) {
        alarmRecord = AlarmModel.fromMap(message);
        print("Event says : ${alarmRecord.alarmTime}");

        if (alarmRecord.isActivityEnabled == true) {
          _screen = Screen();
          _stopwatch = Stopwatch();
          _subscription =
              _screen!.screenStateStream!.listen((ScreenStateEvent event) {
            // // Starting stopwatch since screen will initially be unlocked obviously
            if (event == ScreenStateEvent.SCREEN_UNLOCKED) {
              print("STATE: ${event}");
              _stopwatch!.start();
              isScreenActive = true;
            } else if (event == ScreenStateEvent.SCREEN_OFF) {
              print("STATE: ${event}");

              // Stop the stopwatch and update _unlockedDuration when the screen is turned off
              isScreenActive = false;
              _stopwatch!.stop();
              _stopwatch!.reset();
            }
          });
        }
      }
    });
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    print('CHANGING TO LATEST ALARM VIA EVENT! at ${TimeOfDay.now()}');
    bool shouldAlarmRing = true;

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay time = Utils.stringToTimeOfDay(alarmRecord.alarmTime);
    DateTime dateTime =
        today.add(Duration(hours: time.hour, minutes: time.minute));

    // Checking if weather activity is enabled
    if (alarmRecord.isWeatherEnabled == true) {
      LatLng currentLocation = LatLng(0, 0);

      currentLocation = await FlLocation.getLocationStream().first.then(
          (value) =>
              Utils.stringToLatLng("${value.latitude}, ${value.longitude}"));
      bool isWeatherTypeMatching = await checkWeatherCondition(
          currentLocation, alarmRecord.weatherTypes);
      if (isWeatherTypeMatching == true) {
        shouldAlarmRing = false;
      }
    }

    if (alarmRecord.isActivityEnabled == true) {
      print("STOPPING WATCH");
      if (_stopwatch!.isRunning) {
        _stopwatch!.stop();
      }
      print("WATCH: ${_stopwatch!.elapsedMilliseconds}");

      // Screen active for more than activityInterval?
      if (_stopwatch!.elapsedMilliseconds >= alarmRecord.activityInterval) {
        shouldAlarmRing = false;
      }
    }

    // Checking if the user is within 500m of set location if enabled
    if (alarmRecord.isLocationEnabled == true) {
      LatLng destination = LatLng(0, 0);
      LatLng source = Utils.stringToLatLng(alarmRecord.location);
      destination = await FlLocation.getLocationStream().first.then((value) =>
          Utils.stringToLatLng("${value.latitude}, ${value.longitude}"));

      if (Utils.isWithinRadius(source, destination, 500)) {
        shouldAlarmRing = false;
      }
    }

    if (time.hour == currentTime.hour &&
        time.minute == currentTime.minute &&
        Utils.isCurrentDayinList(alarmRecord.days) == true &&
        isNewAlarm == false) {
      // Ring only if necessary
      if (shouldAlarmRing == true) {
        // Ringing alarm now!
        FlutterForegroundTask.launchApp('/alarm-ring');
        _sendPort?.send('alarmRingRoute');
      } else {
        print("STOPPING ALARM");
        _sendPort?.send('alarmRingRoute');
        FlutterForegroundTask.launchApp('/alarm-ring');
      }
    }
    //  The time will never be before since getMilliSeconds will always adjust it a day forward
    else {
      // We need this part as onEvent is called mandatorily once when the task is created
      int ms = Utils.getMillisecondsToAlarm(DateTime.now(), dateTime);

      print("Event set for: ${alarmRecord.alarmTime} : $ms");
      FlutterForegroundTask.updateService(
        notificationTitle: 'Alarm set!',
        notificationText: 'Rings at ${alarmRecord.alarmTime}',
      );
      isNewAlarm = false;
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
    await _subscription!.cancel();
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/home");
    _sendPort?.send('onNotificationPressed');
  }
}
