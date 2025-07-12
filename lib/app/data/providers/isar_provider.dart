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

enum Status {
  error('ERROR'),
  success('SUCCESS'),
  warning('WARNING');

  final String value;
  const Status(this.value);

  @override
  String toString() => value;
}

enum LogType {
  dev("DEV"),
  normal("NORMAL");

  final String value;
  const LogType(this.value);

  @override
  String toString() => value;
}


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
    db = await openDatabase(dbPath, version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  Future<Database?> getTimerSQLiteDatabase() async {
    Database? db;
    final dir = await getDatabasesPath();
    // await deleteDatabase(dir);
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
            Status TEXT CHECK(Status IN ('ERROR', 'SUCCESS', 'WARNING')) NOT NULL,
            LogType TEXT CHECK(LogType IN ('DEV', 'NORMAL')) NOT NULL,
            Message TEXT NOT NULL,
            HasRung INTEGER DEFAULT 0,
            AlarmID TEXT
          )
        ''');
      },
    );
    return db;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add weatherConditionType column
      await db.execute('ALTER TABLE alarms ADD COLUMN weatherConditionType INTEGER NOT NULL DEFAULT 2');
    }
    if (oldVersion < 3) {
      // Add activityConditionType column
      await db.execute('ALTER TABLE alarms ADD COLUMN activityConditionType INTEGER NOT NULL DEFAULT 2');
    }
    if (oldVersion < 4) {
      // Add sunrise alarm columns
      await db.execute('ALTER TABLE alarms ADD COLUMN isSunriseEnabled INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE alarms ADD COLUMN sunriseDuration INTEGER NOT NULL DEFAULT 30');
      await db.execute('ALTER TABLE alarms ADD COLUMN sunriseIntensity REAL NOT NULL DEFAULT 1.0');
      await db.execute('ALTER TABLE alarms ADD COLUMN sunriseColorScheme INTEGER NOT NULL DEFAULT 0');
    }
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
        locationConditionType INTEGER NOT NULL DEFAULT 2,
        isSharedAlarmEnabled INTEGER NOT NULL DEFAULT 0,
        isWeatherEnabled INTEGER NOT NULL DEFAULT 0,
        weatherConditionType INTEGER NOT NULL DEFAULT 2,
        activityConditionType INTEGER NOT NULL DEFAULT 2,
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
        mutexLockTimestamp INTEGER NOT NULL DEFAULT 0,
        mainAlarmTime TEXT,
        label TEXT,
        isOneTime INTEGER NOT NULL DEFAULT 0,
        snoozeDuration INTEGER,
        maxSnoozeCount INTEGER DEFAULT 3,
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
        ringOn INTEGER,
        isSunriseEnabled INTEGER NOT NULL DEFAULT 0,
        sunriseDuration INTEGER NOT NULL DEFAULT 30,
        sunriseIntensity REAL NOT NULL DEFAULT 1.0,
        sunriseColorScheme INTEGER NOT NULL DEFAULT 0
        
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
  Future<int> insertLog(String msg, {Status status = Status.warning, LogType type = LogType.dev, int hasRung = 0}) async {
    try {
      final db = await setAlarmLogs();
      if (db == null) {
        debugPrint('Failed to initialize database for logs');
        return -1;
      }
      String st = status.toString();
      String t = type.toString();
      final result = await db.insert(
        'LOG',
        {
          'LogTime': DateTime.now().millisecondsSinceEpoch,
          'Status': st,
          'LogType': t,
          'Message': msg,
          'HasRung': hasRung,
        },
      );
      debugPrint('Successfully inserted log: $msg');
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

  static Future<AlarmModel> addAlarm(AlarmModel alarmRecord) async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    
    await db.writeTxn(() async {
      await db.alarmModels.put(alarmRecord);
    });
    final sqlmap = alarmRecord.toSQFliteMap();
    print(sqlmap);
    
    if (!alarmRecord.isSharedAlarmEnabled) {
      final sql = await IsarDb().getAlarmSQLiteDatabase();
      try {
        // Try to insert with all fields including new columns
        await sql!.insert('alarms', sqlmap);
      } catch (e) {
        if (e.toString().contains('locationConditionType') || 
            e.toString().contains('weatherConditionType') || 
            e.toString().contains('activityConditionType') ||
            e.toString().contains('isSunriseEnabled') ||
            e.toString().contains('sunriseDuration') ||
            e.toString().contains('sunriseIntensity') ||
            e.toString().contains('sunriseColorScheme')) {
          // If new columns don't exist, insert without them for backward compatibility
          Map<String, dynamic> fallbackMap = Map.from(sqlmap);
          fallbackMap.remove('locationConditionType');
          fallbackMap.remove('weatherConditionType');
          fallbackMap.remove('activityConditionType');
          fallbackMap.remove('isSunriseEnabled');
          fallbackMap.remove('sunriseDuration');
          fallbackMap.remove('sunriseIntensity');
          fallbackMap.remove('sunriseColorScheme');
          await sql!.insert('alarms', fallbackMap);
          debugPrint('Inserted alarm without new columns (backward compatibility)');
        } else {
          rethrow;
        }
      }
    }
    
    // Detailed alarm creation log (NORMAL - always visible)
    String alarmType = alarmRecord.isSharedAlarmEnabled ? 'SHARED' : 'LOCAL';
    String detailedMessage = buildDetailedAlarmCreationMessage(alarmRecord, alarmType);
    await IsarDb().insertLog(
      detailedMessage,
      status: Status.success,
      type: LogType.normal,
    );
    
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
    // print('checkEmpty ${alarms[0].alarmID} ${alarms.isNotEmpty}');

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


    List<AlarmModel> alarms = await db.alarmModels
        .where()
        .filter()
        .isEnabledEqualTo(true)
        .and()
        .isSharedAlarmEnabledEqualTo(false)
        .and()
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
    final db = await isarProvider.db;
    await db.writeTxn(() async {
      await db.alarmModels.put(alarmRecord);
    });
    
    // Detailed alarm update log (NORMAL - always visible)
    String alarmType = alarmRecord.isSharedAlarmEnabled ? 'SHARED' : 'LOCAL';
    String detailedMessage = buildDetailedAlarmUpdateMessage(alarmRecord, alarmType);
    await IsarDb().insertLog(detailedMessage, status: Status.success, type: LogType.normal);
    
    if (!alarmRecord.isSharedAlarmEnabled) {
      final sql = await IsarDb().getAlarmSQLiteDatabase();
      await sql!.update(
        'alarms',
        alarmRecord.toSQFliteMap(),
        where: 'alarmID = ?',
        whereArgs: [alarmRecord.alarmID],
      );
    }
  }

  
  static Future<void> fixMaxSnoozeCountInAlarms() async {
    final isarProvider = IsarDb();
    final db = await isarProvider.db;
    final sql = await IsarDb().getAlarmSQLiteDatabase();
    
  
    final alarms = await db.alarmModels.where().findAll();
    
  
    for (final alarm in alarms) {
  
      await sql!.update(
        'alarms',
        {'maxSnoozeCount': alarm.maxSnoozeCount},
        where: 'alarmID = ?',
        whereArgs: [alarm.alarmID],
      );
    }
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
    final tobedeleted = await db.alarmModels.get(id);
    
    if (tobedeleted == null) return;
    
    await db.writeTxn(() async {
      await db.alarmModels.delete(id);
    });
    
    // Detailed alarm deletion log (NORMAL - always visible)
    String alarmType = tobedeleted.isSharedAlarmEnabled ? 'SHARED' : 'LOCAL';
    String detailedMessage = "DELETED $alarmType ALARM - Time: ${tobedeleted.alarmTime}, ID: ${tobedeleted.alarmID}, Type: $alarmType";
    if (tobedeleted.note.isNotEmpty) {
      detailedMessage += ", Note: \"${tobedeleted.note}\"";
    }
    await IsarDb().insertLog(detailedMessage, status: Status.warning, type: LogType.normal);
    

    if (!tobedeleted.isSharedAlarmEnabled) {
      final sql = await IsarDb().getAlarmSQLiteDatabase();
      await sql!.delete(
        'alarms',
        where: 'alarmID = ?',
        whereArgs: [tobedeleted.alarmID],
      );
    }
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

  static String buildDetailedAlarmCreationMessage(AlarmModel alarm, String alarmType) {
    List<String> details = [];
    
    // Basic info
    details.add("Time: ${alarm.alarmTime}");
    details.add("ID: ${alarm.alarmID}");
    details.add("Type: $alarmType");
    
    // Days/Repetition
    List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> enabledDays = [];
    for (int i = 0; i < alarm.days.length; i++) {
      if (alarm.days[i]) enabledDays.add(dayNames[i]);
    }
    if (enabledDays.isNotEmpty) {
      details.add("Days: ${enabledDays.join(', ')}");
    } else {
      details.add("Days: One-time");
    }
    
    // Conditions
    List<String> conditions = [];
    
    if (alarm.isActivityEnabled) {
      conditions.add("Activity: ON");
    }
    
    if (alarm.isLocationEnabled) {
      String locationCondition = '';
      switch (alarm.locationConditionType) {
        case 1: locationCondition = 'Ring when AT'; break;
        case 2: locationCondition = 'Cancel when AT'; break;
        case 3: locationCondition = 'Ring when AWAY'; break;
        case 4: locationCondition = 'Cancel when AWAY'; break;
        default: locationCondition = 'Unknown'; break;
      }
      conditions.add("Location: $locationCondition (${alarm.location})");
    }
    
    if (alarm.isWeatherEnabled) {
      String weatherCondition = '';
      switch (alarm.weatherConditionType) {
        case 1: weatherCondition = 'Ring when weather matches'; break;
        case 2: weatherCondition = 'Cancel when weather matches'; break;
        case 3: weatherCondition = 'Ring when weather different'; break;
        case 4: weatherCondition = 'Cancel when weather different'; break;
        default: weatherCondition = 'Unknown'; break;
      }
      conditions.add("Weather: $weatherCondition (${alarm.weatherTypes})");
    }
    
    if (conditions.isNotEmpty) {
      details.add("Conditions: [${conditions.join(', ')}]");
    } else {
      details.add("Conditions: None");
    }
    
    // Challenges
    List<String> challenges = [];
    if (alarm.isMathsEnabled) challenges.add("Math");
    if (alarm.isShakeEnabled) challenges.add("Shake");
    if (alarm.isQrEnabled) challenges.add("QR Code");
    if (alarm.isPedometerEnabled) challenges.add("Steps");
    
    if (challenges.isNotEmpty) {
      details.add("Challenges: [${challenges.join(', ')}]");
    }
    
    // Note
    if (alarm.note.isNotEmpty) {
      details.add("Note: \"${alarm.note}\"");
    }
    
    return "CREATED $alarmType ALARM - ${details.join(', ')}";
  }

  static String buildDetailedAlarmUpdateMessage(AlarmModel alarm, String alarmType) {
    List<String> details = [];
    
    // Basic info
    details.add("Time: ${alarm.alarmTime}");
    details.add("ID: ${alarm.alarmID}");
    details.add("Type: $alarmType");
    
    // Days/Repetition
    List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> enabledDays = [];
    for (int i = 0; i < alarm.days.length; i++) {
      if (alarm.days[i]) enabledDays.add(dayNames[i]);
    }
    if (enabledDays.isNotEmpty) {
      details.add("Days: ${enabledDays.join(', ')}");
    } else {
      details.add("Days: One-time");
    }
    
    // Conditions
    List<String> conditions = [];
    
    if (alarm.isActivityEnabled) {
      conditions.add("Activity: ON");
    }
    
    if (alarm.isLocationEnabled) {
      String locationCondition = '';
      switch (alarm.locationConditionType) {
        case 1: locationCondition = 'Ring when AT'; break;
        case 2: locationCondition = 'Cancel when AT'; break;
        case 3: locationCondition = 'Ring when AWAY'; break;
        case 4: locationCondition = 'Cancel when AWAY'; break;
        default: locationCondition = 'Unknown'; break;
      }
      conditions.add("Location: $locationCondition (${alarm.location})");
    }
    
    if (alarm.isWeatherEnabled) {
      String weatherCondition = '';
      switch (alarm.weatherConditionType) {
        case 1: weatherCondition = 'Ring when weather matches'; break;
        case 2: weatherCondition = 'Cancel when weather matches'; break;
        case 3: weatherCondition = 'Ring when weather different'; break;
        case 4: weatherCondition = 'Cancel when weather different'; break;
        default: weatherCondition = 'Unknown'; break;
      }
      conditions.add("Weather: $weatherCondition (${alarm.weatherTypes})");
    }
    
    if (conditions.isNotEmpty) {
      details.add("Conditions: [${conditions.join(', ')}]");
    } else {
      details.add("Conditions: None");
    }
    
    // Challenges
    List<String> challenges = [];
    if (alarm.isMathsEnabled) challenges.add("Math");
    if (alarm.isShakeEnabled) challenges.add("Shake");
    if (alarm.isQrEnabled) challenges.add("QR Code");
    if (alarm.isPedometerEnabled) challenges.add("Steps");
    
    if (challenges.isNotEmpty) {
      details.add("Challenges: [${challenges.join(', ')}]");
    }
    
    // Note
    if (alarm.note.isNotEmpty) {
      details.add("Note: \"${alarm.note}\"");
    }
    
    return "UPDATED $alarmType ALARM - ${details.join(', ')}";
  }

  static String buildDetailedAlarmRingMessage(AlarmModel alarm, String alarmType) {
    List<String> details = [];
    
    // Primary identification - what user sees first
    String primaryInfo = "🔔 RINGING $alarmType ALARM";
    
    // Alarm identification details
    details.add("⏰ Time: ${alarm.alarmTime}");
    
    // Label/Name (most important for user identification)
    if (alarm.label != null && alarm.label!.isNotEmpty) {
      details.add("📝 Label: \"${alarm.label}\"");
    }
    
    // Note (secondary identification)
    if (alarm.note.isNotEmpty) {
      details.add("💬 Note: \"${alarm.note}\"");
    }
    
    // Ringtone (helps user identify which alarm is ringing)
    if (alarm.ringtoneName.isNotEmpty) {
      details.add("🎵 Ringtone: ${alarm.ringtoneName}");
    }
    
    // Days/Repetition (important for identification)
    List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> enabledDays = [];
    for (int i = 0; i < alarm.days.length; i++) {
      if (alarm.days[i]) enabledDays.add(dayNames[i]);
    }
    if (enabledDays.isNotEmpty) {
      details.add("📅 Days: ${enabledDays.join(', ')}");
    } else {
      details.add("📅 Days: One-time alarm");
    }
    
    // Owner info for shared alarms
    if (alarm.isSharedAlarmEnabled && alarm.ownerName.isNotEmpty) {
      details.add("👥 Owner: ${alarm.ownerName}");
    }
    
    // Profile info
    if (alarm.profile.isNotEmpty && alarm.profile != 'Default') {
      details.add("👤 Profile: ${alarm.profile}");
    }
    
    // Active conditions (important for understanding why it rang)
    List<String> activeConditions = [];
    
    if (alarm.isActivityEnabled) {
      activeConditions.add("Activity Monitor");
    }
    
    if (alarm.isLocationEnabled) {
      String locationCondition = '';
      switch (alarm.locationConditionType) {
        case 1: locationCondition = 'Ring when AT'; break;
        case 2: locationCondition = 'Cancel when AT'; break;
        case 3: locationCondition = 'Ring when AWAY'; break;
        case 4: locationCondition = 'Cancel when AWAY'; break;
        default: locationCondition = 'Unknown'; break;
      }
      activeConditions.add("Location: $locationCondition (${alarm.location})");
    }
    
    if (alarm.isWeatherEnabled) {
      String weatherCondition = '';
      switch (alarm.weatherConditionType) {
        case 1: weatherCondition = 'Ring when weather matches'; break;
        case 2: weatherCondition = 'Cancel when weather matches'; break;
        case 3: weatherCondition = 'Ring when weather different'; break;
        case 4: weatherCondition = 'Cancel when weather different'; break;
        default: weatherCondition = 'Unknown'; break;
      }
      activeConditions.add("Weather: $weatherCondition (${alarm.weatherTypes})");
    }
    
    if (activeConditions.isNotEmpty) {
      details.add("⚙️ Active Conditions: [${activeConditions.join(', ')}]");
    }
    
    // Challenges (what user needs to do to dismiss)
    List<String> challenges = [];
    if (alarm.isMathsEnabled) challenges.add("Math Questions");
    if (alarm.isShakeEnabled) challenges.add("Shake Device");
    if (alarm.isQrEnabled) challenges.add("Scan QR Code");
    if (alarm.isPedometerEnabled) challenges.add("Walk ${alarm.numberOfSteps} Steps");
    
    if (challenges.isNotEmpty) {
      details.add("🎯 Challenges: [${challenges.join(', ')}]");
    }
    
    // Guardian info (important safety feature)
    if (alarm.isGuardian) {
      details.add("🆘 Guardian: ${alarm.guardian} (${alarm.guardianTimer}s timer)");
    }
    
    // Technical details
    details.add("🆔 ID: ${alarm.alarmID}");
    details.add("🏷️ Type: $alarmType");
    
    return "$primaryInfo - ${details.join(', ')}";
  }
}