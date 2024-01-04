import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StopwatchController extends GetxController {
  final ScrollController lapsScrollController = ScrollController();
  RxInt hourDigit = 0.obs;
  RxInt minuteDigit = 0.obs;
  RxInt secondDigit = 0.obs;
  RxList<String> laps = <String>[].obs;
  RxBool isStarted = false.obs;

  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void start() {
    if (isStarted.value) {
      _timer.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
    }

    isStarted.toggle();
  }

  void addLap() {
    String lap =
        '${_formatDigit(hourDigit)}:${_formatDigit(minuteDigit)}:${_formatDigit(secondDigit)}';

    if (!laps.contains(lap) && isStarted.value) {
      lapsScrollController.animateTo(
        lapsScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      laps.add(lap);
    }
  }

  void reset() {
    _elapsedSeconds = 0;
    hourDigit.value = 0;
    minuteDigit.value = 0;
    secondDigit.value = 0;
    laps.clear();
    isStarted.value = false;
    _timer.cancel();
  }

  void _updateTime(Timer timer) {
    _elapsedSeconds++;

    hourDigit.value = _elapsedSeconds ~/ 3600;
    minuteDigit.value = (_elapsedSeconds ~/ 60) % 60;
    secondDigit.value = _elapsedSeconds % 60;
  }

  String _formatDigit(RxInt digit) {
    return digit.value.toString().padLeft(2, '0');
  }
}
