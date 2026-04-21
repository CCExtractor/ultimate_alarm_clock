import 'dart:async';
import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/pomodoro_state_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';

class PomodoroController extends GetxController {
  PomodoroController();

  static const String phaseIdle = 'idle';
  static const String phaseWork = 'work';
  static const String phaseBreak = 'break';
  static const String phaseCompleted = 'completed';

  final RxInt workMinutes = 25.obs;
  final RxInt shortBreakMinutes = 5.obs;
  final RxInt totalSessions = 4.obs;

  final RxInt currentSession = 1.obs;
  final RxString currentPhase = phaseIdle.obs;
  final RxInt phaseDurationMs = 0.obs;
  final RxInt remainingMs = 0.obs;
  final RxBool isRunning = false.obs;

  final GetStorageProvider storage = Get.find<GetStorageProvider>();
  final ThemeController themeController = Get.find<ThemeController>();

  Timer? _ticker;
  int _phaseAnchorRemainingMs = 0;
  int? _phaseStartedAtMs;

  @override
  void onInit() {
    super.onInit();
    _restoreState();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    AudioUtils.stopTimer(ringtoneName: 'Default');
    super.onClose();
  }

  void updateWorkMinutes(int value) {
    workMinutes.value = max(1, value);
    if (!isActive) {
      _persistState();
    }
  }

  void updateShortBreakMinutes(int value) {
    shortBreakMinutes.value = max(1, value);
    if (!isActive) {
      _persistState();
    }
  }

  void updateTotalSessions(int value) {
    totalSessions.value = max(1, value);
    if (currentSession.value > totalSessions.value) {
      currentSession.value = totalSessions.value;
    }
    if (!isActive) {
      _persistState();
    }
  }

  bool get isActive =>
      currentPhase.value == phaseWork || currentPhase.value == phaseBreak;

  bool get canStart =>
      currentPhase.value == phaseIdle || currentPhase.value == phaseCompleted;

  bool get canResume => isActive && !isRunning.value;

  bool get canPause => isActive && isRunning.value;

  bool get canSkip => isActive;

  int get displayRemainingMs {
    if (isActive) {
      return remainingMs.value;
    }
    return Duration(minutes: workMinutes.value).inMilliseconds;
  }

  double get progress {
    if (phaseDurationMs.value <= 0) {
      return 0;
    }
    final int elapsed = phaseDurationMs.value - remainingMs.value;
    return elapsed / phaseDurationMs.value;
  }

  String get phaseLabel {
    if (currentPhase.value == phaseWork) {
      return 'Work'.tr;
    }
    if (currentPhase.value == phaseBreak) {
      return 'Break'.tr;
    }
    if (currentPhase.value == phaseCompleted) {
      return 'Completed'.tr;
    }
    return 'Ready'.tr;
  }

  Future<void> startOrResumePomodoro() async {
    if (canStart) {
      if (!_validateConfig()) {
        return;
      }
      currentSession.value = 1;
      _startWorkPhase(showStartToast: true);
      return;
    }

    if (canResume) {
      _phaseStartedAtMs = DateTime.now().millisecondsSinceEpoch;
      _phaseAnchorRemainingMs = remainingMs.value;
      isRunning.value = true;
      _startTicker();
      _persistState();
      _showToast('Pomodoro resumed'.tr);
    }
  }

  void pausePomodoro() {
    if (!canPause) {
      return;
    }
    _updateRemainingFromClock();
    _ticker?.cancel();
    _ticker = null;
    _phaseStartedAtMs = null;
    isRunning.value = false;
    _persistState();
    _showToast('Pomodoro paused'.tr);
  }

  void skipPhase() {
    if (!canSkip) {
      _showError('No active pomodoro phase to skip'.tr);
      return;
    }

    if (currentPhase.value == phaseWork) {
      _showToast('Work session skipped'.tr);
      _startBreakPhase(showStartToast: true);
      return;
    }

    _showToast('Break skipped'.tr);
    _startNextWorkOrFinish(showStartToast: true);
  }

  Future<void> resetPomodoro() async {
    _ticker?.cancel();
    _ticker = null;
    _phaseStartedAtMs = null;
    _phaseAnchorRemainingMs = 0;

    currentPhase.value = phaseIdle;
    currentSession.value = 1;
    phaseDurationMs.value = 0;
    remainingMs.value = 0;
    isRunning.value = false;

    await storage.clearPomodoroState();
    _showToast('Pomodoro reset'.tr);
  }

  void _startWorkPhase({required bool showStartToast}) {
    _startPhase(
      phase: phaseWork,
      durationMs: Duration(minutes: workMinutes.value).inMilliseconds,
    );
    if (showStartToast) {
      _showToast('Work session started'.tr);
    }
  }

  void _startBreakPhase({required bool showStartToast}) {
    _startPhase(
      phase: phaseBreak,
      durationMs: Duration(minutes: shortBreakMinutes.value).inMilliseconds,
    );
    if (showStartToast) {
      _showToast('Break started'.tr);
    }
  }

  void _startPhase({
    required String phase,
    required int durationMs,
  }) {
    _ticker?.cancel();
    currentPhase.value = phase;
    phaseDurationMs.value = durationMs;
    remainingMs.value = durationMs;
    _phaseAnchorRemainingMs = durationMs;
    _phaseStartedAtMs = DateTime.now().millisecondsSinceEpoch;
    isRunning.value = true;

    _startTicker();
    _persistState();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingFromClock();

      if (remainingMs.value <= 0) {
        _handlePhaseComplete();
      } else {
        _persistState();
      }
    });
  }

  void _updateRemainingFromClock() {
    if (_phaseStartedAtMs == null) {
      return;
    }

    final int elapsed =
        DateTime.now().millisecondsSinceEpoch - _phaseStartedAtMs!;
    final int nextRemaining = _phaseAnchorRemainingMs - elapsed;
    remainingMs.value = max(0, nextRemaining);
  }

  void _handlePhaseComplete() {
    _ticker?.cancel();
    _ticker = null;
    _phaseStartedAtMs = null;
    _phaseAnchorRemainingMs = 0;

    _showToast('Phase completed'.tr);

    if (currentPhase.value == phaseWork) {
      if (currentSession.value >= totalSessions.value) {
        _markCompleted();
      } else {
        _startBreakPhase(showStartToast: true);
      }
      return;
    }

    if (currentPhase.value == phaseBreak) {
      _startNextWorkOrFinish(showStartToast: true);
    }
  }

  void _startNextWorkOrFinish({required bool showStartToast}) {
    if (currentSession.value >= totalSessions.value) {
      _markCompleted();
      return;
    }

    currentSession.value += 1;
    _startWorkPhase(showStartToast: showStartToast);
  }

  void _markCompleted() {
    currentPhase.value = phaseCompleted;
    phaseDurationMs.value = 0;
    remainingMs.value = 0;
    isRunning.value = false;
    _phaseStartedAtMs = null;
    _phaseAnchorRemainingMs = 0;
    _persistState();

    _playShortCompletionSound();
    _showToast('Pomodoro completed'.tr);
  }

  bool _validateConfig() {
    if (workMinutes.value < 1 ||
        shortBreakMinutes.value < 1 ||
        totalSessions.value < 1) {
      _showError('Please set valid pomodoro values'.tr);
      return false;
    }
    return true;
  }

  void _playShortCompletionSound() {
    final TimerModel completionTone = TimerModel(
      timerValue: 0,
      timeElapsed: 0,
      startedOn: DateTime.now().toString(),
      ringtoneName: 'Default',
      timerName: 'Pomodoro',
    );

    AudioUtils.playTimer(alarmRecord: completionTone);
    Future.delayed(const Duration(seconds: 2), () {
      AudioUtils.stopTimer(ringtoneName: 'Default');
    });
  }

  void _persistState() {
    final PomodoroStateModel state = PomodoroStateModel(
      workMinutes: workMinutes.value,
      shortBreakMinutes: shortBreakMinutes.value,
      totalSessions: totalSessions.value,
      currentSession: currentSession.value,
      currentPhase: currentPhase.value,
      phaseDurationMs: phaseDurationMs.value,
      remainingMs: remainingMs.value,
      isRunning: isRunning.value,
      phaseAnchorRemainingMs: _phaseAnchorRemainingMs,
      phaseStartedAtMs: _phaseStartedAtMs,
    );

    storage.writePomodoroState(state.toJson());
  }

  void _restoreState() {
    final Map<String, dynamic>? raw = storage.readPomodoroState();
    if (raw == null) {
      return;
    }

    final PomodoroStateModel state = PomodoroStateModel.fromJson(raw);
    workMinutes.value = max(1, state.workMinutes);
    shortBreakMinutes.value = max(1, state.shortBreakMinutes);
    totalSessions.value = max(1, state.totalSessions);

    currentSession.value =
        max(1, min(state.currentSession, totalSessions.value));
    currentPhase.value = state.currentPhase;
    phaseDurationMs.value = max(0, state.phaseDurationMs);
    remainingMs.value = max(0, state.remainingMs);
    isRunning.value = state.isRunning;

    _phaseAnchorRemainingMs = max(0, state.phaseAnchorRemainingMs);
    _phaseStartedAtMs = state.phaseStartedAtMs;

    if (!isRunning.value || !isActive || _phaseStartedAtMs == null) {
      isRunning.value = false;
      _phaseStartedAtMs = null;
      _phaseAnchorRemainingMs = remainingMs.value;
      return;
    }

    _updateRemainingFromClock();

    if (remainingMs.value <= 0) {
      _handleRestorePhaseCompletion();
      return;
    }

    _phaseAnchorRemainingMs = remainingMs.value;
    _phaseStartedAtMs = DateTime.now().millisecondsSinceEpoch;
    _startTicker();
    _persistState();
  }

  void _handleRestorePhaseCompletion() {
    if (currentPhase.value == phaseWork) {
      if (currentSession.value >= totalSessions.value) {
        _markCompletedAfterRestore();
      } else {
        _startBreakAfterRestore();
      }
      return;
    }

    if (currentPhase.value == phaseBreak) {
      if (currentSession.value >= totalSessions.value) {
        _markCompletedAfterRestore();
      } else {
        currentSession.value += 1;
        _startWorkAfterRestore();
      }
      return;
    }

    isRunning.value = false;
    _phaseStartedAtMs = null;
    _phaseAnchorRemainingMs = 0;
    _persistState();
  }

  void _startWorkAfterRestore() {
    _startPhase(
      phase: phaseWork,
      durationMs: Duration(minutes: workMinutes.value).inMilliseconds,
    );
  }

  void _startBreakAfterRestore() {
    _startPhase(
      phase: phaseBreak,
      durationMs: Duration(minutes: shortBreakMinutes.value).inMilliseconds,
    );
  }

  void _markCompletedAfterRestore() {
    currentPhase.value = phaseCompleted;
    phaseDurationMs.value = 0;
    remainingMs.value = 0;
    isRunning.value = false;
    _phaseStartedAtMs = null;
    _phaseAnchorRemainingMs = 0;
    _persistState();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: themeController.secondaryBackgroundColor.value,
      textColor: themeController.primaryTextColor.value,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
