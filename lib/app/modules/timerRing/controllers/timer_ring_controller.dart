import 'dart:async';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';

class TimerRingController extends GetxController {
  final Rx<AlarmModel> currentlyRingingAlarm = Utils.genFakeAlarmModel().obs;
  Timer? vibrationTimer;

  @override
  void onInit() {
    super.onInit();
    vibrationTimer =
        Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
      Vibration.vibrate(pattern: [500, 3000]);
    });
    AudioUtils.playAlarm(alarmRecord: currentlyRingingAlarm.value);
  }

  @override
  void onClose() {
    Vibration.cancel();
    vibrationTimer!.cancel();
    AudioUtils.stopAlarm(
      ringtoneName: currentlyRingingAlarm.value.ringtoneName,
    );
    super.onClose();
  }
}
