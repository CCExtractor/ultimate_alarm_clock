// stopwatch_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StopwatchController extends GetxController {
  final RxBool isTimerPaused = true.obs;
  final Stopwatch _stopwatch = Stopwatch();
  final RxString _result = '00:00:00'.obs;
  final RxList<String> _laps = <String>[].obs;
  late Timer timer;

  bool isLapButtonEnabled = true;
  String get result => _result.value;
  List<String> get laps => _laps;

  void toggleTimer() {
    if (isTimerPaused.value) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      _updateResult();
    });
    _stopwatch.start();
    isTimerPaused.value = false;
  }

  void stopTimer() {
    timer.cancel();
    _stopwatch.stop();
    isTimerPaused.value = true;
  }

  void resetTime() {
    stopTimer();
    _stopwatch.reset();
    _updateResult();
    _laps.clear();
  }

  void recordLap() {
    if (_stopwatch.isRunning && isLapButtonEnabled) {
      isLapButtonEnabled = false; // Disable lap button temporarily
      _laps.add(_formattedElapsedTime());
      update();
      print('Lap recorded: ${_formattedElapsedTime()}');

      // Allow lap button after a short delay (adjust as needed)
      Future.delayed(const Duration(milliseconds: 500), () {
        isLapButtonEnabled = true;
      });
    }
  }

  void _updateResult() {
    _result.value =
        '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
  }

  String _formattedElapsedTime() {
    return '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
  }
}
