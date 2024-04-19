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
  final Rx<TimerModel> currentlyRingingAlarm = Utils.genFakeTimerModel().obs;
  Timer? vibrationTimer;
  late StreamSubscription<FGBGType> _subscription;
  late RxBool isStart = false.obs;
  RxInt minutes = 1.obs;
  RxInt seconds = 0.obs;
  RxBool showButton = false.obs;
  final formattedDate = Utils.getFormattedDate(DateTime.now()).obs;
  Timer? _currentTimeTimer;

  void addMinutes(int incrementMinutes) {
    minutes.value += incrementMinutes;
  }
  
  void reStartTimer() async {
    Vibration.cancel();
    vibrationTimer!.cancel();
    isStart.value = true;
    String ringtoneName = currentlyRingingAlarm.value.ringtoneName;
    AudioUtils.stopAlarm(ringtoneName: ringtoneName);

    if (_currentTimeTimer!.isActive) {
      _currentTimeTimer?.cancel();
    }

    _currentTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel();
        vibrationTimer =
            Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
          Vibration.vibrate(pattern: [500, 3000]);
        });

        AudioUtils.playTimer(alarmRecord: currentlyRingingAlarm.value);

        startTimer();
      } else if (seconds.value == 0) {
        minutes.value--;
        seconds.value = 59;
      } else {
        seconds.value--;
      }
    });
  }

  void startTimer() {
    minutes.value = 1;
    isStart.value = false;
    _currentTimeTimer = Timer.periodic(
        Duration(
          milliseconds: Utils.getMillisecondsToAlarm(
            DateTime.now(),
            DateTime.now().add(const Duration(minutes: 1)),
          ),
        ), (timer) {
      formattedDate.value = Utils.getFormattedDate(DateTime.now());
    });
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
    startTimer();
    AudioUtils.playTimer(alarmRecord: currentlyRingingAlarm.value);

    await timerChannel.invokeMethod('cancelTimer');
  }

  @override
  void onClose() {
    super.onClose();
    Vibration.cancel();
    vibrationTimer!.cancel();
    AudioUtils.stopTimer(
      ringtoneName: currentlyRingingAlarm.value.ringtoneName,
    );
    _subscription.cancel();
    _currentTimeTimer?.cancel();
  }
}
