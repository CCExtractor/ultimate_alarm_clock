import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';

class AlarmSyncHandler {
  static const MethodChannel _channel =
      MethodChannel("com.ccextractor.alarm_channel");

  static void initListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onWatchAlarmReceived") {
        try {
          final Map<dynamic, dynamic> payload = call.arguments;
          final Map<String, dynamic> alarmMap = Map<String, dynamic>.from(payload['alarmMap']);
          final bool isNewAlarm = payload['isNewAlarm'];
          final AlarmModel alarm = AlarmModel.fromMap(alarmMap);

          if (isNewAlarm) {
            print("AlarmSyncHandler: Calling static create handler...");
            await AddOrUpdateAlarmController.handleWatchCreate(alarm);
          } else {
            print("AlarmSyncHandler: Calling static update handler...");
            await AddOrUpdateAlarmController.handleWatchUpdate(alarm);
          }          
        } catch (e, st) {
          print("AlarmSyncHandler: Failed to process incoming alarm: $e\n$st");
        }
      }
    });
  }
}