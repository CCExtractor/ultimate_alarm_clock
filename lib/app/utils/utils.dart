import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'package:telephony/telephony.dart';

import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/quote_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/quote_list.dart';

import '../data/models/profile_model.dart';
import '../data/providers/get_storage_provider.dart';
import 'constants.dart';

class Utils {
  static String timeOfDayToString(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  static final storage = Get.find<GetStorageProvider>();

  static AlarmModel alarmModelInit = AlarmModel(
    volMax: 1.0,
    volMin: 0.0,
    snoozeDuration: 0,
    gradient: 1,
    label: '',
    isOneTime: true,
    deleteAfterGoesOff: false,
    offsetDetails: {},
    lastEditedUserId: '',
    mutexLock: false,
    ownerName: '',
    ownerId: '',
    activityInterval: 0,
    isMathsEnabled: false,
    numMathsQuestions: 0,
    mathsDifficulty: 0,
    qrValue: '',
    isQrEnabled: false,
    isShakeEnabled: false,
    shakeTimes: 0,
    isPedometerEnabled: false,
    numberOfSteps: 0,
    days: [false, false, false, false, false, false, false],
    weatherTypes: [],
    isWeatherEnabled: false,
    isEnabled: false,
    isActivityEnabled: false,
    isLocationEnabled: false,
    isSharedAlarmEnabled: false,
    intervalToAlarm: 0,
    location: '0.0,0.0',
    minutesSinceMidnight: Utils.timeOfDayToInt(TimeOfDay.now()),
    ringtoneName: 'Digital Alarm 1',
    note: '',
    showMotivationalQuote: false,
    activityMonitor: 0,
    profile: 'Default',
    alarmDate: DateTime.now().toString().substring(0, 11),
    alarmTime: '',
    alarmID: '',
    mainAlarmTime: '',
    isGuardian: false,
    guardianTimer: 0,
    guardian: '',
    isCall: false,
    ringOn: false,
  );

  static String formatDateTimeToHHMMSS(DateTime dateTime) {
    // Extract hours, minutes, and seconds from the DateTime
    int hours = dateTime.hour;
    int minutes = dateTime.minute;
    int seconds = dateTime.second;

    // Format each component to have two digits
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    // Concatenate the components with ':' separator
    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }

  static TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static DateTime stringToDate(String date){
    final parts = date.split('-');
    final day = int.parse(parts[2]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[0]);
    return DateTime(year,month,day);
  }

  static DateTime? stringToDateTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 3) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);

        // Create a DateTime object with today's date and the provided time
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, hours, minutes, seconds);
      }
    } catch (e) {
      // Handle parsing errors if any
      debugPrint(e.toString());
    }

    // Return null or some default value in case of an error
    return null;
  }

  static DateTime timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  static int timeOfDayToInt(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  static DateTime calculateOffsetAlarmTime(
    DateTime eventTime,
    bool isOffsetBefore,
    int offsetDuration,
  ) {
    if (isOffsetBefore) {
      return eventTime.subtract(Duration(minutes: offsetDuration));
    } else {
      return eventTime.add(Duration(minutes: offsetDuration));
    }
  }

// Adding an extra day since this function is used for scheduling service
  static int getMillisecondsToTimer(DateTime now, DateTime timerTime) {
    int milliseconds = timerTime.difference(now).inMilliseconds;
    return milliseconds;
  }

  static int getMillisecondsToAlarm(DateTime now, DateTime alarmTime) {
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    int milliseconds = alarmTime.difference(now).inMilliseconds;
    return milliseconds;
  }

  static String formatMilliseconds(int milliseconds) {
    final Duration duration = Duration(milliseconds: milliseconds);
    final int seconds = duration.inSeconds;
    final int minutes = duration.inMinutes;
    final int hours = duration.inHours;

    if (seconds < 10) {
      return '$seconds';
    } else if (seconds < 60) {
      return '$seconds';
    } else if (minutes < 10) {
      return "$minutes:${seconds % 60 < 10 ? '0' : ''}${seconds % 60}";
    } else if (minutes < 60) {
      return "$minutes:${seconds % 60 < 10 ? '0' : ''}${seconds % 60}";
    } else if (hours < 10) {
      return "$hours:${minutes % 60 < 10 ? '0' : ''}${minutes % 60}:${seconds % 60 < 10 ? '0' : ''}${seconds % 60}";
    } else {
      return "$hours:${minutes % 60 < 10 ? '0' : ''}${minutes % 60}:${seconds % 60 < 10 ? '0' : ''}${seconds % 60}";
    }
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

  static List<String> split24HourFormat(String time) {
    String hour = time.substring(0, 2);
    String minute = time.substring(3);
    return ['$hour:$minute', ''];
  }

  static String getFormattedDate(DateTime now) {
    final formattedDate = DateFormat('EEE, MMMM d').format(now);
    int day = now.day;
    String daySuffix = '';
    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    }
    switch (day % 10) {
      case 1:
        daySuffix = 'st';
        break;
      case 2:
        daySuffix = 'nd';
        break;
      case 3:
        daySuffix = 'rd';
        break;
      default:
        daySuffix = 'th';
    }

    return '$formattedDate$daySuffix';
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
      now.year,
      now.month,
      now.day,
      alarmTime.hour,
      alarmTime.minute,
    );

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
            nextAlarm = DateTime(
              now.year,
              now.month,
              now.day + i,
              alarmTime.hour,
              alarmTime.minute,
            );
          }
        }
      }

      if (nextAlarm != null) {
        duration = nextAlarm.difference(now);
      } else {
        return 'No upcoming alarms';
      }
    }

    if (duration.inMinutes < 1) {
      return 'less than 1 minute';
    } else if (duration.inHours < 24) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (hours == 0) {
        return minutes == 1 ? '$minutes minute' : '$minutes minutes';
      } else if (minutes == 0) {
        return hours == 1 ? '$hours hour' : '$hours hours';
      } else if (hours == 1) {
        return minutes == 1
            ? '$hours hour $minutes minute'
            : '$hours hour $minutes minutes';
      } else {
        return '$hours hour $minutes minutes';
      }
    } else if (duration.inDays == 1) {
      return '1 day';
    } else {
      return '${duration.inDays} days';
    }
  }

  static String getRepeatDays(List<bool> days) {
    List dayAbbreviations = [
      'Mon'.tr,
      'Tue'.tr,
      'Wed'.tr,
      'Thur'.tr,
      'Fri'.tr,
      'Sat'.tr,
      'Sun'.tr,
    ];
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
      return 'Everyday'.tr;
    } else if (weekdayCount == 5 && weekendCount == 0) {
      return 'Weekdays'.tr;
    } else if (weekendCount == 2 && weekdayCount == 0) {
      return 'Weekends'.tr;
    } else if (selectedDays.isEmpty) {
      return 'Never'.tr;
    } else {
      return selectedDays.join(', ');
    }
  }

  static AlarmModel getFirstScheduledAlarm(
    AlarmModel alarm1,
    AlarmModel alarm2,
  ) {
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
  static Future<TimerModel> genFakeTimerModel() async {
    return TimerModel(
      timerValue: 0,
      timeElapsed: 0,
      startedOn: '',
      ringtoneName: '',
      timerName: '',
    );
  }

  static ProfileModel genDefaultProfileModel() {
    return ProfileModel(
      volMax: 1.0,
      volMin: 0.0,
      snoozeDuration: 0,
      gradient: 1,
      label: '',
      isOneTime: true,
      deleteAfterGoesOff: false,
      offsetDetails: {},
      lastEditedUserId: '',
      mutexLock: false,
      ownerName: '',
      ownerId: '',
      activityInterval: 0,
      isMathsEnabled: false,
      numMathsQuestions: 0,
      mathsDifficulty: 0,
      qrValue: '',
      isQrEnabled: false,
      isShakeEnabled: false,
      shakeTimes: 0,
      isPedometerEnabled: false,
      numberOfSteps: 0,
      days: [false, false, false, false, false, false, false],
      weatherTypes: [],
      isWeatherEnabled: false,
      isEnabled: false,
      isActivityEnabled: false,
      isLocationEnabled: false,
      isSharedAlarmEnabled: false,
      intervalToAlarm: 0,
      location: '0.0,0.0',
      minutesSinceMidnight: Utils.timeOfDayToInt(TimeOfDay.now()),
      ringtoneName: 'Digital Alarm 1',
      note: '',
      showMotivationalQuote: false,
      activityMonitor: 0,
      profileName: 'Default',
      alarmDate: DateTime.now().toString().substring(0, 11),
      isGuardian: false,
      guardianTimer: 0,
      guardian: '',
      isCall: false,
      ringOn: false,
    );
  }

  static String getFormattedWeatherTypes(List weatherTypes) {
    if (weatherTypes.isEmpty) {
      return 'Off';
    }

    const allWeatherTypes = WeatherTypes.values;
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

  static Difficulty getDifficulty(double value) {
    if (value <= 0.33) {
      return Difficulty.Easy;
    } else if (value <= 1.33) {
      return Difficulty.Medium;
    } else {
      return Difficulty.Hard;
    }
  }

  static String getDifficultyLabel(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.Easy:
        return 'Easy';
      case Difficulty.Medium:
        return 'Medium';
      case Difficulty.Hard:
        return 'Hard';
      default:
        return '';
    }
  }

  static List generateMathProblem(Difficulty difficulty) {
    Random random = Random();
    int operand1, operand2, operand3 = 0;
    String operator;

    switch (difficulty) {
      case Difficulty.Easy:
        operand1 = random.nextInt(90) + 10;
        operand2 = random.nextInt(90) + 10;
        operator = '+';
        break;

      case Difficulty.Medium:
        operand1 = random.nextInt(90) + 10;
        operand2 = random.nextInt(90) + 10;
        operand3 = random.nextInt(90) + 10;
        operator = '+';
        break;

      case Difficulty.Hard:
        operand1 = random.nextInt(90) + 10;
        operand2 = random.nextInt(9) + 1;
        operand3 = random.nextInt(90) + 10;
        operator = '*';
        break;
    }

    String expression;
    int result;

    if (difficulty == Difficulty.Hard) {
      expression = '($operand1$operator$operand2)+$operand3 = ?';
      result = (operand1 * operand2) + operand3;
    } else if (difficulty == Difficulty.Easy) {
      expression = '$operand1 $operator $operand2 = ?';
      result = (operator == '+') ? operand1 + operand2 : operand1 * operand2;
    } else {
      expression = '$operand1 $operator $operand2 $operator $operand3 = ?';
      result = (operator == '+')
          ? operand1 + operand2 + operand3
          : operand1 * operand2 * operand3;
    }

    return [expression, result];
  }

  static bool isCurrentDayinList(List<bool> daysOfWeek) {
    // Get the current day of the week (0 for Monday, 1 for Tuesday, etc.)
    int currentDay = DateTime.now().weekday - 1;
    if (daysOfWeek[currentDay]) {
      return true;
    }
    // Check if all values in the list are false (one time alarm)
    bool allFalse = daysOfWeek.every((day) => day == false);
    if (allFalse) {
      return true;
    }
    return false;
  }

  static bool isChallengeEnabled(AlarmModel alarmRecord) {
    if (alarmRecord.isMathsEnabled ||
        alarmRecord.isQrEnabled ||
        alarmRecord.isShakeEnabled ||
        alarmRecord.isPedometerEnabled) {
      return true;
    }
    return false;
  }

  static bool isAutoDismissalEnabled(AlarmModel alarmRecord) {
    if (alarmRecord.isWeatherEnabled ||
        alarmRecord.isActivityEnabled ||
        alarmRecord.isLocationEnabled) {
      return true;
    }
    return false;
  }

  static void hapticFeedback() async {
    bool hapticFeedbackValue = await SecureStorageProvider()
        .readHapticFeedbackValue(key: 'haptic_feedback');

    if (hapticFeedbackValue) {
      // Trigger haptic feedback if it's enabled in settings
      SystemChannels.platform.invokeMethod<void>(
        'HapticFeedback.vibrate',
        'HapticFeedbackType.selectionClick',
      );
    }
  }

  static BoxDecoration getCustomTileBoxDecoration({required bool isLightMode}) {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(18),
      ),
      color: isLightMode
          ? kLightSecondaryBackgroundColor
          : ksecondaryBackgroundColor,
    );
  }

  static void showModal({
    required BuildContext context,
    required String title,
    required String description,
    required IconData iconData,
    required bool isLightMode,
  }) {
    Utils.hapticFeedback();
    showModalBottomSheet(
      context: context,
      backgroundColor: isLightMode
          ? kLightSecondaryBackgroundColor
          : ksecondaryBackgroundColor,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  iconData,
                  color:
                      isLightMode ? kLightPrimaryTextColor : kprimaryTextColor,
                  size: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  title.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    description.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        kprimaryColor,
                      ),
                    ),
                    onPressed: () {
                      Utils.hapticFeedback();
                      Get.back();
                    },
                    child: Text(
                      'Understood'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: isLightMode
                                ? kLightPrimaryTextColor
                                : ksecondaryTextColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Quote getRandomQuote() {
    try {
      int randomIndex = Random.secure().nextInt(quoteList.length);
      return Quote.fromMap(quoteList[randomIndex]);
    } catch (e) {
      debugPrint(e.toString());
      return Quote(
        quote: 'The only way to do great work is to love what you do.',
        author: 'Steve Jobs',
      );
    }
  }

  static int calculateTimeDifference(DateTime targetDateTime) {
    targetDateTime = targetDateTime.toLocal();
    var currentTime = DateTime.now();
    currentTime = currentTime.subtract(
      Duration(
        milliseconds: currentTime.millisecond,
        microseconds: currentTime.microsecond,
      ),
    );
    final difference = targetDateTime.difference(currentTime);
    final milliseconds = difference.inHours * 60 * 60 * 1000 +
        difference.inMinutes * 60 * 1000 +
        difference.inSeconds * 1000;
    return milliseconds;
  }

  static int getDifferenceMillisFromNow(
    String datetimeString,
    int milliseconds,
  ) {
    try {
      final providedDatetime = DateTime.parse(datetimeString);
      final updatedDatetime =
          providedDatetime.add(Duration(milliseconds: milliseconds));
      final currentDatetime = DateTime.now();
      final difference = updatedDatetime.difference(currentDatetime);
      return difference.inMilliseconds;
    } catch (e) {
      return 0;
    }
  }

  static String formatDateTimeToStandard(DateTime dateTime) {
    dateTime = dateTime.toLocal();
    final formattedDate =
        '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
    final formattedTime =
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
    return '$formattedDate ($formattedTime)';
  }

  static dialNumber(String phoneNo) async {
    await Permission.phone.isDenied.then((value) async {
      if (value) {
        Permission.phone.request();
      } else {
        AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.CALL',
          data: 'tel:$phoneNo',
        );
        await intent.launch();
      }
    });
  }

  static spotifyPlay(String url) async {
    AndroidIntent intent = const AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'spotify:track:3Pzh926pXggbMe2ZpXyMV7',
    );
    await intent.launch();
  }

  static sendSMS(String phoneNo, String text) async {
    final Telephony telephony = Telephony.instance;
    await telephony.requestPhoneAndSmsPermissions.then((value) {
      if (value == true) {
        telephony.sendSms(to: phoneNo, message: text);
      }
    });
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  static String getInitials(String username) {
    // Split the username into parts
    List<String> parts = username.split(' ');

    // Get the first two letters of the first name
    String firstNameInitials = parts[0].substring(0, 1);

    // Check if there is a last name
    if (parts.length > 1) {
      // Get the first two letters of the last name
      String lastNameInitials = parts[1].substring(0, 1);
      return firstNameInitials + lastNameInitials;
    } else {
      // Return only the first two letters of the first name
      return parts[0].substring(0, 2);
    }
  }
  static double getFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 360 ? 14 : 30;
  }
}
