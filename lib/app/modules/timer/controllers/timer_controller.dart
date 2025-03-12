import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_preset.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';

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
  RxList<TimerPreset> customPresets = <TimerPreset>[].obs;

  getFakeTimerModel() async {
    TimerModel fakeTimer = await Utils.genFakeTimerModel();
    return fakeTimer;
  }

  updateTimerInfo() async {
    timerList.value = await IsarDb.getAllTimers();
  }

  late int currentTimerIsarId;
  var hours = 0.obs, minutes = 1.obs, seconds = 0.obs;

  String strDigits(int n) => n.toString().padLeft(2, '0');

  final RxList timerList = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    isarTimers = IsarDb.getTimers();
    updateTimerInfo();
    loadCustomPresets();
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
  }

  void startRinger(int id) async {
    try {
      isRinging.value.add(id);
      print(isRinging.value);
      if (isRinging.value.length == 1) {
        await timerChannel.invokeMethod('playDefaultAlarm');
      }
    } on PlatformException catch (e) {
      print('Failed to schedule alarm: ${e.message}');
    }
  }

  void stopRinger(int id) async {
    try {
      isRinging.value.remove(id);
      print(isRinging.value);
      if (isRinging.value.length == 0) {
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

  Future<void> setPresetTimer(Duration presetDuration) async {
    remainingTime.value = presetDuration;
    await createTimer();
  }

  void loadCustomPresets() async {
    final storage = Get.find<GetStorageProvider>();
    List<Map<String, dynamic>> presetsJson =
        await storage.readTimerPreset('customPresets');
    customPresets.value =
        presetsJson.map((json) => TimerPreset.fromJson(json)).toList();
  }

  void saveCustomPreset(Duration duration) async {
    final storage = Get.find<GetStorageProvider>();
    if (customPresets.any((preset) => preset.duration == duration)) {
      return;
    }
    TimerPreset preset = TimerPreset(duration: duration);
    customPresets.add(preset);
    List<Map<String, dynamic>> presetsJson =
        customPresets.map((preset) => preset.toJson()).toList();
    await storage.writeTimerPreset('customPresets', presetsJson);
  }

  void deleteCustomPreset(int index) async {
    final storage = Get.find<GetStorageProvider>();
    customPresets.removeAt(index);
    List<Map<String, dynamic>> presetsJson =
        customPresets.map((preset) => preset.toJson()).toList();
    await storage.writeTimerPreset('customPresets', presetsJson);
  }
}
