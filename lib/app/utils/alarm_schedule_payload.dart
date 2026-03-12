import 'dart:convert';

import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmSchedulePayload {
  static DateTime selectionReferenceTime({
    DateTime? now,
    required bool wantNextAlarm,
  }) {
    final currentTime = now ?? DateTime.now();
    final truncated = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      currentTime.hour,
      currentTime.minute,
    );

    return wantNextAlarm
        ? truncated.add(const Duration(minutes: 1))
        : truncated;
  }

  static DateTime? nextTriggerAt(
    AlarmModel alarm, {
    DateTime? referenceTime,
    bool inclusive = false,
  }) {
    final currentTime = referenceTime ?? DateTime.now();
    final alarmTime = Utils.stringToTimeOfDay(alarm.alarmTime);

    bool isValidCandidate(DateTime candidate) {
      return inclusive
          ? !candidate.isBefore(currentTime)
          : candidate.isAfter(currentTime);
    }

    DateTime buildCandidate(DateTime date) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        alarmTime.hour,
        alarmTime.minute,
      );
    }

    if (alarm.ringOn) {
      final scheduledDate = DateTime.tryParse(alarm.alarmDate.trim());
      if (scheduledDate == null) {
        return null;
      }

      final candidate = buildCandidate(scheduledDate);
      return isValidCandidate(candidate) ? candidate : null;
    }

    if (alarm.days.any((day) => day)) {
      for (var offset = 0; offset <= 7; offset++) {
        final candidateDate = currentTime.add(Duration(days: offset));
        final candidate = buildCandidate(candidateDate);
        final weekdayIndex = candidate.weekday - 1;

        if (alarm.days[weekdayIndex] && isValidCandidate(candidate)) {
          return candidate;
        }
      }

      return null;
    }

    final candidate = buildCandidate(currentTime);
    if (isValidCandidate(candidate)) {
      return candidate;
    }

    return candidate.add(const Duration(days: 1));
  }

  static Map<String, dynamic> fromAlarm(
    AlarmModel alarm, {
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final scheduledTime = nextTriggerAt(alarm, referenceTime: currentTime);
    if (scheduledTime == null) {
      throw StateError('Alarm does not have a future trigger time');
    }

    return {
      'triggerAtMs': scheduledTime.millisecondsSinceEpoch,
      'milliSeconds': Utils.getMillisecondsToAlarm(currentTime, scheduledTime),
      'activityMonitor': alarm.activityMonitor,
      'locationMonitor': alarm.isLocationEnabled ? 1 : 0,
      'location': alarm.location,
      'isWeather': alarm.isWeatherEnabled ? 1 : 0,
      'weatherTypes': jsonEncode(alarm.weatherTypes),
    };
  }
}
