import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

class Utils {
  static String timeOfDayToString(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  static TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static DateTime timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  static int timeOfDayToInt(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

// Adding an extra day since this function is used for scheduling service
  static int getMillisecondsToAlarm(DateTime now, DateTime alarmTime) {
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    int milliseconds = alarmTime.difference(now).inMilliseconds;
    return milliseconds - 1000;
  }

  static List<String> convertTo12HourFormat(String time) {
    int hour = int.parse(time.substring(0, 2));
    String minute = time.substring(3);
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) {
      hour = 12;
    }

    return ['$hour:$minute', period];
  }

  static String getFormattedDate(DateTime now) {
    final formattedDate = DateFormat("EEE, MMMM d").format(now);
    int day = now.day;
    String daySuffix = "";
    if (day >= 11 && day <= 13) {
      daySuffix = "th";
    }
    switch (day % 10) {
      case 1:
        daySuffix = "st";
        break;
      case 2:
        daySuffix = "nd";
        break;
      case 3:
        daySuffix = "rd";
        break;
      default:
        daySuffix = "th";
    }

    return "$formattedDate$daySuffix";
  }

  static GeoPoint latLngToGeoPoint(LatLng latLng) {
    return GeoPoint(latLng.latitude, latLng.longitude);
  }

  static LatLng geoPointToLatLng(GeoPoint geoPoint) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  static String geoPointToString(GeoPoint geoPoint) {
    return '${geoPoint.latitude},${geoPoint.longitude}';
  }

  static LatLng stringToLatLng(String loc) {
    List<String> latLng = loc.split(',');
    return LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
  }

  static GeoPoint stringToGeoPoint(String string) {
    List<String> latLng = string.split(',');
    return GeoPoint(double.parse(latLng[0]), double.parse(latLng[1]));
  }

  static bool isWithinRadius(LatLng source, LatLng destination, double radius) {
    var R = 6371e3;
    var dLat = deg2rad(destination.latitude - source.latitude);
    var dLon = deg2rad(destination.longitude - source.longitude);
    var lat1 = deg2rad(source.latitude);
    var lat2 = deg2rad(destination.latitude);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    var d = R * c;

    return d <= radius;
  }

  static double deg2rad(deg) {
    return deg * (pi / 180);
  }

  static String timeUntilAlarm(TimeOfDay alarmTime) {
    final now = DateTime.now();
    final todayAlarm = DateTime(
        now.year, now.month, now.day, alarmTime.hour, alarmTime.minute);
    final tomorrowAlarm = DateTime(
        now.year, now.month, now.day + 1, alarmTime.hour, alarmTime.minute);

    Duration duration;

    if (now.isBefore(todayAlarm)) {
      duration = todayAlarm.difference(now);
    } else {
      duration = tomorrowAlarm.difference(now);
    }

    if (duration.inMinutes <= 1) {
      return 'less than 1 minute';
    } else if (duration.inDays == 1) {
      return '1 day';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (hours == 0) {
        return '$minutes minutes';
      } else if (minutes == 0) {
        return '$hours hours';
      } else {
        return '$hours hours $minutes minutes';
      }
    }
  }

  static String getRepeatDays(List<bool> days) {
    const dayAbbreviations = ['M', 'T', 'W', 'Th', 'F', 'Sa', 'Su'];
    int weekdayCount = 0;
    int weekendCount = 0;
    List<String> selectedDays = [];

    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
        if (i < 5) {
          weekdayCount++;
        } else {
          weekendCount++;
        }
        selectedDays.add(dayAbbreviations[i]);
      }
    }

    if (weekdayCount + weekendCount == 7) {
      return 'Everyday';
    } else if (weekdayCount == 5 && weekendCount == 0) {
      return 'Weekdays';
    } else if (weekendCount == 2 && weekdayCount == 0) {
      return 'Weekends';
    } else if (selectedDays.isEmpty) {
      return 'Never';
    } else {
      return selectedDays.join(',');
    }
  }

  static AlarmModel getFirstScheduledAlarm(
      AlarmModel alarm1, AlarmModel alarm2) {
    // Compare the isEnabled property for each alarm
    if (alarm1.isEnabled != alarm2.isEnabled) {
      return alarm1.isEnabled ? alarm1 : alarm2;
    }

    // Get the current time
    final now = DateTime.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;
    final currentDay = now.weekday - 1; // Monday is 0

    // Calculate the time until the next occurrence of each alarm
    num timeUntilNextOccurrence(AlarmModel alarm) {
      // Check if the alarm can never repeat
      if (alarm.days.every((day) => !day)) {
        int timeUntilNextAlarm =
            alarm.minutesSinceMidnight - currentTimeInMinutes;
        return timeUntilNextAlarm < 0 ? double.infinity : timeUntilNextAlarm;
      }

      // Check if the alarm repeats every day
      if (alarm.days.every((day) => day)) {
        int timeUntilNextAlarm =
            alarm.minutesSinceMidnight - currentTimeInMinutes;
        return timeUntilNextAlarm < 0
            ? timeUntilNextAlarm + 24 * 60
            : timeUntilNextAlarm;
      }

      // Calculate the time until the next occurrence for repeatable alarms
      int dayDifference =
          alarm.days.indexWhere((day) => day, currentDay) - currentDay;
      if (dayDifference < 0) {
        dayDifference += 7;
      }
      int timeUntilNextDay = dayDifference * 24 * 60;
      int timeUntilNextAlarm =
          alarm.minutesSinceMidnight - currentTimeInMinutes;
      if (timeUntilNextAlarm < 0) {
        timeUntilNextAlarm += 24 * 60;
        timeUntilNextDay += 24 * 60;
      }
      return timeUntilNextDay + timeUntilNextAlarm;
    }

    // Compare the time until the next occurrence for each alarm
    return timeUntilNextOccurrence(alarm1) < timeUntilNextOccurrence(alarm2)
        ? alarm1
        : alarm2;
  }
}
