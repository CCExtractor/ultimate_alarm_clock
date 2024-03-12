import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class IsarDb {
  static final IsarDb _instance = IsarDb._internal();
  late Future<Isar> db;

  factory IsarDb() {
    return _instance;
  }

  IsarDb._internal() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [AlarmModelSchema, RingtoneModelSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  static Future<AlarmModel> addAlarm(AlarmModel alarmRecord) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.alarmModels.put(alarmRecord);
    });
    return alarmRecord;
  }

  static Future<AlarmModel> getTriggeredAlarm(String time) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final alarms = await db.alarmModels
        .where()
        .filter()
        .isEnabledEqualTo(true)
        .and()
        .alarmTimeEqualTo(time)
        .findAll();
    return alarms.first;
  }

  static Future<bool> doesAlarmExist(String alarmID) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final alarms = await db.alarmModels.where().filter().alarmIDEqualTo(alarmID).findAll();

    return alarms.isNotEmpty;
  }

  static Future<AlarmModel> getLatestAlarm(
    AlarmModel alarmRecord,
    bool wantNextAlarm,
  ) async {
    int nowInMinutes = 0;
    final isarProvider = IsarDb();
    final db = await isarProvider.db;

// Increasing a day since we need alarms AFTER the current time
// Logically, alarms at current time will ring in the future ;-;
    if (wantNextAlarm == true) {
      nowInMinutes = Utils.timeOfDayToInt(
        TimeOfDay(
          hour: TimeOfDay.now().hour,
          minute: TimeOfDay.now().minute + 1,
        ),
      );
    } else {
      nowInMinutes = Utils.timeOfDayToInt(
        TimeOfDay(
          hour: TimeOfDay.now().hour,
          minute: TimeOfDay.now().minute,
        ),
      );
    }

    // Get all enabled alarms
    List<AlarmModel> alarms =
        await db.alarmModels.where().filter().isEnabledEqualTo(true).findAll();

    if (alarms.isEmpty) {
      alarmRecord.minutesSinceMidnight = -1;
      return alarmRecord;
    } else {
      // Get the closest alarm to the current time
      AlarmModel closestAlarm = alarms.reduce((a, b) {
        int aTimeUntilNextAlarm = a.minutesSinceMidnight - nowInMinutes;
        int bTimeUntilNextAlarm = b.minutesSinceMidnight - nowInMinutes;

        // Check if alarm repeats on any day
        bool aRepeats = a.days.any((day) => day);
        bool bRepeats = b.days.any((day) => day);

        // If alarm is one-time and has already passed or is happening now,
        // set time until next alarm to next day
        if (!aRepeats && aTimeUntilNextAlarm < 0 && !a.isTimer) {
          aTimeUntilNextAlarm += Duration.minutesPerDay;
        }
        if (!bRepeats && bTimeUntilNextAlarm < 0 && !b.isTimer) {
          bTimeUntilNextAlarm += Duration.minutesPerDay;
        }

        // If alarm repeats on any day, find the next upcoming day
        if (aRepeats) {
          int currentDay = DateTime.now().weekday - 1;
          for (int i = 0; i < a.days.length; i++) {
            int dayIndex = (currentDay + i) % a.days.length;
            if (a.days[dayIndex]) {
              aTimeUntilNextAlarm += i * Duration.minutesPerDay;
              break;
            }
          }
        }

        if (bRepeats) {
          int currentDay = DateTime.now().weekday - 1;
          for (int i = 0; i < b.days.length; i++) {
            int dayIndex = (currentDay + i) % b.days.length;
            if (b.days[dayIndex]) {
              bTimeUntilNextAlarm += i * Duration.minutesPerDay;
              break;
            }
          }
        }

        return aTimeUntilNextAlarm < bTimeUntilNextAlarm ? a : b;
      });
      return closestAlarm;
    }
  }

  static Future<void> updateAlarm(AlarmModel alarmRecord) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.alarmModels.put(alarmRecord);
    });
  }

  static Future<AlarmModel?> getAlarm(int id) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    return db.alarmModels.get(id);
  }

  static getAlarms() async* {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;
      yield* db.alarmModels.where().watch(fireImmediately: true);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<void> deleteAlarm(int id) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;

    await db.writeTxn(() async {
      await db.alarmModels.delete(id);
    });
  }

  static Future<void> addCustomRingtone(
    RingtoneModel customRingtone,
  ) async {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;
      await db.writeTxn(() async {
        await db.ringtoneModels.put(customRingtone);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<RingtoneModel?> getCustomRingtone({
    required int customRingtoneId,
  }) async {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;
      final query = db.ringtoneModels.where().filter().isarIdEqualTo(customRingtoneId).findFirst();

      return query;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<List<RingtoneModel>> getAllCustomRingtones() async {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;

      final query = db.ringtoneModels.where().findAll();

      return query;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<void> deleteCustomRingtone({
    required int ringtoneId,
  }) async {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;

      await db.writeTxn(() async {
        await db.ringtoneModels.delete(ringtoneId);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
