import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AlarmModel());
}

class AddAlarmController extends GetxController {
  ReceivePort? _receivePort;

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) {
      if (message is int) {
        print('CONVERTING TO $message');

        _stopForegroundTask();
        createForegroundTask(getMillisecondsToAlarm(
            DateTime.now(), DateTime.now().add(Duration(minutes: message))));
        startForegroundTask(message.toString());
      }
      print('MAIN RECIEVED $message');
      // FlutterForegroundTask.updateService(
      //   notificationTitle: 'Ultimate Alarm Clock',
      //   notificationText: 'RECEIVED $message',
      // );
      if (message is String) {
        if (message == 'onNotificationPressed') {
          Get.to('/alarm-control');
        }
      }
    });

    return _receivePort != null;
  }

  Future<bool> startForegroundTask(String count) async {
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }
    print('STARTING TASK AT ${count}');

    await FlutterForegroundTask.saveData(key: 'time', value: count);

    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      print("restarting");
      return FlutterForegroundTask.restartService();
    } else {
      print('we go weeeeeee');
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  int getMillisecondsToAlarm(DateTime now, DateTime alarmTime) {
    if (alarmTime.isBefore(now)) {
      print('The alarm time has already occurred.');
    }

    int milliseconds = alarmTime.difference(now).inMilliseconds;
    print(milliseconds);
    return milliseconds;
  }

  void createForegroundTask(int intervalForAlarm) {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'ulti_clock',
        channelName: 'Ultimate Alarm Clock',
        channelDescription: 'Ultimate Alarm Clock Channel',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        interval: intervalForAlarm,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  T? _ambiguate<T>(T? value) => value;

  @override
  void onInit() async {
    super.onInit();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
