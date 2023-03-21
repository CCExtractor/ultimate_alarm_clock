import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:path/path.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:screen_state/screen_state.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'dart:convert';

class AlarmHandlerModel extends TaskHandler {
  Screen? _screen;
  StreamSubscription<ScreenStateEvent>? _subscription;
  late AlarmModel alarmRecord;
  SendPort? _sendPort;
  Stopwatch? _stopwatch;
  late ReceivePort _uiReceivePort;

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
            // _stopwatch!.start();
            if (event == ScreenStateEvent.SCREEN_UNLOCKED) {
              _stopwatch!.start();
            } else if (event == ScreenStateEvent.SCREEN_OFF) {
              // Stop the stopwatch and update _unlockedDuration when the screen is turned off
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
    print('CHANGING TO LATEST ALARM VIA EVENT! ${TimeOfDay.now()}');
    // List<AlarmModel> list = objectbox.getAllAlarms();
    bool shouldAlarmRing = true;

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay time = Utils.stringToTimeOfDay(alarmRecord.alarmTime);
    DateTime dateTime =
        today.add(Duration(hours: time.hour, minutes: time.minute));

    if (alarmRecord.isActivityEnabled == true) {
      if (_stopwatch!.isRunning) {
        _stopwatch!.stop();
      }
      // Screen active for one minute?
      if (_stopwatch!.elapsedMilliseconds >= 6000) {
        shouldAlarmRing = false;
      }
    }

    if (time.hour == currentTime.hour && time.minute == currentTime.minute) {
      // One minute since screen was active!
      // FlutterForegroundTask.wakeUpScreen();
      FlutterForegroundTask.launchApp('/alarm-control');
      // Ring only if necessary
      if (shouldAlarmRing == true) FlutterRingtonePlayer.playAlarm();
    }
    //  The time will never be before since getMilliSeconds will always adjust it a day forward
    else {
      // We need this part as onEvent is called mandatorily once when the task is created
      int ms = Utils.getMillisecondsToAlarm(DateTime.now(), dateTime);
      print("SENDING: ${alarmRecord.alarmTime} : $ms");
      FlutterForegroundTask.updateService(
        notificationTitle: 'Alarm set!',
        notificationText: 'Rings at ${alarmRecord.alarmTime}',
      );

      // _sendPort?.send(ms);
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
