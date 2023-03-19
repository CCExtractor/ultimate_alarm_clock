import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:screen_state/screen_state.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmHandlerModel extends TaskHandler {
  Future<void> deleteFromDatabase(int id) async {
    print("deleting $id");
    await _database!.delete(
      'Alarms',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Screen? _screen;
  StreamSubscription<ScreenStateEvent>? _subscription;
  SendPort? _sendPort;
  Database? _database;
  Stopwatch? _stopwatch;
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _stopwatch = Stopwatch();
    _sendPort = sendPort;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demoing.db');
    _database = await openDatabase(path, version: 1);
    _screen = new Screen();
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
    List<Map> list = await _database!.rawQuery('SELECT * FROM Alarms');
    print(list);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (Map item in list) {
      TimeOfDay currentTime = TimeOfDay.now();
      TimeOfDay time = Utils.stringToTimeOfDay(item['time']);
      DateTime dateTime =
          today.add(Duration(hours: time.hour, minutes: time.minute));

      if (time.hour == currentTime.hour && time.minute == currentTime.minute) {
        if (_stopwatch!.isRunning) {
          _stopwatch!.stop();
        }
        // One minute since screen was active!
        if (_stopwatch!.elapsedMilliseconds < 60000) {
          print(_stopwatch!.elapsedMilliseconds);
          FlutterForegroundTask.wakeUpScreen();
          FlutterForegroundTask.launchApp('/alarm-control');

          FlutterRingtonePlayer.playAlarm();
        }
      } else if (dateTime.isBefore(now)) {
        int id = item['id'];
        await deleteFromDatabase(id);
      } else {
        if (item['lock'] == 0) {
          _database!.update(
            'Alarms',
            {'lock': 1},
            where: "id = ?",
            whereArgs: [item['id']],
          );
          int ms = Utils.getMillisecondsToAlarm(DateTime.now(), dateTime);
          print("SENDING: ${item['time']} : $ms");
          FlutterForegroundTask.updateService(
            notificationTitle: 'Alarm set!',
            notificationText: 'Rings at ${item['time']}',
          );

          _sendPort?.send(ms);
        }
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
