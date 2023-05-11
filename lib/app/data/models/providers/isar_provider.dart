import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class IsarProvider {
  static final IsarProvider _instance = IsarProvider._internal();
  late Future<Isar> db;

  factory IsarProvider() {
    return _instance;
  }

  IsarProvider._internal() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([AlarmModelSchema], directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  static Future<AlarmModel> addAlarm(AlarmModel alarmRecord) async {
    final isarProvider = IsarProvider();
    final db = await isarProvider.db;
    await db.alarmModels.put(alarmRecord);
    return alarmRecord;
  }

  static Future<AlarmModel> getTriggeredAlarm(String time) async {
    final isarProvider = IsarProvider();
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
    final isarProvider = IsarProvider();
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

  Future<void> updateAlarm(AlarmModel alarmRecord) async {
    final isarProvider = IsarProvider();
    final db = await isarProvider.db;
    await db.alarmModels.put(alarmRecord);
  }

  Future<AlarmModel?> getAlarm(int id) async {
    final isarProvider = IsarProvider();
    final db = await isarProvider.db;
    return db.alarmModels.get(id);
  }

  getAlarms() async {
    final isarProvider = IsarProvider();
    final db = await isarProvider.db;
    return db.alarmModels.watchLazy();
  }

  Future<void> deleteAlarm(int id) async {
    final isarProvider = IsarProvider();
    final db = await isarProvider.db;
    await db.alarmModels.delete(id);
  }
}
