import 'dart:async';
import 'dart:isolate';
import 'dart:ffi';

import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';
import 'package:screen_state/screen_state.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmHandlerModel extends TaskHandler {
  Screen? _screen;
  StreamSubscription<ScreenStateEvent>? _subscription;

  late AlarmModel alarmRecord;
  SendPort? _sendPort;
  Stopwatch? _stopwatch;
  late ReceivePort _uiReceivePort;
  StreamSubscription<Location>? _streamSubscription;

  bool isScreenActive = true;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    _uiReceivePort = ReceivePort();

    _sendPort?.send(_uiReceivePort.sendPort);

    _uiReceivePort.listen((message) async {
      if (message is Map<String, dynamic>) {
        alarmRecord = AlarmModel.fromMap(message);
        print("Event says : ${alarmRecord}");

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
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print('CHANGING TO LATEST ALARM VIA EVENT! at ${TimeOfDay.now()}');
    bool shouldAlarmRing = true;

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay time = Utils.stringToTimeOfDay(alarmRecord.alarmTime);
    DateTime dateTime =
        today.add(Duration(hours: time.hour, minutes: time.minute));

    if (alarmRecord.isActivityEnabled == true) {
      print("STOPPING WATCH");
      if (_stopwatch!.isRunning) {
        _stopwatch!.stop();
      }
      print("WATCH: ${_stopwatch!.elapsedMilliseconds}");

      // Screen active for one minute?
      if (_stopwatch!.elapsedMilliseconds >= 6000) {
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

    if (time.hour == currentTime.hour && time.minute == currentTime.minute) {
      // Ring only if necessary
      if (shouldAlarmRing == true) {
        // One minute since screen was active!
        if (isScreenActive == false) {
          FlutterForegroundTask.wakeUpScreen();
        }

        FlutterForegroundTask.launchApp('/alarm-ring');
      } else {
        print("STOPPING ALARM");
        // FlutterForegroundTask.launchApp('/alarm-control');
        FlutterForegroundTask.launchApp('/alarm-ring-ignore');
        // _sendPort?.send('testing');
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
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/alarm-control");
    _sendPort?.send('onNotificationPressed');
  }
}
