import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
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
      return await Isar.open([AlarmModelSchema],
          directory: dir.path, inspector: true);
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

  static Future<AlarmModel> getLatestAlarm(AlarmModel alarmRecord) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    int nowInMinutes = Utils.timeOfDayToInt(TimeOfDay.now());
    late List<AlarmModel> alarms;

    if (alarmRecord.minutesSinceMidnight >= nowInMinutes) {
      alarms = await db.alarmModels
          .where()
          .filter()
          .isEnabledEqualTo(true)
          .and()
          .minutesSinceMidnightGreaterThan(nowInMinutes - 1)
          .sortByMinutesSinceMidnight()
          .findAll();
    } else {
      alarms = await db.alarmModels
          .where()
          .filter()
          .isEnabledEqualTo(true)
          .and()
          .minutesSinceMidnightLessThan(alarmRecord.minutesSinceMidnight + 1)
          .sortByMinutesSinceMidnight()
          .findAll();
    }

    if (alarms.isEmpty) {
      return alarmRecord;
    } else {
      return alarms.first;
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
      print(e);
      throw e;
    }
  }

  static Future<void> deleteAlarm(int id) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;

    await db.writeTxn(() async {
      await db.alarmModels.delete(id);
    });
  }
}
