import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:uuid/uuid.dart';

class TimerController extends GetxController with WidgetsBindingObserver {
  final initialTime = DateTime(0, 0, 0, 0, 1, 0).obs;
  final remainingTime = const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  final currentTime = const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  RxInt startTime = 0.obs;
  RxBool isTimerPaused = false.obs;
  RxBool isTimerRunning = false.obs;
  Rx<Timer?> countdownTimer = Rx<Timer?>(null);
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
      }
    }
  }

  void createTimer() async {
    alarmRecord.label = 'Timer';
    alarmRecord.isOneTime = true;
    alarmRecord.alarmID = const Uuid().v4();
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

      countdownTimer.value = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setCountDown(),
      );
    }
  }

  void stopTimer() async {
    countdownTimer.value?.cancel();
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
    countdownTimer.value?.cancel();
    isTimerPaused.value = true;

    saveTimerStateToStorage();

    int timerId = await SecureStorageProvider().readTimerId();
    await IsarDb.deleteAlarm(timerId);
  }

  void resumeTimer() async {
    if (isTimerPaused.value) {
      countdownTimer.value = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setCountDown(),
      );
      isTimerPaused.value = false;

      createTimer();
    }
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
