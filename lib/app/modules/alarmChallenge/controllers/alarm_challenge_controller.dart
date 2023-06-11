import 'dart:async';

import 'package:get/get.dart';

class AlarmChallengeController extends GetxController {
  RxDouble progress = RxDouble(1.0);
  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() async {
    final duration = Duration(seconds: 15);
    final totalIterations = 150000;
    final decrement = 0.0001;
    final interval = duration ~/ totalIterations;

    for (var i = 0; i < totalIterations; i++) {
      if (progress.value <= 0.0) {
        Get.back();
        break;
      }
      await Future.delayed(interval);
      progress.value -= decrement;
    }
  }
}
