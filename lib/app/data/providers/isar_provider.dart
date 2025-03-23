import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/profile_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/saved_emails.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class IsarDb {
  static final IsarDb _instance = IsarDb._internal();
  late Future<Isar> db;

  factory IsarDb() {
    return _instance;
  }

  IsarDb._internal() {
    db = openDB();
  }
  static final storage = Get.find<GetStorageProvider>();

  Future<Database?> getAlarmSQLiteDatabase() async {
    Database? db;

    final dir = await getDatabasesPath();
    final dbPath = '$dir/alarms.db';
    db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<Database?> getTimerSQLiteDatabase() async {
    Database? db;
    final dir = await getDatabasesPath();
    db = await openDatabase(
      '$dir/timer.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE timers ( 
            id integer primary key autoincrement, 
            startedOn text not null,
            timerValue integer not null,
            timeElapsed integer not null,
            ringtoneName text not null,
            timerName text not null,
            isPaused integer not null)
        ''');
      },
    );
    return db;
  }

  Future<Database?> setAlarmLogs() async {
    Database? db;
    final dir = await getDatabasesPath();
    db = await openDatabase(
      '$dir/AlarmLogs.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE LOG (
          LogID INTEGER PRIMARY KEY AUTOINCREMENT,  
          LogTime DATETIME NOT NULL,            
          Status VARCHAR(50) NOT NULL)
        ''');
      },
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    // Create tables for alarms and ringtones (modify column types as needed)
    await db.execute('''
      CREATE TABLE alarms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firestoreId TEXT,
        alarmTime TEXT NOT NULL,
        alarmID TEXT NOT NULL UNIQUE,
        isEnabled INTEGER NOT NULL DEFAULT 1,
        isLocationEnabled INTEGER NOT NULL DEFAULT 0,
        isSharedAlarmEnabled INTEGER NOT NULL DEFAULT 0,
        isWeatherEnabled INTEGER NOT NULL DEFAULT 0,
        location TEXT,
        activityInterval INTEGER,
        minutesSinceMidnight INTEGER NOT NULL,
        days TEXT NOT NULL,
        weatherTypes TEXT NOT NULL,
        isMathsEnabled INTEGER NOT NULL DEFAULT 0,
        mathsDifficulty INTEGER,
        numMathsQuestions INTEGER,
        isShakeEnabled INTEGER NOT NULL DEFAULT 0,
        shakeTimes INTEGER,
        isQrEnabled INTEGER NOT NULL DEFAULT 0,
        qrValue TEXT,
        isPedometerEnabled INTEGER NOT NULL DEFAULT 0,
        numberOfSteps INTEGER,
        intervalToAlarm INTEGER,
        isActivityEnabled INTEGER NOT NULL DEFAULT 0,
        sharedUserIds TEXT,
        ownerId TEXT NOT NULL,
        ownerName TEXT NOT NULL,
        lastEditedUserId TEXT,
        mutexLock INTEGER NOT NULL DEFAULT 0,
        mainAlarmTime TEXT,
        label TEXT,
        isOneTime INTEGER NOT NULL DEFAULT 0,
        snoozeDuration INTEGER,
        gradient INTEGER,
        ringtoneName TEXT,
        note TEXT,
        deleteAfterGoesOff INTEGER NOT NULL DEFAULT 0,
        showMotivationalQuote INTEGER NOT NULL DEFAULT 0,
        volMin REAL,
        volMax REAL,
        activityMonitor INTEGER,
        alarmDate TEXT NOT NULL,
        profile TEXT NOT NULL,
        isGuardian INTEGER,
        guardianTimer INTEGER,
        guardian TEXT,
        isCall INTEGER,
        ringOn INTEGER
        
      )
    ''');
    await db.execute('''
      CREATE TABLE ringtones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ringtoneName TEXT NOT NULL,
        ringtonePath TEXT NOT NULL,
        currentCounterOfUsage INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }


  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          AlarmModelSchema,
          RingtoneModelSchema,
          TimerModelSchema,
          ProfileModelSchema,
          Saved_EmailsSchema,
        ],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
  Future<int> insertLog(String status) async {
    try {
      final db = await setAlarmLogs();
      if (db == null) {
        debugPrint('Failed to initialize database for logs');
        return -1;
      }
      final result = await db.insert(
        'LOG',
        {
          'LogTime': DateTime.now().millisecondsSinceEpoch,
          'Status': status,
        },
      );
      debugPrint('Successfully inserted log: $status');
      return result;
    } catch (e) {
      debugPrint('Error inserting log: $e');
      return -1;
    }
  }

  // Fetch all log entries
  Future<List<Map<String, dynamic>>> getLogs() async {
    try {
      final db = await setAlarmLogs();
      if (db == null) {
        debugPrint('Failed to initialize database for logs');
        return [];
      }
      final logs = await db.query('LOG');
      debugPrint('Successfully retrieved ${logs.length} logs');
      return logs;
    } catch (e) {
      debugPrint('Error retrieving logs: $e');
      return [];
    }
  }

  Future<void> clearLogs() async {
    try {
      final db = await setAlarmLogs();
      if (db == null) {
        debugPrint('Failed to initialize database for logs');
        return;
      }
      await db.delete('LOG');
      debugPrint('Successfully cleared all logs');
    } catch (e) {
      debugPrint('Error clearing logs: $e');
      rethrow;
    }
  }

  // Update a log entry
  Future<int> updateLog(int logId, String newStatus) async {
    final db = await setAlarmLogs();
    return await db!.update(
      'LOG',
      {
        'Status': newStatus,
      },
      where: 'LogID = ?',
      whereArgs: [logId],
    );
  }

  static Future<AlarmModel> addAlarm(AlarmModel alarmRecord) async {
    final isarProvider = IsarDb();
    final sql = await IsarDb().getAlarmSQLiteDatabase();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.alarmModels.put(alarmRecord);
    });
    final sqlmap = alarmRecord.toSQFliteMap();
    print(sqlmap);
    await sql!.insert('alarms', sqlmap);
    List a = await IsarDb().getLogs();
    print(a);
    return alarmRecord;
  }

  static Future<ProfileModel> addProfile(ProfileModel profileModel) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.profileModels.put(profileModel);
    });
    return profileModel;
  }

  static Stream<List<ProfileModel>> getProfiles() async* {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;
      yield* db.profileModels.where().watch(fireImmediately: true);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<ProfileModel?> getProfile(String name) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final a = await db.profileModels.filter().profileNameEqualTo(name).findFirst();
    print('$a appkle');
    return a;
  }

  static Future<List> getProfileList() async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final p = await db.profileModels.where().findAll();
    List profileNames = [];
    for (final profiles in p) {
      profileNames.add(profiles.profileName);
    }
    return profileNames;
  }

  static Future<bool> profileExists(String name) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
     final a =
        await db.profileModels.filter().profileNameEqualTo(name).findFirst();

    return a != null;
  }

  static Future profileId(String name) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final a =
        await db.profileModels.filter().profileNameEqualTo(name).findFirst();
    return a == null ? 'null' : a.isarId;
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
    final alarms =
        await db.alarmModels.where().filter().alarmIDEqualTo(alarmID).findAll();
    print('checkEmpty ${alarms[0].alarmID} ${alarms.isNotEmpty}');

    return alarms.isNotEmpty;
  }

  static Future<AlarmModel> getLatestAlarm(
    AlarmModel alarmRecord,
    bool wantNextAlarm,
  ) async {
    int nowInMinutes = 0;
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final currentProfile = await storage.readProfile();

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
    List<AlarmModel> alarms = await db.alarmModels
        .where()
        .filter()
        .isEnabledEqualTo(true)
        .profileEqualTo(currentProfile)
        .findAll();

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
        if (!aRepeats && aTimeUntilNextAlarm < 0) {
          aTimeUntilNextAlarm += Duration.minutesPerDay;
        }
        if (!bRepeats && bTimeUntilNextAlarm < 0) {
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
    final sql = await IsarDb().getAlarmSQLiteDatabase();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.alarmModels.put(alarmRecord);
    });
    await IsarDb().insertLog('Alarm updated ${alarmRecord.alarmTime}');
    await sql!.update(
      'alarms',
      alarmRecord.toSQFliteMap(),
      where: 'alarmID = ?',
      whereArgs: [alarmRecord.alarmID],
    );
  }

  static Future<AlarmModel?> getAlarm(int id) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    return db.alarmModels.get(id);
  }

  static getAlarms(String name) async* {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;
      yield* db.alarmModels
          .filter()
          .profileEqualTo(name)
          .watch(fireImmediately: true);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getProfileAlarms() async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final currentProfileName = await storage.readProfile();
    final currentProfile = await IsarDb.getProfile(currentProfileName);
    List<AlarmModel> alarmsModels = await db.alarmModels
        .where()
        .filter()
        .profileEqualTo(currentProfileName)
        .findAll();
    List alarmMaps = [];
    for (final item in alarmsModels) {
      alarmMaps.add(AlarmModel.toMap(item));
    }
    final Map<String, dynamic> profileSet = {
      'profileName': currentProfileName,
      'profileData': ProfileModel.toMap(currentProfile!),
      'alarmData': alarmMaps,
      'owner': ''
    };
    return profileSet;
  }

  static Future updateAlarmProfiles(String newName) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final currentProfileName = await storage.readProfile();
    final currentProfile = await IsarDb.getProfile(currentProfileName);
    List<AlarmModel> alarmsModels = await db.alarmModels
        .where()
        .filter()
        .profileEqualTo(currentProfileName)
        .findAll();
    for (final item in alarmsModels) {
      item.profile = newName;
      updateAlarm(item);
    }
  }

  static Future<void> deleteAlarm(int id) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final sql = await IsarDb().getAlarmSQLiteDatabase();
    final tobedeleted = await db.alarmModels.get(id);
    await db.writeTxn(() async {
      await db.alarmModels.delete(id);
    });
    await IsarDb().insertLog('Alarm deleted ${tobedeleted!.alarmTime}');
    await sql!.delete(
      'alarms',
      where: 'alarmID = ?',
      whereArgs: [tobedeleted!.alarmID],
    );
  }

  // Timer Functions

  static Future<TimerModel> insertTimer(TimerModel timer) async {
    final isarProvider = IsarDb();
    final sql = await IsarDb().getTimerSQLiteDatabase();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.timerModels.put(timer);
    });

    await sql!.insert('timers', timer.toMap());
    return timer;
  }

  static Future<int> updateTimer(TimerModel timer) async {
    final sql = await IsarDb().getTimerSQLiteDatabase();
    return await sql!.update(
      'timers',
      timer.toMap(),
      where: 'id = ?',
      whereArgs: [timer.timerId],
    );
  }

  static Future<int> updateTimerName(int id, String newTimerName) async {
    final sql = await IsarDb().getTimerSQLiteDatabase();
    return await sql!.update(
      'timers',
      {'timerName': newTimerName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteTimer(int id) async {
    final isarProvider = IsarDb();
    final sql = await IsarDb().getTimerSQLiteDatabase();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.timerModels.delete(id);
    });
    return await sql!.delete('timers', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<TimerModel>> getAllTimers() async {
    final sql = await IsarDb().getTimerSQLiteDatabase();
    List<Map<String, dynamic>> maps = await sql!.query(
      'timers',
      columns: [
        'id',
        'startedOn',
        'timerValue',
        'timeElapsed',
        'ringtoneName',
        'timerName',
        'isPaused',
      ],
    );
    if (maps.isNotEmpty) {
      return maps.map((timer) => TimerModel.fromMap(timer)).toList();
    }
    return [];
  }

  static Future updateTimerTick(TimerModel timer) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.timerModels.put(timer);
    });
    final sql = await IsarDb().getTimerSQLiteDatabase();
    await sql!.update(
      'timers',
      {'timeElapsed': timer.timeElapsed},
      where: 'id = ?',
      whereArgs: [timer.timerId],
    );
  }

  static Stream<List<TimerModel>> getTimers() {
    final isarProvider = IsarDb();
    final controller = StreamController<List<TimerModel>>.broadcast();

    isarProvider.db.then((db) {
      final stream = db.timerModels.where().watch(fireImmediately: true);
      stream.listen(
        (data) => controller.add(data),
        onError: (error) => controller.addError(error),
        onDone: () => controller.close(),
      );
    }).catchError((error) {
      debugPrint(error.toString());
      controller.addError(error);
    });

    return controller.stream;
  }

  static Future updateTimerPauseStatus(TimerModel timer) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.timerModels.put(timer);
    });
    final sql = await IsarDb().getTimerSQLiteDatabase();
    await sql!.update(
      'timers',
      {'isPaused': timer.isPaused},
      where: 'id = ?',
      whereArgs: [timer.timerId],
    );
  }

  static Future<int> getNumberOfTimers() async {
    final sql = await IsarDb().getTimerSQLiteDatabase();
    List<Map<String, dynamic>> x =
        await sql!.rawQuery('SELECT COUNT (*) from timers');
    sql.close();
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

// Ringtone functions
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
      final query = db.ringtoneModels
          .where()
          .filter()
          .isarIdEqualTo(customRingtoneId)
          .findFirst();

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

      final query = db.ringtoneModels.where().sortByRingtoneName().findAll();

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

  static Future<void> addEmail(String email) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final userInDb = await db.saved_Emails
        .filter()
        .emailEqualTo(email, caseSensitive: false)
        .findFirst();
    if (userInDb != null) {
      Get.snackbar('Error', 'Email already exists');
    } else {
      final username = await FirestoreDb.userExists(email);
      if (username == 'error') {
        Get.snackbar('Error', 'User not available');
      } else {
        await db.writeTxn(() async {
          await db.saved_Emails
              .put(Saved_Emails(email: email, username: username));
        }).then((value) => Get.snackbar('Success', 'Email Added'));
      }
    }
  }

  static Stream<List<Saved_Emails>> getEmails() async* {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;
      yield* db.saved_Emails.where().watch(fireImmediately: true);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static loadDefaultRingtones() async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final ringtoneCount = await db.ringtoneModels.where().findAll();
    if (ringtoneCount.isEmpty) {
      await db.writeTxn(() async {
        await db.ringtoneModels.importJson([
          {'isarId' : fastHash('Digital Alarm 1'),
            'ringtoneName': 'Digital Alarm 1',
            'ringtonePath': 'ringtones/digialarm.mp3',
            'currentCounterOfUsage': 0
          },
          {'isarId' : fastHash('Digital Alarm 2'),
            'ringtoneName': 'Digital Alarm 2',
            'ringtonePath': 'ringtones/digialarm2.mp3',
            'currentCounterOfUsage': 0
          },
          {'isarId' : fastHash('Digital Alarm 3'),
            'ringtoneName': 'Digital Alarm 3',
            'ringtonePath': 'ringtones/digialarm3.mp3',
            'currentCounterOfUsage': 0
          },
          {'isarId' : fastHash('Mystery'),
            'ringtoneName': 'Mystery',
            'ringtonePath': 'ringtones/mystery.mp3',
            'currentCounterOfUsage': 0
          },
          {'isarId' : fastHash('New Day'),
            'ringtoneName': 'New Day',
            'ringtonePath': 'ringtones/newday.mp3',
            'currentCounterOfUsage': 0
          },
        ]);
      });
    }
  }
}
