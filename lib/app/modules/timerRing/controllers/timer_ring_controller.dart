import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';

class TimerRingController extends GetxController {
  MethodChannel timerChannel = const MethodChannel('timer');
  Timer? vibrationTimer;
  late StreamSubscription<FGBGType> _subscription;

  Future<TimerModel> getFakeTimerModel() async {
    TimerModel fakeTimer = await Utils.genFakeTimerModel();
    return fakeTimer;
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    // Preventing app from being minimized!
    _subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        timerChannel.invokeMethod('bringAppToForeground');
      }
    });
    vibrationTimer =
        Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
      Vibration.vibrate(pattern: [500, 3000]);
    });
    final timerRecord = await getFakeTimerModel();
    AudioUtils.playTimer(alarmRecord: timerRecord);

    await timerChannel.invokeMethod('cancelTimer');
  }

  @override
  Future<void> onClose() async {
    Vibration.cancel();
    vibrationTimer?.cancel();
    final timerRecord = await getFakeTimerModel();
    AudioUtils.stopTimer(
      ringtoneName: timerRecord.ringtoneName,
    );
    _subscription.cancel();
    super.onClose();
  }
}
