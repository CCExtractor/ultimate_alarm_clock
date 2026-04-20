import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';

class TimerRingController extends GetxController {
  final MethodChannel timerChannel = const MethodChannel('timer');
  Timer? vibrationTimer;
  late final StreamSubscription<FGBGType> _subscription;

  Future<TimerModel> getFakeTimerModel() async {
    return Utils.genFakeTimerModel();
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    // Keep app foregrounded while ringing
    _subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        timerChannel.invokeMethod('bringAppToForeground');
      }
    });

    vibrationTimer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      Vibration.vibrate(pattern: const [500, 3000]);
    });

    final model = await getFakeTimerModel(); // FIX: no .value
    AudioUtils.playTimer(alarmRecord: model); // FIX

    await timerChannel.invokeMethod('cancelTimer');
  }

  @override
  Future<void> onClose() async {
    Vibration.cancel();
    vibrationTimer?.cancel(); // FIX: null-safe

    final model = await getFakeTimerModel(); // FIX: await once
    AudioUtils.stopTimer(ringtoneName: model.ringtoneName); // FIX

    await _subscription.cancel();
    super.onClose();
  }
}




// import 'dart:async';

// import 'package:flutter/services.dart';
// import 'package:flutter_fgbg/flutter_fgbg.dart';
// import 'package:get/get.dart';
// import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
// import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
// import 'package:ultimate_alarm_clock/app/utils/utils.dart';
// import 'package:vibration/vibration.dart';

// class TimerRingController extends GetxController {
//   MethodChannel timerChannel = const MethodChannel('timer');
//   Timer? vibrationTimer;
//   late StreamSubscription<FGBGType> _subscription;
//    getFakeTimerModel()async {
//    TimerModel fakeTimer = await Utils.genFakeTimerModel();
//    return fakeTimer;
//   }
//   @override
//   void onInit() async {
//     super.onInit();

//     // Preventing app from being minimized!
//     _subscription = FGBGEvents.stream.listen((event) {
//       if (event == FGBGType.background) {
//         timerChannel.invokeMethod('bringAppToForeground');
//       }
//     });
//     vibrationTimer =
//         Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
//       Vibration.vibrate(pattern: [500, 3000]);
//     });
//     AudioUtils.playTimer(alarmRecord: await getFakeTimerModel().value);

//     await timerChannel.invokeMethod('cancelTimer');
//   }

//   @override
//   onClose() async {
//     Vibration.cancel();
//     vibrationTimer!.cancel();
//     AudioUtils.stopTimer(
//       ringtoneName: await getFakeTimerModel().ringtoneName,
//     );
//     _subscription.cancel();
//     super.onClose();
//   }
// }
