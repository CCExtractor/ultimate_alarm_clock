import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_pop_up/overlay_pop_up.dart';

class StopwatchController extends GetxController {
  final RxBool isTimerPaused = true.obs;
  final Stopwatch _stopwatch = Stopwatch();
  final RxString _result = '00:00:00'.obs;
  late Timer timer;

  String get result => _result.value;

  void toggleTimer() {
    if (isTimerPaused.value) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  void startTimer() async {
    timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      _updateResult();
    });
    _stopwatch.start();
    _showStopWatchPopUpOverlay();
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
    _closeStopWatchPopUpOverlay();
    _updateResult();
  }

  void _updateResult() {
    _result.value =
        '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
    _updatePopUpOverLayStopWatchResult(_result);
  }

  void _showStopWatchPopUpOverlay()async{
    final permission = await OverlayPopUp.checkPermission();
    if (permission) {
      if (!await OverlayPopUp.isActive()) {
        await OverlayPopUp.showOverlay(
          width: 500,
          height: 170,
          screenOrientation: ScreenOrientation.portrait,
          closeWhenTapBackButton: true,
          isDraggable: true,
        );

        return;
      }
    }  else {
      await OverlayPopUp.requestPermission();

    }
  }

  void _updatePopUpOverLayStopWatchResult(RxString newResult)async{
    if (await OverlayPopUp.isActive()) {
    await OverlayPopUp.sendToOverlay({'time': newResult.value});
    }
  }

  void _closeStopWatchPopUpOverlay()async{
    await OverlayPopUp.closeOverlay();
  }
}
