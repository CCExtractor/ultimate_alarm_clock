import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StopwatchController extends GetxController {
  final RxBool isTimerPaused = true.obs;
  final Stopwatch _stopwatch = Stopwatch();
  final RxString _result = '00:00:00'.obs;
  late Timer timer;
  final RxList<String> _flag= <String>[].obs;
  String get result => _result.value;
  List<String> get flag => _flag;

  void toggleTimer() {
    if (isTimerPaused.value) {
      startTimer();
    } else {
      stopTimer();
    }
  }
  
  void lap_reset(){
    if(isTimerPaused.value){
      resetTime();
    }
    else{
      recordLap();
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
    _flag.clear();
  }
  void recordLap() {
    _flag.add('${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}');
  }

  void _updateResult() {
    _result.value =
      '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds %60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
  }
}
