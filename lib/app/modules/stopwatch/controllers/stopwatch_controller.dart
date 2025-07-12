import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/flag_model.dart';

class StopwatchController extends GetxController {
  final RxBool isTimerPaused = true.obs;
  final Stopwatch _stopwatch = Stopwatch();
  final RxString _result = '00:00:00'.obs;
  final RxList<Flag> flags = <Flag>[].obs;
  Duration _lastFlagTime = Duration.zero;
  final RxBool hasFlags = false.obs;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late Timer timer;

  String get result => _result.value;

  void addFlag() {
    if (_stopwatch.isRunning) {
      final currentTime = _stopwatch.elapsed;
      final lapTime = currentTime - _lastFlagTime;
      hasFlags.value = true;
      flags.add(Flag(
          number: flags.length + 1, lapTime: lapTime, totalTime: currentTime));
      listKey.currentState
          ?.insertItem(0, duration: const Duration(milliseconds: 300));
      _lastFlagTime = currentTime;
    }
  }

  void clearFlags() {
    final length = flags.length;
    flags.clear();
    _lastFlagTime = Duration.zero;
    hasFlags.value = false;
    for (var i = 0; i < length; i++) {
      listKey.currentState?.removeItem(
        0,
        (context, animation) => const SizedBox.shrink(),
        duration: const Duration(milliseconds: 0),
      );
    }
  }

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
    clearFlags();
  }

  @override
  void onClose() {
    // Cancel timer if it's running
    if (!isTimerPaused.value) {
      timer.cancel();
    }
    
    // Stop the stopwatch
    _stopwatch.stop();
    
    super.onClose();
    
    debugPrint('🧹 StopwatchController disposed - all resources cleaned up');
  }

  void _updateResult() {
    _result.value =
        '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
  }
}
