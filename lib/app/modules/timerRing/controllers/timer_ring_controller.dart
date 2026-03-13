import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';

class TimerRingController extends GetxController {
  MethodChannel timerChannel = const MethodChannel('timer');
  MethodChannel alarmChannel = const MethodChannel('ulticlock');
  Timer? vibrationTimer;
  late StreamSubscription<FGBGType> _subscription;
  getFakeTimerModel() async {
    TimerModel fakeTimer = await Utils.genFakeTimerModel();
    return fakeTimer;
  }

  @override
  void onInit() async {
    super.onInit();

    // Preventing app from being minimized!
    _subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        bringAppToForegroundForTest();
      }
    });
    vibrationTimer =
        Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
      Vibration.vibrate(pattern: [500, 3000]);
    });
    AudioUtils.playTimer(alarmRecord: await getFakeTimerModel().value);

    await clearTimerNotificationForTest();
  }

  @visibleForTesting
  Future<void> bringAppToForegroundForTest() async {
    await alarmChannel.invokeMethod('bringAppToForeground');
  }

  @visibleForTesting
  Future<void> clearTimerNotificationForTest() async {
    await timerChannel.invokeMethod('clearTimerNotif');
  }

  @override
  onClose() async {
    Vibration.cancel();
    vibrationTimer!.cancel();
    AudioUtils.stopTimer(
      ringtoneName: await getFakeTimerModel().ringtoneName,
    );
    _subscription.cancel();
    super.onClose();
  }
}
