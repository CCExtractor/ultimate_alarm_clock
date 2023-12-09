import 'dart:async';

import 'package:get/get.dart';

class StopwatchController extends GetxController {
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
    laps.add(lap);
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