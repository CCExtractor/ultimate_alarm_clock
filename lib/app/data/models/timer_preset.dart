class TimerPreset {
  final Duration duration;

  TimerPreset({
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'duration': duration.inMilliseconds,
      };

  factory TimerPreset.fromJson(Map<String, dynamic> json) => TimerPreset(
        duration: Duration(milliseconds: json['duration']),
      );
}