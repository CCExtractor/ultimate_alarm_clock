import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';


class LimitRange extends TextInputFormatter {
  LimitRange(this.minRange, this.maxRange) : assert(minRange < maxRange);
  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      if (newValue.text.isEmpty) {
        return newValue;
      }
      int value = int.parse(newValue.text);
      if (value < minRange) return TextEditingValue(text: minRange.toString());
      else if (value > maxRange) return TextEditingValue(text: maxRange.toString());
      return newValue;
    } catch (e) {
      debugPrint(e.toString());
      return newValue;
    }
  }
}

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
  
<<<<<<< HEAD
  // Add debounce mechanism to prevent multiple timer creation
  bool _isCreatingTimer = false;
  
=======
>>>>>>> upstream/gsoc-final-project-2025
  
  final TextEditingController inputHoursControllerTimer = TextEditingController(text: '0');
  final TextEditingController inputMinutesControllerTimer = TextEditingController(text: '1');
  final TextEditingController inputSecondsControllerTimer = TextEditingController(text: '0');
  
  
  final isTimePickerTimer = false.obs;
  
  
  void changeTimePickerTimer() {
    isTimePickerTimer.value = !isTimePickerTimer.value;
  }
  
  
  void setTimerTime() {
    try {
<<<<<<< HEAD
      debugPrint('🔥 setTimerTime called');
      debugPrint('🔥 Input controllers: H=${inputHoursControllerTimer.text}, M=${inputMinutesControllerTimer.text}, S=${inputSecondsControllerTimer.text}');
      
      int hours = int.parse(inputHoursControllerTimer.text);
      int minutes = int.parse(inputMinutesControllerTimer.text);
      int seconds = int.parse(inputSecondsControllerTimer.text);
      
      this.hours.value = hours;
      this.minutes.value = minutes;
      this.seconds.value = seconds;
      
      debugPrint('🔥 Values set: H=${this.hours.value}, M=${this.minutes.value}, S=${this.seconds.value}');
    } catch (e) {
      debugPrint('🚨 Error in setTimerTime: $e');
=======
      int hours = int.parse(inputHoursControllerTimer.text);
      int minutes = int.parse(inputMinutesControllerTimer.text);
      int seconds = int.parse(inputSecondsControllerTimer.text);
      this.hours.value = hours;
      this.minutes.value = minutes;
      this.seconds.value = seconds;
    } catch (e) {
      debugPrint(e.toString());
>>>>>>> upstream/gsoc-final-project-2025
    }
  }

  
  void setTextFieldTimerTime() {
    inputHoursControllerTimer.text = hours.value.toString();
    inputMinutesControllerTimer.text = minutes.value.toString();
    inputSecondsControllerTimer.text = seconds.value.toString();
  }

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
    await updateTimerInfo();
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
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Dispose of the scroll controller
    scrollController.dispose();
    
    
    // Dispose of text controllers
    inputHoursControllerTimer.dispose();
    inputMinutesControllerTimer.dispose();
    inputSecondsControllerTimer.dispose();
    
    super.onClose();
<<<<<<< HEAD
    
    debugPrint('🧹 TimerController disposed - all resources cleaned up');
=======
    inputHoursControllerTimer.dispose();
    inputMinutesControllerTimer.dispose();
    inputSecondsControllerTimer.dispose();
>>>>>>> upstream/gsoc-final-project-2025
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
    // Prevent multiple timer creation at the same time
    if (_isCreatingTimer) {
      debugPrint('🚫 Timer creation already in progress, ignoring...');
      return;
    }
    
    _isCreatingTimer = true;
    
    try {
      debugPrint('🔥 Creating timer with remainingTime: ${remainingTime.value}');
      debugPrint('🔥 Hours: ${hours.value}, Minutes: ${minutes.value}, Seconds: ${seconds.value}');
      
      TimerModel timerRecord = await getFakeTimerModel();

      timerRecord.startedOn = DateTime.now().toString();

      timerRecord.timerValue = Utils.getMillisecondsToAlarm(
        DateTime.now(),
        DateTime.now().add(remainingTime.value),
      );
      
      debugPrint('🔥 Timer value in milliseconds: ${timerRecord.timerValue}');
      
      timerRecord.ringtoneName = 'Default';
      timerRecord.timerName =
          '${Utils.formatMilliseconds(timerRecord.timerValue)} Timer';

      debugPrint('🔥 Timer name: ${timerRecord.timerName}');
      debugPrint('🔥 About to insert timer to database...');
      
      await IsarDb.insertTimer(timerRecord);
      debugPrint('🔥 Timer inserted successfully!');
      
      await updateTimerInfo();
      debugPrint('🔥 Timer info updated!');
      debugPrint('🔥 Timer list length: ${timerList.length}');
    } catch (e) {
      debugPrint('🚨 Error creating timer: $e');
      // If the error is about table not existing, try to recreate it
      if (e.toString().contains('no such table: timers')) {
        debugPrint('🔧 Attempting to fix timer database...');
        await _fixTimerDatabase();
        // Try again after fixing - recreate timer record
        try {
          TimerModel retryTimerRecord = await getFakeTimerModel();
          retryTimerRecord.startedOn = DateTime.now().toString();
          retryTimerRecord.timerValue = Utils.getMillisecondsToAlarm(
            DateTime.now(),
            DateTime.now().add(remainingTime.value),
          );
          retryTimerRecord.ringtoneName = 'Default';
          retryTimerRecord.timerName =
              '${Utils.formatMilliseconds(retryTimerRecord.timerValue)} Timer';
          
          await IsarDb.insertTimer(retryTimerRecord);
          debugPrint('🔥 Timer inserted successfully after database fix!');
          await updateTimerInfo();
        } catch (e2) {
          debugPrint('🚨 Still failed after database fix: $e2');
        }
      }
    } finally {
      // Always reset the flag, even if there was an error
      _isCreatingTimer = false;
    }
  }

  // Helper method to fix timer database issues
  Future<void> _fixTimerDatabase() async {
    try {
      final sql = await IsarDb().getTimerSQLiteDatabase();
      if (sql != null) {
        await sql.execute('''
          CREATE TABLE IF NOT EXISTS timers ( 
            id integer primary key autoincrement, 
            startedOn text not null,
            timerValue integer not null,
            timeElapsed integer not null,
            ringtoneName text not null,
            timerName text not null,
            isPaused integer not null)
        ''');
        debugPrint('✅ Timer database fixed successfully');
      }
    } catch (e) {
      debugPrint('🚨 Error fixing timer database: $e');
    }
  }

  deleteTimer(int id) async {
    await IsarDb.deleteTimer(id).then((value) => updateTimerInfo());
    await updateTimerInfo();
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
}
