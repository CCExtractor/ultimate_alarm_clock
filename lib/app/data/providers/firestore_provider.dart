import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/home/controllers/home_controller.dart';
import 'get_storage_provider.dart';

class FirestoreDb {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  static final _firebaseAuthInstance = FirebaseAuth.instance;

  static final storage = Get.find<GetStorageProvider>();

  Future<Database?> getSQLiteDatabase() async {
    Database? db;

    final dir = await getDatabasesPath();
    final dbPath = '$dir/alarms.db';
    print(dir);
    db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
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

  static CollectionReference _alarmsCollection(UserModel? user) {
    if (user == null) {
      // Hacky fix to prevent stream from not emitting
      return _firebaseFirestore.collection('alarms');
    } else {
      return _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .collection('alarms');
    }
  }

  static Future<void> addUser(UserModel userModel) async {
    final DocumentReference docRef = _usersCollection.doc(userModel.email);
    final user = await docRef.get();
    if (!user.exists) await docRef.set(userModel.toJson());
  }

  static addAlarm(UserModel? user, AlarmModel alarmRecord) async {
    final sql = await FirestoreDb().getSQLiteDatabase();

    if (user == null) {
      return alarmRecord;
    }
    await sql!
        .insert('alarms', alarmRecord.toSQFliteMap())
        .then((value) => print('insert success'));
    await _alarmsCollection(user)
        .add(AlarmModel.toMap(alarmRecord))
        .then((value) => alarmRecord.firestoreId = value.id);
    return alarmRecord;
  }

  static Future<UserModel?> fetchUserDetails(String userId) async {
    final DocumentSnapshot userSnapshot =
        await _usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      final UserModel user =
          UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
      return user;
    }

    return null;
  }

  static Future<bool> doesAlarmExist(UserModel? user, String alarmID) async {
    QuerySnapshot snapshot = await _alarmsCollection(user)
        .where('alarmID', isEqualTo: alarmID)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  static Future<AlarmModel> getTriggeredAlarm(
    UserModel? user,
    String time,
  ) async {
    HomeController homeController = Get.find<HomeController>();
    if (user == null) return homeController.genFakeAlarmModel();
    QuerySnapshot snapshot = await _alarmsCollection(user)
        .where('isEnabled', isEqualTo: true)
        .where('alarmTime', isEqualTo: time)
        .get();

    List list = snapshot.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(
        documentSnapshot: document,
        user: user,
      );
    }).toList();

    return list[0];
  }

  static Future<AlarmModel> getLatestAlarm(
    UserModel? user,
    AlarmModel alarmRecord,
    bool wantNextAlarm,
  ) async {
    if (user == null) {
      alarmRecord.minutesSinceMidnight = -1;
      return alarmRecord;
    }

    int nowInMinutes = 0;
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
          minute: TimeOfDay.now().minute + 1,
        ),
      );
    }

    late List<AlarmModel> alarms;

    // Get all enabled alarms
    QuerySnapshot snapshot =
        await _alarmsCollection(user).where('isEnabled', isEqualTo: true).get();

    QuerySnapshot snapshotSharedAlarms = await _firebaseFirestore
        .collectionGroup('alarms')
        .where('isEnabled', isEqualTo: true)
        .where('sharedUserIds', arrayContains: user.id)
        .get();

    snapshot.docs.addAll(snapshotSharedAlarms.docs);

    var z = snapshotSharedAlarms.docs.map((DocumentSnapshot document) {
      AlarmModel x = AlarmModel.fromDocumentSnapshot(
        documentSnapshot: document,
        user: user,
      );
      return x;
    }).toList();

    alarms = snapshot.docs.map((DocumentSnapshot document) {
      AlarmModel x = AlarmModel.fromDocumentSnapshot(
        documentSnapshot: document,
        user: user,
      );
      return x;
    }).toList();

    alarms.addAll(z);

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

        // If alarm is one-time and has already passed, set time until
        // next alarm to next day
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

  static updateAlarm(String? userId, AlarmModel alarmRecord) async {
    final sql = await FirestoreDb().getSQLiteDatabase();
    await sql!.update(
      'alarms',
      alarmRecord.toSQFliteMap(),
      where: 'alarmID = ?',
      whereArgs: [alarmRecord.alarmID],
    );
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('alarms')
        .doc(alarmRecord.firestoreId)
        .update(AlarmModel.toMap(alarmRecord));
  }

  static Future<String> userExists(String email) async {
    final receiver =
        await _firebaseFirestore.collection('users').doc(email).get();
    if (receiver.exists) return receiver.data()!['fullName'];
    return 'error';
  }

  static shareProfile(List emails) async {
    final profileSet = await IsarDb.getProfileAlarms();
    final currentProfileName = await storage.readProfile();

    final currentUserEmail = _firebaseAuthInstance.currentUser!.email;
    profileSet['owner'] = currentUserEmail;
    Map sharedItem = {
      'type': 'profile',
      'profileName': currentProfileName,
      'owner': currentUserEmail
    };
    await _firebaseFirestore
        .collection('users')
        .doc(currentUserEmail)
        .collection('sharedProfile')
        .doc(currentProfileName)
        .set(profileSet)
        .then((v) {
      Get.snackbar('Notification', 'Item Shared!');
    });
    ;
    for (final email in emails) {
      await _firebaseFirestore.collection('users').doc(email).update({
        'receivedItems': FieldValue.arrayUnion([sharedItem])
      });
    }
  }

  static shareAlarm(List emails, AlarmModel alarm) async {
    final currentUserEmail = _firebaseAuthInstance.currentUser!.email;
    alarm.profile = 'Default';
    Map sharedItem = {
      'type': 'alarm',
      'AlarmName': alarm.alarmID,
      'owner': currentUserEmail,
      'alarmTime': alarm.alarmTime
    };
    await _firebaseFirestore
        .collection('users')
        .doc(currentUserEmail)
        .collection('sharedAlarms')
        .doc(alarm.alarmID)
        .set(AlarmModel.toMap(alarm))
        .then((v) {
      Get.snackbar('Notification', 'Item Shared!');
    });
    for (final email in emails) {
      await _firebaseFirestore.collection('users').doc(email).update({
        'receivedItems': FieldValue.arrayUnion([sharedItem])
      });
    }
  }

  static Future receiveProfile(String email, String profileName) async {
    final profile = await _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('sharedProfile')
        .doc(profileName)
        .get();
    return profile.data();
  }

  static Future receiveAlarm(String email, String AlarmName) async {
    final alarm = await _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('sharedAlarms')
        .doc(AlarmName)
        .get();
    return alarm.data();
  }

  static Future<void> deleteOneTimeAlarm(
    String? ownerId,
    String? firestoreId,
  ) async {
    final sql = await FirestoreDb().getSQLiteDatabase();

    try {
      // Delete alarm remotely (from Firestore)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerId)
          .collection('alarms')
          .doc(firestoreId)
          .delete();
      sql!.delete('alarms', where: 'firestoreId = ?', whereArgs: [firestoreId]);

      debugPrint('Alarm deleted successfully from Firestore.');
    } catch (e) {
      debugPrint('Error deleting alarm from Firestore: $e');
    }
  }

  static getAlarm(UserModel? user, String id) async {
    if (user == null) return null;
    return await _alarmsCollection(user).doc(id).get();
  }

  // static Stream<QuerySnapshot<Object?>> getAlarms(UserModel? user) {
  //   return _alarmsCollection(user)
  //       .orderBy('minutesSinceMidnight', descending: false)
  //       .snapshots();
  // }

  static Stream<QuerySnapshot<Object?>> getSharedAlarms(UserModel? user) {
    if (user != null) {
      Stream<QuerySnapshot<Object?>> sharedAlarmsStream = _firebaseFirestore
          .collectionGroup('alarms')
          .where('sharedUserIds', arrayContains: user.id)
          .snapshots();

      return sharedAlarmsStream;
    } else {
      return _alarmsCollection(user)
          .orderBy('minutesSinceMidnight', descending: false)
          .snapshots();
    }
  }

  static Stream<QuerySnapshot<Object?>> getAlarms(UserModel? user) {
    if (user != null) {
      Stream<QuerySnapshot<Object?>> userAlarmsStream = _alarmsCollection(user)
          .orderBy('minutesSinceMidnight', descending: false)
          .snapshots(includeMetadataChanges: true);

      return userAlarmsStream;
    } else {
      return _alarmsCollection(user)
          .orderBy('minutesSinceMidnight', descending: false)
          .snapshots();
    }
  }

  static deleteAlarm(UserModel? user, String id) async {
    final sql = await FirestoreDb().getSQLiteDatabase();
    sql!.delete('alarms', where: 'firestoreId = ?', whereArgs: [id]);
    await _alarmsCollection(user).doc(id).delete();
  }

  static addUserToAlarmSharedUsers(UserModel? userModel, String alarmID) async {
    String userModelId = userModel!.id;

    final alarmQuerySnapshot = await _firebaseFirestore
        .collectionGroup('alarms')
        .where('alarmID', isEqualTo: alarmID)
        .get();

    if (alarmQuerySnapshot.size == 0) {
      return false;
    }
    final alarmDoc = alarmQuerySnapshot.docs[0];

    if (alarmDoc.data()['ownerId'] == userModelId) {
      return null;
    }

    final sharedUserIds =
        List<String>.from(alarmDoc.data()['sharedUserIds'] ?? []);
    final offsetDetails =
        Map<String, dynamic>.from(alarmDoc.data()['offsetDetails'] ?? {});

    offsetDetails[userModelId] = {
      'isOffsetBefore': true,
      'offsetDuration': 0,
      'offsettedTime': alarmDoc.data()['alarmTime'],
    };

    if (!sharedUserIds.contains(userModelId)) {
      sharedUserIds.add(userModelId);
      await alarmDoc.reference.update(
        {'sharedUserIds': sharedUserIds, 'offsetDetails': offsetDetails},
      );
    }
    return true;
  }

  static Future<List<String>> removeUserFromAlarmSharedUsers(
    UserModel? userModel,
    String alarmID,
  ) async {
    String userModelId = userModel!.id;

    final alarmQuerySnapshot = await _firebaseFirestore
        .collectionGroup('alarms')
        .where('alarmID', isEqualTo: alarmID)
        .get();

    if (alarmQuerySnapshot.size == 0) {
      return []; // Return an empty list if the alarm is not found
    }

    final alarmDoc = alarmQuerySnapshot.docs[0];
    final sharedUserIds =
        List<String>.from(alarmDoc.data()['sharedUserIds'] ?? []);

    if (sharedUserIds.contains(userModelId)) {
      sharedUserIds.remove(userModelId); // Remove the userId from the list
      await alarmDoc.reference.update({'sharedUserIds': sharedUserIds});
    }

    return sharedUserIds; // Return the updated sharedUserIds list
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      getNotifications() async* {
    Stream<DocumentSnapshot<Map<String, dynamic>>> userNotifications =
        _firebaseFirestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots();

    yield* userNotifications;
  }

  static removeItem(Map item) async {
    print(item);

    await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuthInstance.currentUser!.email)
        .update({
      'receivedItems': FieldValue.arrayRemove([item])
    });
  }
}
