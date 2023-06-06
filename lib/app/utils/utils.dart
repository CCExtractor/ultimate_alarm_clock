import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

import 'constants.dart';

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

  static String timeUntilAlarm(TimeOfDay alarmTime, List<bool> days) {
    final now = DateTime.now();
    final todayAlarm = DateTime(
        now.year, now.month, now.day, alarmTime.hour, alarmTime.minute);

    Duration duration;

    // Check if the alarm is a one-time alarm
    if (days.every((day) => !day)) {
      if (now.isBefore(todayAlarm)) {
        duration = todayAlarm.difference(now);
      } else {
        // Schedule the alarm for the next day
        final nextAlarm = todayAlarm.add(const Duration(days: 1));
        duration = nextAlarm.difference(now);
      }
    } else if (now.isBefore(todayAlarm) && days[now.weekday - 1]) {
      duration = todayAlarm.difference(now);
    } else {
      int daysUntilNextAlarm = 7;
      DateTime? nextAlarm;

      for (int i = 1; i <= 7; i++) {
        int nextDayIndex = (now.weekday + i - 1) % 7;

        if (days[nextDayIndex]) {
          if (i < daysUntilNextAlarm) {
            daysUntilNextAlarm = i;
            nextAlarm = DateTime(now.year, now.month, now.day + i,
                alarmTime.hour, alarmTime.minute);
          }
        }
      }

      if (nextAlarm != null) {
        duration = nextAlarm.difference(now);
      } else {
        return 'No upcoming alarms';
      }
    }

    if (duration.inMinutes <= 1) {
      return 'less than 1 minute';
    } else if (duration.inHours < 24) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (hours == 0) {
        return '$minutes minutes';
      } else if (minutes == 0) {
        return '$hours hours';
      } else {
        return '$hours hours $minutes minutes';
      }
    } else if (duration.inDays == 1) {
      return '1 day';
    } else {
      return '${duration.inDays} days';
    }
  }

  static String getRepeatDays(List<bool> days) {
    const dayAbbreviations = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
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
      return selectedDays.join(', ');
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

    num timeUntilNextOccurrence(AlarmModel alarm) {
      // Check if the alarm is a one-time alarm
      if (alarm.days.every((day) => !day)) {
        int timeUntilNextAlarm =
            alarm.minutesSinceMidnight - currentTimeInMinutes;
        if (timeUntilNextAlarm < 0) {
          // Schedule the alarm for the next day
          timeUntilNextAlarm += 24 * 60;
        }
        return timeUntilNextAlarm;
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

  // Utility function to create a dummy model to pass to functions
  static AlarmModel genFakeAlarmModel() {
    return AlarmModel(
        days: [false, false, false, false, false, false, false],
        weatherTypes: [],
        isWeatherEnabled: false,
        isEnabled: false,
        isActivityEnabled: false,
        isLocationEnabled: false,
        isSharedAlarmEnabled: false,
        intervalToAlarm: 0,
        location: '',
        alarmTime: Utils.timeOfDayToString(TimeOfDay.now()),
        minutesSinceMidnight: Utils.timeOfDayToInt(TimeOfDay.now()));
  }

  static storeApiKey(ApiKeys key, String val) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: key.toString(), value: val);
  }

  static retrieveApiKey(ApiKeys key) async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: key.toString());
  }

  static String getFormattedWeatherTypes(List weatherTypes) {
    if (weatherTypes.isEmpty) {
      return 'Off';
    }

    final allWeatherTypes = WeatherTypes.values;
    final hasAllTypes =
        allWeatherTypes.every((type) => weatherTypes.contains(type));

    if (hasAllTypes) {
      return 'All';
    }

    final formattedTypes = weatherTypes
        .map((type) => type.toString().split('.').last)
        .map((type) => type[0].toUpperCase() + type.substring(1))
        .toList();

    return formattedTypes.join(', ');
  }

  static List<int> getIntFromWeatherTypes(List<WeatherTypes> weatherTypes) {
    return weatherTypes.map((type) => type.index).toList();
  }

  static List<WeatherTypes> getWeatherTypesFromInt(List<int> positions) {
    return positions.map((position) => WeatherTypes.values[position]).toList();
  }
}
