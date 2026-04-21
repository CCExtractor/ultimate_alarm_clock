class PomodoroStateModel {
  final int workMinutes;
  final int shortBreakMinutes;
  final int totalSessions;
  final int currentSession;
  final String currentPhase;
  final int phaseDurationMs;
  final int remainingMs;
  final bool isRunning;
  final int phaseAnchorRemainingMs;
  final int? phaseStartedAtMs;

  const PomodoroStateModel({
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.totalSessions,
    required this.currentSession,
    required this.currentPhase,
    required this.phaseDurationMs,
    required this.remainingMs,
    required this.isRunning,
    required this.phaseAnchorRemainingMs,
    this.phaseStartedAtMs,
  });

  Map<String, dynamic> toJson() {
    return {
      'workMinutes': workMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'totalSessions': totalSessions,
      'currentSession': currentSession,
      'currentPhase': currentPhase,
      'phaseDurationMs': phaseDurationMs,
      'remainingMs': remainingMs,
      'isRunning': isRunning,
      'phaseAnchorRemainingMs': phaseAnchorRemainingMs,
      'phaseStartedAtMs': phaseStartedAtMs,
    };
  }

  factory PomodoroStateModel.fromJson(Map<String, dynamic> map) {
    return PomodoroStateModel(
      workMinutes: (map['workMinutes'] ?? 25) as int,
      shortBreakMinutes: (map['shortBreakMinutes'] ?? 5) as int,
      totalSessions: (map['totalSessions'] ?? 4) as int,
      currentSession: (map['currentSession'] ?? 1) as int,
      currentPhase: (map['currentPhase'] ?? 'idle') as String,
      phaseDurationMs: (map['phaseDurationMs'] ?? 0) as int,
      remainingMs: (map['remainingMs'] ?? 0) as int,
      isRunning: (map['isRunning'] ?? false) as bool,
      phaseAnchorRemainingMs: (map['phaseAnchorRemainingMs'] ?? 0) as int,
      phaseStartedAtMs: map['phaseStartedAtMs'] as int?,
    );
  }
}
