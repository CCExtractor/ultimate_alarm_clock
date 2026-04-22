import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:intl/intl.dart';

class TimezoneData {
  final String id;
  final String displayName;
  final String formattedOffset;
  final int offsetInMinutes;

  const TimezoneData({
    required this.id,
    required this.displayName,
    required this.formattedOffset,
    required this.offsetInMinutes,
  });
}

class TimezoneUtils {
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }
  }

  static List<TimezoneData> getCommonTimezones() {
    final commonTimezones = [
      'UTC',
      'America/New_York',
      'America/Chicago',
      'America/Denver',
      'America/Los_Angeles',
      'America/Toronto',
      'America/Vancouver',
      'Europe/London',
      'Europe/Paris',
      'Europe/Berlin',
      'Europe/Rome',
      'Europe/Madrid',
      'Europe/Amsterdam',
      'Europe/Zurich',
      'Europe/Stockholm',
      'Europe/Moscow',
      'Asia/Tokyo',
      'Asia/Seoul',
      'Asia/Shanghai',
      'Asia/Hong_Kong',
      'Asia/Singapore',
      'Asia/Bangkok',
      'Asia/Kolkata',
      'Asia/Dubai',
      'Australia/Sydney',
      'Australia/Melbourne',
      'Australia/Perth',
      'Pacific/Auckland',
      'America/Sao_Paulo',
      'America/Mexico_City',
      'Africa/Cairo',
      'Africa/Johannesburg',
      'Asia/Manila',
      'Asia/Jakarta',
      'Asia/Karachi',
      'America/Argentina/Buenos_Aires',
    ];

    return commonTimezones
        .map((id) => _createTimezoneData(id))
        .where((data) => data != null)
        .cast<TimezoneData>()
        .toList()
      ..sort((a, b) => a.offsetInMinutes.compareTo(b.offsetInMinutes));
  }

  static List<TimezoneData> getAllTimezones() {
    return tz.timeZoneDatabase.locations.keys
        .map((id) => _createTimezoneData(id))
        .where((data) => data != null)
        .cast<TimezoneData>()
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  static TimezoneData? _createTimezoneData(String id) {
    try {
      final location = tz.getLocation(id);
      final now = tz.TZDateTime.now(location);
      final offsetInMinutes = now.timeZoneOffset.inMinutes;
      final formattedOffset = _formatOffset(offsetInMinutes);
      final displayName = _formatDisplayName(id, formattedOffset);

      return TimezoneData(
        id: id,
        displayName: displayName,
        formattedOffset: formattedOffset,
        offsetInMinutes: offsetInMinutes,
      );
    } catch (e) {
      return null;
    }
  }

  static String _formatOffset(int offsetInMinutes) {
    final hours = offsetInMinutes ~/ 60;
    final minutes = offsetInMinutes % 60;
    final sign = offsetInMinutes >= 0 ? '+' : '-';
    return 'UTC$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.abs().toString().padLeft(2, '0')}';
  }

  static String _formatDisplayName(String id, String offset) {
    final parts = id.split('/');
    String cityName = parts.last.replaceAll('_', ' ');
    
    if (parts.length > 2) {
      final region = parts[parts.length - 2];
      cityName = '$cityName, $region';
    }
    
    return '$cityName ($offset)';
  }

  static String getDeviceTimezone() {
    try {
      final deviceTimezone = DateTime.now().timeZoneName;
      return deviceTimezone.isEmpty ? 'UTC' : deviceTimezone;
    } catch (e) {
      return 'UTC';
    }
  }

  static String getDeviceTimezoneId() {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        return tz.local.name;
      }
      return 'UTC';
    } catch (e) {
      return 'UTC';
    }
  }

  // Debug method to test timezone conversion
  static String debugConversion(TimeOfDay localTime, String localTimezoneId, String targetTimezoneId) {
    try {
      final now = DateTime.now();
      final localLocation = tz.getLocation(localTimezoneId);
      final targetLocation = tz.getLocation(targetTimezoneId);
      
      final localDateTime = tz.TZDateTime(
        localLocation,
        now.year,
        now.month,
        now.day,
        localTime.hour,
        localTime.minute,
      );
      
      final targetDateTime = tz.TZDateTime.from(localDateTime, targetLocation);
      
      return 'Local: ${localDateTime.toString()} -> Target: ${targetDateTime.toString()}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  static tz.TZDateTime convertTimeToTimezone(
    TimeOfDay time,
    DateTime date,
    String timezoneId,
  ) {
    try {
      final location = tz.getLocation(timezoneId);
      return tz.TZDateTime(
        location,
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    } catch (e) {
      return tz.TZDateTime.now(tz.local);
    }
  }

  static tz.TZDateTime convertBetweenTimezones(
    tz.TZDateTime dateTime,
    String targetTimezoneId,
  ) {
    try {
      final targetLocation = tz.getLocation(targetTimezoneId);
      return tz.TZDateTime.from(dateTime, targetLocation);
    } catch (e) {
      return dateTime;
    }
  }

  static TimeOfDay tzDateTimeToTimeOfDay(tz.TZDateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static int calculateTimezoneOffset(String timezoneId) {
    try {
      final location = tz.getLocation(timezoneId);
      final now = tz.TZDateTime.now(location);
      return now.timeZoneOffset.inMinutes;
    } catch (e) {
      return 0;
    }
  }

  static Duration getTimeDifference(String timezone1, String timezone2) {
    try {
      final location1 = tz.getLocation(timezone1);
      final location2 = tz.getLocation(timezone2);
      final now = DateTime.now();
      final time1 = tz.TZDateTime.from(now, location1);
      final time2 = tz.TZDateTime.from(now, location2);
      return time1.difference(time2);
    } catch (e) {
      return Duration.zero;
    }
  }

  static String formatTimezoneAwareTime(
    TimeOfDay time,
    String timezoneId, {
    bool use24HourFormat = false,
  }) {
    try {
      final location = tz.getLocation(timezoneId);
      final now = DateTime.now();
      final tzDateTime = tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (use24HourFormat) {
        return DateFormat('HH:mm').format(tzDateTime);
      } else {
        return DateFormat('h:mm a').format(tzDateTime);
      }
    } catch (e) {
      if (use24HourFormat) {
        final hourStr = time.hour.toString().padLeft(2, '0');
        final minuteStr = time.minute.toString().padLeft(2, '0');
        return '$hourStr:$minuteStr';
      } else {
        final hourStr = time.hour.toString().padLeft(2, '0');
        final minuteStr = time.minute.toString().padLeft(2, '0');
        final formattedTime = '$hourStr:$minuteStr';
        return time.hour < 12 ? '$formattedTime AM' : '$formattedTime PM';
      }
    }
  }

  static String getTimezoneAbbreviation(String timezoneId) {
    try {
      final location = tz.getLocation(timezoneId);
      final now = tz.TZDateTime.now(location);
      return now.timeZoneName;
    } catch (e) {
      return timezoneId.split('/').last.replaceAll('_', ' ');
    }
  }

  static bool isDaylightSavingTime(String timezoneId) {
    try {
      final location = tz.getLocation(timezoneId);
      final now = tz.TZDateTime.now(location);
      final winter = tz.TZDateTime(location, now.year, 1, 1);
      return now.timeZoneOffset != winter.timeZoneOffset;
    } catch (e) {
      return false;
    }
  }

  static List<TimezoneData> searchTimezones(String query) {
    if (query.isEmpty) return getCommonTimezones();

    final allTimezones = getAllTimezones();
    final queryLower = query.toLowerCase();

    return allTimezones
        .where((timezone) =>
            timezone.displayName.toLowerCase().contains(queryLower) ||
            timezone.id.toLowerCase().contains(queryLower) ||
            timezone.formattedOffset.contains(query))
        .toList();
  }

  static DateTime? getNextAlarmTime(
    TimeOfDay alarmTime,
    List<bool> selectedDays,
    String timezoneId,
  ) {
    try {
      final location = tz.getLocation(timezoneId);
      final now = tz.TZDateTime.now(location);
      
      DateTime nextAlarm = DateTime(
        now.year,
        now.month,
        now.day,
        alarmTime.hour,
        alarmTime.minute,
      );

      if (selectedDays.any((day) => day)) {
        for (int i = 0; i < 7; i++) {
          final candidateAlarm = nextAlarm.add(Duration(days: i));
          final dayOfWeek = (candidateAlarm.weekday - 1) % 7;
          
          if (selectedDays[dayOfWeek]) {
            if (i == 0) {
              if (candidateAlarm.isAfter(now.toLocal())) {
                return candidateAlarm;
              }
            } else {
              return candidateAlarm;
            }
          }
        }
      } else {
        if (nextAlarm.isAfter(now.toLocal())) {
          return nextAlarm;
        } else {
          return nextAlarm.add(const Duration(days: 1));
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static String formatAlarmTime(
    TimeOfDay time,
    String timezoneId,
    String deviceTimezoneId,
  ) {
    try {
      final targetLocation = tz.getLocation(timezoneId);
      final deviceLocation = tz.getLocation(deviceTimezoneId);
      
      final now = DateTime.now();
      final targetTime = tz.TZDateTime(
        targetLocation,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      
      final deviceTime = tz.TZDateTime.from(targetTime, deviceLocation);

      final targetFormatted = DateFormat('h:mm a').format(targetTime);
      final deviceFormatted = DateFormat('h:mm a').format(deviceTime);

      if (timezoneId == deviceTimezoneId) {
        return targetFormatted;
      }

      final targetAbbr = getTimezoneAbbreviation(timezoneId);
      final deviceAbbr = getTimezoneAbbreviation(deviceTimezoneId);

      return '$targetFormatted $targetAbbr ' +
          '(Local: $deviceFormatted $deviceAbbr)';
    } catch (e) {
      final hourStr = time.hour.toString().padLeft(2, '0');
      final minuteStr = time.minute.toString().padLeft(2, '0');
      final formattedTime = '$hourStr:$minuteStr';
      return time.hour < 12 ? '$formattedTime AM' : '$formattedTime PM';
    }
  }
}