import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:path/path.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:screen_state/screen_state.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/objectbox.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmHandlerModel extends TaskHandler {
  Screen? _screen;
  StreamSubscription<ScreenStateEvent>? _subscription;
  late int alarmId;
  late ObjectBox objectbox;

  SendPort? _sendPort;
  Stopwatch? _stopwatch;

  // AlarmHandlerModel({required this.box});

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    objectbox = await ObjectBox.init();
    List<AlarmModel> list = objectbox.getAllAlarms();
    _stopwatch = Stopwatch();
    _sendPort = sendPort;
    _screen = new Screen();
    alarmId = await FlutterForegroundTask.getData(key: 'alarmId');

    print('customData: $alarmId');
    _subscription =
        _screen!.screenStateStream!.listen((ScreenStateEvent event) {
      if (event == ScreenStateEvent.SCREEN_UNLOCKED) {
        _stopwatch!.start();
      } else if (event == ScreenStateEvent.SCREEN_OFF) {
        // Stop the stopwatch and update _unlockedDuration when the screen is turned off
        _stopwatch!.stop();
        _stopwatch!.reset();
      }
    });
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print('CHANGING TO LATEST ALARM VIA EVENT!');
    List<AlarmModel> list = objectbox.getAllAlarms();

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (AlarmModel alarm in list) {
      TimeOfDay currentTime = TimeOfDay.now();
      TimeOfDay time = Utils.stringToTimeOfDay(alarm.alarmTime);
      DateTime dateTime =
          today.add(Duration(hours: time.hour, minutes: time.minute));

      if (time.hour == currentTime.hour && time.minute == currentTime.minute) {
        if (_stopwatch!.isRunning) {
          _stopwatch!.stop();
        }
        // One minute since screen was active!
        if (_stopwatch!.elapsedMilliseconds < 6000) {
          print(_stopwatch!.elapsedMilliseconds);
          FlutterForegroundTask.wakeUpScreen();
          FlutterForegroundTask.launchApp('/alarm-control');

          FlutterRingtonePlayer.playAlarm();
        }
      } else if (dateTime.isBefore(now)) {
        // Don't ring handle with getMiliseconds() to add a day if before
      } else {
        int ms = Utils.getMillisecondsToAlarm(DateTime.now(), dateTime);
        print("SENDING: ${alarm.alarmTime} : $ms");
        FlutterForegroundTask.updateService(
          notificationTitle: 'Alarm set!',
          notificationText: 'Rings at ${alarm.alarmTime}',
        );

        // _sendPort?.send(ms);
      }
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
