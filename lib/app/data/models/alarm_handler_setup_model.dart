import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AlarmHandlerModel());
}

class AlarmHandlerSetupModel {
  late SendPort _sendPort;
  ReceivePort? _receivePort;

  restartForegroundTask(AlarmModel alarmRecord, int intervalToAlarm) async {
    await stopForegroundTask();
    createForegroundTask(intervalToAlarm);
    await startForegroundTask(alarmRecord);
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

  Future<bool> startForegroundTask(AlarmModel alarmRecord) async {
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }
    // print('Setting alarm for time: ${alarmRecord.alarmTime}');
    // await FlutterForegroundTask.saveData(
    //     key: 'alarmData', value: AlarmModel.toJson(alarmRecord));

    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = registerReceivePort(receivePort, alarmRecord);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'UltiClock is running!',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  bool registerReceivePort(
      ReceivePort? newReceivePort, AlarmModel alarmRecord) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) async {
      if (message is SendPort) {
        _sendPort = message;
        // Send port has been initialized, let's send it the alarm details
        _sendPort.send(AlarmModel.toMap(alarmRecord));
      }
      print('MAIN RECIEVED $message');

      if (message is String) {
        if (message == 'onNotificationPressed') {
          Get.toNamed('/home');
        } else if (message == 'alarmRingRoute') {
          FlutterForegroundTask.launchApp('/alarm-ring');
          if (Get.currentRoute != '/alarm-ring') {
            Get.offNamed('/alarm-ring');
          }
        } else if (message == 'alarmRingIgnoreRoute') {
          FlutterForegroundTask.launchApp('/alarm-ring-ignore');
          if (Get.currentRoute != '/alarm-ring') {
            Get.offNamed('/alarm-ring');
          }
        }
      }
    });

    return _receivePort != null;
  }
}
