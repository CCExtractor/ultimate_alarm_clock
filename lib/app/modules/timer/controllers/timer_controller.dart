import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class TimerController extends FullLifeCycleController with FullLifeCycleMixin {
  MethodChannel timerChannel = const MethodChannel('timer');
  final remainingTime = const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  RxInt startTime = 0.obs;
  RxBool isTimerPaused = false.obs;
  RxBool isTimerRunning = false.obs;
  RxBool isbottom = false.obs;
  Stream? isarTimers;
  ScrollController scrollController = ScrollController();
  RxList timers = [].obs;
  RxList isRinging = [].obs;

  Timer? _timerCounter;

  late int currentTimerIsarId;
  var hours = 0.obs, minutes = 1.obs, seconds = 0.obs;

  final RxList timerList = [].obs;

  String strDigits(int n) => n.toString().padLeft(2, '0');

  getFakeTimerModel() async {
    TimerModel fakeTimer = await Utils.genFakeTimerModel();
    return fakeTimer;
  }

  updateTimerInfo() async {
    timerList.value = await IsarDb.getAllTimers();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
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
  Future<void> onClose() async {
    super.onClose();
    _timerCounter?.cancel();
  }

  void startRinger(int id) async {
    try {
      isRinging.add(id);
      print(isRinging);
      if (isRinging.length == 1) {
        await timerChannel.invokeMethod('playDefaultAlarm');
      }
    } on PlatformException catch (e) {
      print('Failed to schedule alarm: ${e.message}');
    }
  }

  void stopRinger(int id) async {
    try {
      isRinging.remove(id);
      print(isRinging);
      if (isRinging.isEmpty) {
        await timerChannel.invokeMethod('stopDefaultAlarm');
      }
    } on PlatformException catch (e) {
      print('Failed to schedule alarm: ${e.message}');
    }
  }

  Future<void> createTimer() async {
    TimerModel timerRecord = await getFakeTimerModel();
    timerRecord.startedOn = DateTime.now().toString();
    timerRecord.timerValue = Utils.getMillisecondsToAlarm(
      DateTime.now(),
      DateTime.now().add(remainingTime.value),
    );
    timerRecord.ringtoneName = 'Default';
    timerRecord.timerName =
        '${Utils.formatMilliseconds(timerRecord.timerValue)} Timer';
    await IsarDb.insertTimer(timerRecord);
    updateTimerInfo();
  }

  deleteTimer(int id) async {
    await IsarDb.deleteTimer(id).then((value) => updateTimerInfo());
    updateTimerInfo();
  }

  cancelTimer() async {
    await timerChannel.invokeMethod('cancelTimer');
  }

  void startTimer(TimerModel timer) {
    _timerCounter = Timer.periodic(Duration(seconds: 1), (timerTicker) {
      if (timer.timeElapsed < timer.timerValue) {
        timer.timeElapsed += 1000;
        IsarDb.updateTimerTick(timer);
      } else {
        stopTimer();
        startRinger(timer.timerId);
      }
    });
  }

  void stopTimer() {
    _timerCounter?.cancel();
  }

  void initializeTimer(TimerModel timer) {
    if (Utils.getDifferenceMillisFromNow(timer.startedOn, timer.timerValue) <= 0 &&
        timer.isPaused == 0) {
      timer.isPaused = 1;
      timer.timeElapsed = 0;
      IsarDb.updateTimerPauseStatus(timer);
    } else if (Utils.getDifferenceMillisFromNow(timer.startedOn, timer.timerValue) <
        timer.timerValue && timer.isPaused == 0) {
      timer.timeElapsed = timer.timerValue -
          Utils.getDifferenceMillisFromNow(timer.startedOn, timer.timerValue);
      IsarDb.updateTimerPauseStatus(timer);
    }
    if (timer.isPaused == 0) {
      startTimer(timer);
    }
  }

  Future<void> setPresetTimer(Duration presetDuration) async {
    remainingTime.value = presetDuration;
    await createTimer();
  }

  void resetTimer(TimerModel timer) {
    if (_timerCounter != null && timer.isPaused == 0) {
      stopTimer();
    }
    timer.timeElapsed = 0;
    IsarDb.updateTimerTick(timer);
    if (_timerCounter != null && timer.isPaused == 0) {
      timer.startedOn = DateTime.now().toString();
      IsarDb.updateTimerTick(timer).then((value) => startTimer(timer));
    }
  }

  void toggleTimer(TimerModel timer) {
    if (timer.isPaused == 0) {
      stopTimer();
    } else {
      startTimer(timer);
    }
    timer.isPaused = timer.isPaused == 0 ? 1 : 0;
    IsarDb.updateTimerPauseStatus(timer);
  }

  void completeTimer(TimerModel timer) {
    if (timer.timeElapsed >= timer.timerValue) {
      stopRinger(timer.timerId);
      timer.timeElapsed = 0;
      IsarDb.updateTimerTick(timer).then(
          (value) => IsarDb.updateTimerPauseStatus(timer));
      timer.isPaused = 1;
    }
  }

  @override
  void onDetached() {}

  @override
  Future<void> onHidden() async {
    try {
      await timerChannel.invokeMethod('runtimerNotif');
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to schedule alarm: ${e.message}');
      Get.back();
    }
  }

  @override
  onInactive() {}

  @override
  void onPaused() {}

  @override
  onResumed() async {
    try {
      await timerChannel.invokeMethod('clearTimerNotif');
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to schedule alarm: ${e.message}');
      Get.back();
    }
  }
}
