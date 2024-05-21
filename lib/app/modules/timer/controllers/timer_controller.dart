import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:isar/isar.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:uuid/uuid.dart';

class TimerController extends GetxController with WidgetsBindingObserver {
  MethodChannel timerChannel = const MethodChannel('timer');
  final initialTime = DateTime(0, 0, 0, 0, 1, 0).obs;
  final remainingTime = const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  final currentTime = const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  RxInt startTime = 0.obs;
  RxBool isTimerPaused = false.obs;
  RxBool isTimerRunning = false.obs;
  RxBool isbottom = false.obs;
  Stream? isarTimers;
  ScrollController scrollController = ScrollController();
  RxList timers = [].obs;
  RxList pausedTimers = [].obs;
  RxList timeElapsedList = [].obs;
  RxList timerAnimationControllerList = [].obs;

  late AnimationController _controller;

  getFakeTimerModel() async {
    TimerModel fakeTimer = await Utils.genFakeTimerModel();
    return fakeTimer;
  }

  updateTimerInfo() async {
    timerList.value = await IsarDb.getAllTimers();
  }

  initializeTempTimerVariables() {
    pausedTimers.value = timerList.map((pause) => pause.isPaused).toList();
    timeElapsedList.value = timerList.map((time) => time.timeElapsed).toList();
  }

  void toggleAnimation(int index) {
    pausedTimers[index] == 0
        ? pausedTimers[index] = 1
        : pausedTimers[index] = 0;

    print(pausedTimers);
  }

  late int currentTimerIsarId;
  var hours = 0.obs, minutes = 1.obs, seconds = 0.obs;

  final _secureStorageProvider = SecureStorageProvider();

  String strDigits(int n) => n.toString().padLeft(2, '0');

  final RxList timerList = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadTimerStateFromStorage();
    isarTimers = IsarDb.getTimers();
    updateTimerInfo();
    scrollController.addListener(() {
      if (scrollController.offset < scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        isbottom.value = true;
      } else {
        isbottom.value = false;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void saveTimerStateToStorage() async {
    await _secureStorageProvider.writeRemainingTimeInSeconds(
      remainingTimeInSeconds: remainingTime.value.inSeconds,
    );
    await _secureStorageProvider.writeStartTime(
      startTime: startTime.value,
    );
    await _secureStorageProvider.writeIsTimerRunning(
      isTimerRunning: isTimerRunning.value,
    );
    await _secureStorageProvider.writeIsTimerPaused(
      isTimerPaused: isTimerPaused.value,
    );
  }

  void loadTimerStateFromStorage() async {
    final storedRemainingTimeInSeconds =
        await _secureStorageProvider.readRemainingTimeInSeconds();
    final storedStartTime = await _secureStorageProvider.readStartTime();
    isTimerRunning.value = await _secureStorageProvider.readIsTimerRunning();
    isTimerPaused.value = await _secureStorageProvider.readIsTimerPaused();

    if (storedRemainingTimeInSeconds != -1 && storedStartTime != -1) {
      if (!isTimerPaused.value) {
        final elapsedMilliseconds =
            DateTime.now().millisecondsSinceEpoch - storedStartTime;
        final elapsedSeconds = (elapsedMilliseconds / 1000).round();
        final updatedRemainingTimeInSeconds =
            storedRemainingTimeInSeconds - elapsedSeconds;

        if (updatedRemainingTimeInSeconds > 0) {
          // Update remaining time and start timer from the correct point
          int hours = updatedRemainingTimeInSeconds ~/
              3600; // Calculate the number of hours
          int remainingSeconds = updatedRemainingTimeInSeconds %
              3600; // Calculate the remaining seconds
          int minutes =
              remainingSeconds ~/ 60; // Calculate the number of minutes
          int seconds =
              remainingSeconds % 60; // Calculate the number of seconds
          remainingTime.value = Duration(
            hours: hours,
            minutes: minutes,
            seconds: seconds,
          );
        } else {
          stopTimer();
        }
      } else {
        int hours = storedRemainingTimeInSeconds ~/
            3600; // Calculate the number of hours
        int remainingSeconds = storedRemainingTimeInSeconds %
            3600; // Calculate the remaining seconds
        int minutes = remainingSeconds ~/ 60; // Calculate the number of minutes
        int seconds = remainingSeconds % 60; // Calculate the number of seconds
        remainingTime.value = Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
        );
      }
    }
  }

  void createTimer() async {
    TimerModel timerRecord = await getFakeTimerModel();

    timerRecord.startedOn = Utils.formatDateTimeToHHMMSS(
      DateTime.now(),
    );
    timerRecord.timerValue = Utils.getMillisecondsToAlarm(
      DateTime.now(),
      DateTime.now().add(remainingTime.value),
    );
    timerRecord.ringtoneName = 'Default';
    timerRecord.timerName =
        "${Utils.formatMilliseconds(timerRecord.timerValue)} Timer";

    IsarDb.insertTimer(timerRecord).then((value) {
      updateTimerInfo();
      initializeTempTimerVariables();
      timerList.forEach((timer) {
        print('Timer ID: ${timer.timerId}');
        print('Main Timer Time: ${timer.startedOn}');
        print('Interval to Alarm: ${timer.timerValue}');
        print('Ringtone Name: ${timer.ringtoneName}');
        print('Timer Name: ${timer.timerName}');
        print('Is Paused: ${timer.isPaused}');
      });
      Get.back();
    });

  }

  scheduleTimer(TimerModel timerRecord) async {
    DateTime? timerDateTime = Utils.stringToDateTime(timerRecord.startedOn);
    if (timerDateTime != null) {
      await timerChannel.invokeMethod('cancelTimer');
      int intervaltoTimer = Utils.getMillisecondsToTimer(
        DateTime.now(),
        timerDateTime,
      );
      try {
        await timerChannel
            .invokeMethod('scheduleTimer', {'milliSeconds': intervaltoTimer});
      } on PlatformException catch (e) {
        print("Failed to schedule alarm: ${e.message}");
      }
    }
  }

  deleteTimer(int id) async {
    await IsarDb.deleteTimer(id).then((value) => updateTimerInfo());
    updateTimerInfo();
  }

  cancelTimer() async {
    await timerChannel.invokeMethod('cancelTimer');
  }

  void stopTimer() async {
    isTimerPaused.value = false;
    isTimerRunning.value = false;
    initialTime.value = DateTime(0, 0, 0, 0, 1, 0);
    remainingTime.value = Duration(
      hours: initialTime.value.hour,
      minutes: initialTime.value.minute,
      seconds: initialTime.value.second,
    );
    currentTime.value = const Duration(hours: 0, minutes: 0, seconds: 0);
    startTime.value = 0;
    await _secureStorageProvider.removeRemainingTimeInSeconds();
    await _secureStorageProvider.removeStartTime();
    await _secureStorageProvider.writeIsTimerRunning(isTimerRunning: false);
    await _secureStorageProvider.writeIsTimerPaused(isTimerPaused: false);
  }

  void pauseTimer() async {
    isTimerPaused.value = true;

    saveTimerStateToStorage();
    await cancelTimer();
    int timerId = await SecureStorageProvider().readTimerId();
    await IsarDb.deleteAlarm(timerId);
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = remainingTime.value.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      stopTimer();
    } else {
      remainingTime.value = Duration(seconds: seconds);
    }
  }
}
