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
  Timer? vibrationTimer;
  late StreamSubscription<FGBGType> _subscription;
   getFakeTimerModel()async {
   TimerModel fakeTimer = await Utils.genFakeTimerModel();
   return fakeTimer;
  }
  @override
  void onInit() async {
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
    AudioUtils.playTimer(alarmRecord: await getFakeTimerModel().value);

    await timerChannel.invokeMethod('cancelTimer');
  }

  @override
  onClose() async {
    // Cancel vibration
    Vibration.cancel();
    
    // Cancel vibration timer
    vibrationTimer?.cancel();
    
    // Stop audio
    AudioUtils.stopTimer(
      ringtoneName: (await getFakeTimerModel()).ringtoneName,
    );
    
    // Cancel background/foreground subscription
    _subscription.cancel();
    
    super.onClose();
    
    debugPrint('🧹 TimerRingController disposed - all resources cleaned up');
  }
}
