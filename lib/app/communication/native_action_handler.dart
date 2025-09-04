import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmRing/controllers/alarm_ring_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';

class NativeActionHandler extends GetxService {
  static const _channel = MethodChannel('com.ccextractor.uac/alarm_actions');
  Future<NativeActionHandler> init() async {
    _channel.setMethodCallHandler(_handleNativeActions);
    return this;
  }

  Future<void> _handleNativeActions(MethodCall call) async {
    if (call.method == 'handleReceivedAction') {
      final action = call.arguments['action'] as String?;
      final uniqueSyncId = call.arguments['alarmId'] as String?;

      if (uniqueSyncId == null) {
        print("NativeActionHandler: Received action '$action' but alarmId was null. Aborting.");
        return;
      }

      print("NativeActionHandler: Received '$action' action for $uniqueSyncId");

      switch (action) {
        case 'delete alarm':
          await AddOrUpdateAlarmController.handleWatchDelete(uniqueSyncId);
          // Refresh the UI if the HomeController is active
          if (Get.isRegistered<HomeController>()) {
            final HomeController homeController = Get.find<HomeController>();
            await Future.delayed(const Duration(milliseconds: 200));
            await homeController.refreshUpcomingAlarms();
          }
          break;

        case 'snooze':
          if (Get.isRegistered<AlarmControlController>()) {
            Get.find<AlarmControlController>().startSnooze();
          }
          break;

        case 'dismiss':
          if (Get.isRegistered<AlarmControlController>()) {
            await Get.find<AlarmControlController>().dismissAlarm();
          }
          break;
      }
    }
  }
}