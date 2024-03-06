import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:uuid/uuid.dart';

class TimerController extends GetxController with WidgetsBindingObserver {
  final initialTime = DateTime(0, 0, 0, 0, 1, 0).obs;
  final storage = Get.find<GetStorageProvider>();
  final remainingTime = const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  final currentTime = const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  final timerStartTime = 0.obs;
  final timerRemainingTime = 0.obs;
  RxInt startTime = 0.obs;
  RxBool isTimerPaused = false.obs;
  RxBool isTimerRunning = false.obs;
  Rx<Timer?> countdownTimer = Rx<Timer?>(null);
  Rx<Timer?> progressTimer = Rx<Timer?>(null);
  AlarmModel alarmRecord = Utils.genFakeAlarmModel();
  late int currentTimerIsarId;
  var hours = 0.obs, minutes = 1.obs, seconds = 0.obs;

  final _secureStorageProvider = SecureStorageProvider();

  String strDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadTimerStateFromStorage();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      loadTimerStateFromStorage();
    }
  }

  void saveTimerStateToStorage() async {
    await storage.writeRemainingTimeInSeconds(
      remainingTimeInSeconds: remainingTime.value.inSeconds,
    );
    await storage.writeStartTime(
      startTime: startTime.value,
    );
    await storage.writeTimerStartTimeInSeconds(
        timerStartTimeInSeconds: (timerStartTime.value).toInt());
    await storage.writeIsTimerRunning(
      isTimerRunning: isTimerRunning.value,
    );
    await storage.writeIsTimerPaused(
      isTimerPaused: isTimerPaused.value,
    );
  }

  void loadTimerStateFromStorage() async {
    final storedRemainingTimeInSeconds =
        await storage.readRemainingTimeInSeconds();
    final storedStartTime = await storage.readStartTime();
    isTimerRunning.value = await storage.readIsTimerRunning();
    isTimerPaused.value = await storage.readIsTimerPaused();
    timerStartTime.value = await storage.readTimerStartTimeInSeconds();

    if (storedRemainingTimeInSeconds != -1 &&
        storedStartTime != -1 &&
        timerStartTime > 0) {
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
          timerRemainingTime.value = remainingTime.value.inMilliseconds;
          startTimer();
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
        timerRemainingTime.value = remainingTime.value.inMilliseconds;
      }
    }
  }

  void createTimer() async {
    alarmRecord.label = 'Timer';
    alarmRecord.isOneTime = true;
    alarmRecord.alarmID = const Uuid().v4();
    startTime.value = remainingTime.value.inMilliseconds;
    alarmRecord.alarmTime = Utils.formatDateTimeToHHMMSS(
      DateTime.now().add(remainingTime.value),
    );
    alarmRecord.mainAlarmTime = Utils.formatDateTimeToHHMMSS(
      DateTime.now().add(remainingTime.value),
    );
    alarmRecord.intervalToAlarm = Utils.getMillisecondsToAlarm(
      DateTime.now(),
      DateTime.now().add(remainingTime.value),
    );
    alarmRecord.ringtoneName = 'Default';
    alarmRecord.isEnabled = true;
    alarmRecord.isTimer = true;
    await IsarDb.addAlarm(alarmRecord);
    await _secureStorageProvider.writeTimerId(timerId: alarmRecord.isarId);
  }

  void startTimer() async {
    if (remainingTime.value.inSeconds > 0) {
      final now = DateTime.now();
      startTime.value = now.millisecondsSinceEpoch;
      isTimerRunning.value = true;
      isTimerPaused.value = false;

      saveTimerStateToStorage();
      progressTimer.value = Timer.periodic(
        const Duration(milliseconds: 10),
        (_) => setProgressCountDown(),
      );
      countdownTimer.value = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setCountDown(),
      );
    }
  }

  void stopTimer() async {
    countdownTimer.value?.cancel();
    progressTimer.value?.cancel();
    isTimerPaused.value = false;
    isTimerRunning.value = false;
    initialTime.value = DateTime(0, 0, 0, 0, 1, 0);
    remainingTime.value = Duration(
      hours: initialTime.value.hour,
      minutes: initialTime.value.minute,
      seconds: initialTime.value.second,
    );
    timerRemainingTime.value = 0;
    timerStartTime.value = 0;
    currentTime.value = const Duration(hours: 0, minutes: 0, seconds: 0);
    startTime.value = 0;

    await storage.removeRemainingTimeInSeconds();
    await storage.removeStartTime();
    await storage.writeIsTimerRunning(isTimerRunning: false);
    await storage.writeIsTimerPaused(isTimerPaused: false);
  }

  void pauseTimer() async {
    countdownTimer.value?.cancel();
    progressTimer.value?.cancel();
    isTimerPaused.value = true;

    saveTimerStateToStorage();

    int timerId = await SecureStorageProvider().readTimerId();
    await IsarDb.deleteAlarm(timerId);
  }

  void resumeTimer() async {
    if (isTimerPaused.value) {
      progressTimer.value =
          Timer.periodic(const Duration(milliseconds: 10), (_) {
        setProgressCountDown();
      });
      countdownTimer.value = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setCountDown(),
      );

      isTimerPaused.value = false;

      createTimer();
    }
  }

  void setProgressCountDown() {
    const reduceMillisecondsBy = 10;
    final milliSeconds = timerRemainingTime.value - reduceMillisecondsBy;

    if (milliSeconds > 0) {
      timerRemainingTime.value = milliSeconds;
    }
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = remainingTime.value.inSeconds - reduceSecondsBy;

    if (seconds < 0) {
      stopTimer();
    } else {
      if (seconds < 1) {
        timerRemainingTime.value = seconds * 1000;
      }
      remainingTime.value = Duration(seconds: seconds);
    }
  }
}
