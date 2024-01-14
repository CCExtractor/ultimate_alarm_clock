import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';

import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

class StopwatchView extends GetView<TimerController> {
  StopwatchView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();
  final Stopwatch _stopwatch = Stopwatch();
  late Timer timer;
  RxBool isTimerPaused = true.obs;

  RxString _result = '00:00:00'.obs;

  void _toggleTimer() {
    if (isTimerPaused.value) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      _updateResult();});
    _stopwatch.start();
    isTimerPaused.value = false;
  }

  void _stopTimer() {
    timer.cancel();
    _stopwatch.stop();
    isTimerPaused.value = true;
  }

  void _resetTime() {
    _stopTimer();
    _stopwatch.reset();
    _updateResult();
  }

  void _updateResult() {
    _result.value =
    '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / 7.9),
        child: AppBar(
          toolbarHeight: height / 7.9,
          elevation: 0.0,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Utils.hapticFeedback();
                controller.saveTimerStateToStorage();
                Get.toNamed('/settings');
              },
              icon: const Icon(
                Icons.settings,
                size: 27,
              ),
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor.withOpacity(0.75)
                  : kprimaryTextColor.withOpacity(0.75),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              _result.value,
              style: const TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold
              ),
            )),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _toggleTimer,
                  child: Obx(() => Icon(
                    isTimerPaused.value ? Icons.play_arrow : Icons.pause,
                  )),
                ),
                // Reset button
                FloatingActionButton(
                  onPressed: _resetTime,
                  child: Icon(Icons.square_rounded)
                  )

              ],
            ),
          ],
        ),
      ),
    );
  }
}
