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
    db = await openDatabase(dbPath, version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
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
    if (oldVersion < 5) {
      // Add timezone columns
      await db.execute('ALTER TABLE alarms ADD COLUMN timezoneId TEXT NOT NULL DEFAULT ""');
      await db.execute('ALTER TABLE alarms ADD COLUMN isTimezoneEnabled INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE alarms ADD COLUMN targetTimezoneOffset INTEGER NOT NULL DEFAULT 0');
    }
    if (oldVersion < 6) {
      // Add smart control combination type column
      await db.execute('ALTER TABLE alarms ADD COLUMN smartControlCombinationType INTEGER NOT NULL DEFAULT 0');
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
        alarmDate TEXT NOT NULL DEFAULT "",
        profile TEXT NOT NULL,
        isGuardian INTEGER,
        guardianTimer INTEGER,
        guardian TEXT,
        isCall INTEGER,
        ringOn INTEGER,
        isSunriseEnabled INTEGER NOT NULL DEFAULT 0,
        sunriseDuration INTEGER NOT NULL DEFAULT 30,
        sunriseIntensity REAL NOT NULL DEFAULT 1.0,
        sunriseColorScheme INTEGER NOT NULL DEFAULT 0,
        timezoneId TEXT NOT NULL DEFAULT "",
        isTimezoneEnabled INTEGER NOT NULL DEFAULT 0,
        targetTimezoneOffset INTEGER NOT NULL DEFAULT 0,
        smartControlCombinationType INTEGER NOT NULL DEFAULT 0

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
    // Always use sharedAlarms collection since we're using shared alarm functionality
    return _firebaseFirestore.collection('sharedAlarms');
  }

  static Future<void> addUser(UserModel userModel) async {
    try {
      debugPrint('🔥 Attempting to add user to Firestore:');
      debugPrint('   - User ID: ${userModel.id}');
      debugPrint('   - Firebase Auth User: ${_firebaseAuthInstance.currentUser?.uid}');
      debugPrint('   - User Email: ${userModel.email}');
      
      final DocumentReference docRef = _usersCollection.doc(userModel.id);
      final user = await docRef.get();
      
      if (!user.exists) {
        // Ensure receivedItems is initialized as an empty array
        Map<String, dynamic> userData = userModel.toJson();
        userData['receivedItems'] = userData['receivedItems'] ?? [];
        
        debugPrint('🔥 Creating new user document...');
        await docRef.set(userData);
        debugPrint('✅ Created new user document with receivedItems: ${userModel.id}');
      } else {
        // Check if existing user has receivedItems field, add it if missing
        final data = user.data() as Map<String, dynamic>?;
        if (data != null && !data.containsKey('receivedItems')) {
          debugPrint('🔥 Adding receivedItems field to existing user...');
          await docRef.update({'receivedItems': []});
          debugPrint('✅ Added receivedItems field to existing user: ${userModel.id}');
        } else {
          debugPrint('✅ User document already exists with receivedItems: ${userModel.id}');
        }
      }
    } catch (e) {
      debugPrint('❌ Error adding user to Firestore: $e');
      rethrow;
    }
  }

  static addAlarm(UserModel? user, AlarmModel alarmRecord) async {
    if (user == null) {
      return alarmRecord;
    }
    
    if (alarmRecord.isSharedAlarmEnabled) {
      // Create shared alarm in Firestore
      await _firebaseFirestore
          .collection('sharedAlarms')
          .add(AlarmModel.toMap(alarmRecord))
          .then((value) => alarmRecord.firestoreId = value.id);
      debugPrint('✅ Created shared alarm in Firestore: ${alarmRecord.firestoreId}');
      
      // Detailed shared alarm creation log (NORMAL - always visible) 
      String detailedMessage = IsarDb.buildDetailedAlarmCreationMessage(alarmRecord, 'SHARED');
      await IsarDb().insertLog(
        detailedMessage,
        status: Status.success,
        type: LogType.normal,
      );
    } else {
      // Create local alarm in SQLite
      final sql = await FirestoreDb().getSQLiteDatabase();
      try {
        // Try to insert with all fields including new columns
        await sql!
            .insert('alarms', alarmRecord.toSQFliteMap())
            .then((value) => print('insert success'));
      } catch (e) {
        if (e.toString().contains('locationConditionType') || 
            e.toString().contains('weatherConditionType') || 
            e.toString().contains('activityConditionType') ||
            e.toString().contains('isSunriseEnabled') ||
            e.toString().contains('sunriseDuration') ||
            e.toString().contains('sunriseIntensity') ||
            e.toString().contains('sunriseColorScheme') ||
            e.toString().contains('smartControlCombinationType') ||
            e.toString().contains('timezoneId') ||
            e.toString().contains('isTimezoneEnabled') ||
            e.toString().contains('targetTimezoneOffset')) {
          // If new columns don't exist, insert without them for backward compatibility
          Map<String, dynamic> fallbackMap = Map.from(alarmRecord.toSQFliteMap());
          fallbackMap.remove('locationConditionType');
          fallbackMap.remove('weatherConditionType');
          fallbackMap.remove('activityConditionType');
          fallbackMap.remove('isSunriseEnabled');
          fallbackMap.remove('sunriseDuration');
          fallbackMap.remove('sunriseIntensity');
          fallbackMap.remove('sunriseColorScheme');
          fallbackMap.remove('smartControlCombinationType');
          fallbackMap.remove('timezoneId');
          fallbackMap.remove('isTimezoneEnabled');
          fallbackMap.remove('targetTimezoneOffset');
          await sql!
              .insert('alarms', fallbackMap)
              .then((value) => print('insert success (backward compatibility)'));
        } else {
          rethrow; // Re-throw other errors
        }
      }
      debugPrint('✅ Created normal alarm in SQLite');
    }
    
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

    int nowInMinutes = Utils.timeOfDayToInt(
      TimeOfDay(
        hour: TimeOfDay.now().hour,
        minute: TimeOfDay.now().minute + 1,
      ),
    );

    late List<AlarmModel> alarms = [];

    
    QuerySnapshot snapshotSharedAlarms = await _firebaseFirestore
        .collection('sharedAlarms')
        .where('isEnabled', isEqualTo: true)
        .where(      
        Filter.or(
        Filter('sharedUserIds', arrayContains:  user.id),
        Filter('ownerId', isEqualTo: user.id),
      ),)
        .get();

    final sharedAlarms = snapshotSharedAlarms.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(
        documentSnapshot: document,
        user: user,
      );
    }).toList();
    
    alarms.addAll(sharedAlarms);

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
    
    try {
      // Try to update with all fields including new columns
      await sql!.update(
        'alarms',
        alarmRecord.toSQFliteMap(),
        where: 'alarmID = ?',
        whereArgs: [alarmRecord.alarmID],
      );
    } catch (e) {
      if (e.toString().contains('locationConditionType') || 
          e.toString().contains('weatherConditionType') || 
          e.toString().contains('activityConditionType') ||
          e.toString().contains('smartControlCombinationType') ||
          e.toString().contains('timezoneId') ||
          e.toString().contains('isTimezoneEnabled') ||
          e.toString().contains('targetTimezoneOffset') ||
          e.toString().contains('isSunriseEnabled') ||
          e.toString().contains('sunriseDuration') ||
          e.toString().contains('sunriseIntensity') ||
          e.toString().contains('sunriseColorScheme')) {
      
        Map<String, dynamic> fallbackMap = Map.from(alarmRecord.toSQFliteMap());
        fallbackMap.remove('locationConditionType');
        fallbackMap.remove('weatherConditionType');
        fallbackMap.remove('activityConditionType');
        fallbackMap.remove('smartControlCombinationType');
        fallbackMap.remove('timezoneId');
        fallbackMap.remove('isTimezoneEnabled');
        fallbackMap.remove('targetTimezoneOffset');
        fallbackMap.remove('isSunriseEnabled');
        fallbackMap.remove('sunriseDuration');
        fallbackMap.remove('sunriseIntensity');
        fallbackMap.remove('sunriseColorScheme');
        await sql!.update(
          'alarms',
          fallbackMap,
          where: 'alarmID = ?',
          whereArgs: [alarmRecord.alarmID],
        );
        debugPrint('Updated alarm without new columns (backward compatibility)');
      } else {
        rethrow;
      }
    }
    
    await _firebaseFirestore
        .collection('sharedAlarms')
        .doc(alarmRecord.firestoreId)
        .update(AlarmModel.toMap(alarmRecord));
  }

static Future<String> userExists(String email) async {
  final querySnapshot = await _firebaseFirestore
      .collection('users')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.data()['fullName'];
  }

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

static Future<List<String>> getUserIdsByEmails(List emails) async {
  List<String> userIds = [];

  const batchSize = 10;
  for (int i = 0; i < emails.length; i += batchSize) {
    final batch = emails.sublist(i, i + batchSize > emails.length ? emails.length : i + batchSize);
    final querySnapshot = await _firebaseFirestore
        .collection('users')
        .where('email', whereIn: batch)
        .get();

    for (var doc in querySnapshot.docs) {
      userIds.add(doc.id);
    }
  }

  return userIds;
}


  static Future<void> shareAlarm(List emails, AlarmModel alarm) async {
    debugPrint('🚀 shareAlarm called with ${emails.length} emails');
    
    if (emails.isEmpty) {
      debugPrint('❌ No emails provided for sharing');
      return;
    }

    final currentUserEmail = _firebaseAuthInstance.currentUser!.email;
    final currentUserId = _firebaseAuthInstance.currentUser!.uid;
    
    debugPrint('👤 Current user: $currentUserEmail (ID: $currentUserId)');
    
    // Get current user's name for the notification
    String ownerName = currentUserEmail ?? 'Someone';
    try {
      final currentUserDoc = await _firebaseFirestore
          .collection('users')
          .doc(currentUserId)
          .get();
      if (currentUserDoc.exists) {
        final userData = currentUserDoc.data() as Map<String, dynamic>;
        ownerName = userData['fullName'] ?? currentUserEmail ?? 'Someone';
        debugPrint('✅ Found owner name: $ownerName');
      }
    } catch (e) {
      debugPrint('❌ Could not fetch owner name: $e');
    }
    
    alarm.profile = 'Default';
    Map sharedItem = {
      'type': 'alarm',
      'AlarmName': alarm.firestoreId,
      'owner': ownerName,  // Use readable name instead of userId
      'alarmTime': alarm.alarmTime
    };

    debugPrint('🔄 Sharing alarm with ${emails.length} users');
    debugPrint('   - Alarm ID: ${alarm.firestoreId}');
    debugPrint('   - Alarm Time: ${alarm.alarmTime}');
    debugPrint('   - Owner: $ownerName');
    debugPrint('   - Recipients: $emails');
    debugPrint('   - Shared item: $sharedItem');

    try {
      int successCount = 0;
      for (int i = 0; i < emails.length; i++) {
        final email = emails[i];
        debugPrint('📧 Processing recipient ${i + 1}/${emails.length}: $email');
        
        try {
          bool success = await addItemToUserByEmail(email, sharedItem);
          if (success) {
            successCount++;
            debugPrint('✅ Successfully shared alarm with $email');
          } else {
            debugPrint('❌ Failed to share alarm with $email - user not found');
          }
        } catch (e) {
          debugPrint('❌ Error sharing alarm with $email: $e');
        }
      }
      
      if (successCount > 0) {
        debugPrint('✅ Alarm shared successfully with $successCount/${emails.length} recipients');
      } else {
        debugPrint('❌ Failed to share alarm with any recipients');
      }
    } catch (e) {
      debugPrint('❌ Error in shareAlarm: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
    }
  }

static Future<bool> addItemToUserByEmail(String email, dynamic sharedItem) async {
  try {
    debugPrint('🔍 Looking up user by email: $email');
    final querySnapshot = await _firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      debugPrint('✅ Found user: ${userData['fullName']} (ID: $docId)');
      debugPrint('📦 Current receivedItems: ${userData['receivedItems']}');
      debugPrint('📦 Adding shared item to receivedItems: $sharedItem');
      
      // Verify the document update
      await _firebaseFirestore.collection('users').doc(docId).update({
        'receivedItems': FieldValue.arrayUnion([sharedItem])
      });
      
      // Verify the update was successful
      final updatedDoc = await _firebaseFirestore.collection('users').doc(docId).get();
      final updatedData = updatedDoc.data() as Map<String, dynamic>;
      debugPrint('✅ Updated receivedItems: ${updatedData['receivedItems']}');
      debugPrint('✅ Successfully added shared item to user $email');
      return true;
    } else {
      debugPrint('❌ User not found with email: $email');
      return false;
    }
  } catch (e) {
    debugPrint('❌ Error adding item to user $email: $e');
    debugPrint('❌ Stack trace: ${StackTrace.current}');
    return false; 
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

  static Future receiveAlarm(String ownerId, String alarmId) async {
    final alarm = await _firebaseFirestore
        .collection('sharedAlarms')
        .doc(alarmId)
        .get();
    return alarm.data();
  }

  static Future<void> deleteOneTimeAlarm(
    String? ownerId,
    String? firestoreId,
  ) async {
    try {
      // Delete alarm remotely (from Firestore)
      await FirebaseFirestore.instance
          .collection('sharedAlarms')
          .doc(firestoreId)
          .delete();
      
      
      final sql = await FirestoreDb().getSQLiteDatabase();
      await sql!.delete('alarms', where: 'firestoreId = ?', whereArgs: [firestoreId]);

      debugPrint('Alarm deleted successfully from Firestore.');
    } catch (e) {
      debugPrint('Error deleting alarm from Firestore: $e');
    }
  }

  static Future<void> markSharedAlarmDismissedByUser(
    String firestoreId,
    String userId,
  ) async {
    try {
      
      await FirebaseFirestore.instance
          .collection('sharedAlarms')
          .doc(firestoreId)
          .update({
        'dismissedByUsers': FieldValue.arrayUnion([userId]),
        'lastDismissedAt': FieldValue.serverTimestamp(),
      });
      
      debugPrint('Marked shared alarm as dismissed by user: $userId');
      
      
      final alarmDoc = await FirebaseFirestore.instance
          .collection('sharedAlarms')
          .doc(firestoreId)
          .get();
      
      if (alarmDoc.exists) {
        final data = alarmDoc.data() as Map<String, dynamic>;
        final sharedUserIds = List<String>.from(data['sharedUserIds'] ?? []);
        final ownerId = data['ownerId'] as String?;
        final dismissedByUsers = List<String>.from(data['dismissedByUsers'] ?? []);
        
      
        final offsetDetailsRaw = data['offsetDetails'];
        final Set<String> acceptedUsers = <String>{};
        
        if (offsetDetailsRaw is Map) {
      
          final offsetDetails = Map<String, dynamic>.from(offsetDetailsRaw);
          acceptedUsers.addAll(offsetDetails.keys.cast<String>());
        } else if (offsetDetailsRaw is List) {
      
          final offsetDetailsList = List<dynamic>.from(offsetDetailsRaw);
          for (final item in offsetDetailsList) {
            if (item is Map && item.containsKey('userId')) {
              acceptedUsers.add(item['userId'].toString());
            }
          }
        }
        
      
      
        final allUsers = <String>{};
        if (ownerId != null) {
          allUsers.add(ownerId);
        }
      
        allUsers.addAll(acceptedUsers);
        
      
        debugPrint('🔍 Dismissal check for alarm $firestoreId:');
        debugPrint('   - sharedUserIds (invited): $sharedUserIds');
        debugPrint('   - acceptedUsers (from offsetDetails): ${acceptedUsers.toList()}');
        debugPrint('   - ownerId: $ownerId');
        debugPrint('   - dismissedByUsers: $dismissedByUsers');
        debugPrint('   - allUsers (who actually have the alarm): $allUsers');
        debugPrint('   - dismissedByUsers.length: ${dismissedByUsers.length}');
        debugPrint('   - allUsers.length: ${allUsers.length}');
        
      
        if (dismissedByUsers.length >= allUsers.length) {
          await FirebaseFirestore.instance
              .collection('sharedAlarms')
              .doc(firestoreId)
              .delete();
          debugPrint('✅ All users who have the alarm dismissed it - deleted shared alarm completely: $firestoreId');
        } else {
          debugPrint('⏳ Not all users who have the alarm have dismissed yet - keeping alarm: $firestoreId');
        }
      }
    } catch (e) {
      debugPrint('Error marking shared alarm as dismissed by user: $e');
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
          .collection('sharedAlarms')
        .where(      
        Filter.or(
        Filter('sharedUserIds', arrayContains:  user.id),
        Filter('ownerId', isEqualTo: user.id),
      ),)          .snapshots();

      return sharedAlarmsStream;
    } else {
      // Return a stream that emits from an empty collection to provide a proper QuerySnapshot
      // This prevents the StreamBuilder from hanging on loading
      return _firebaseFirestore
          .collection('_empty_shared_alarms_placeholder')
          .limit(0)
          .snapshots();
    }
  }

  static Stream<QuerySnapshot<Object?>> getAlarms(UserModel? user) {
    if (user != null) {
      Stream<QuerySnapshot<Object?>> userAlarmsStream = _alarmsCollection(user)
                .where(      
        Filter.or(
        Filter('sharedUserIds', arrayContains:  user.id),
        Filter('ownerId', isEqualTo: user.id),
      ),)
          .snapshots(includeMetadataChanges: true);

      return userAlarmsStream;
    } else {
      return _alarmsCollection(user)
          .orderBy('minutesSinceMidnight', descending: false)
          .snapshots();
    }
  }

  static deleteAlarm(UserModel? user, String id) async {
    if (user == null) return;
    
    try {
      
      await _firebaseFirestore
          .collection('sharedAlarms')
          .doc(id)
          .delete();
      
      
      final sql = await FirestoreDb().getSQLiteDatabase();
      await sql!.delete('alarms', where: 'firestoreId = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error deleting alarm: $e');
    }
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
        .collection('alarms')
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
    // Check if user is authenticated
    if (_firebaseAuthInstance.currentUser == null) {
      // Return empty stream that never emits anything for unauthenticated users
      return;
    }
    
    Stream<DocumentSnapshot<Map<String, dynamic>>> userNotifications =
        _firebaseFirestore
            .collection('users')
            .doc(_firebaseAuthInstance.currentUser!.uid)
            .snapshots();

    yield* userNotifications;
  }

  static removeItem(Map item) async {
    print(item);

    await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuthInstance.currentUser!.uid)
        .update({
      'receivedItems': FieldValue.arrayRemove([item])
    });
  }


  static updateToken(String token) async {
    try {
      if (_firebaseAuthInstance.currentUser != null) {
        await _firebaseFirestore
            .collection('users')
            .doc(_firebaseAuthInstance.currentUser!.uid)
            .update({
          'fcmToken': token
        });
      } else {
        debugPrint('No authenticated user found when updating FCM token');
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  static acceptSharedAlarm(String alarmOwnerId, AlarmModel alarm) async {
    String? currentUserId = _firebaseAuthInstance.currentUser!.uid;
    
    
    final alarmDoc = await _firebaseFirestore
        .collection('sharedAlarms')
        .doc(alarm.firestoreId)
        .get();
    
    if (alarmDoc.exists) {
      final data = alarmDoc.data() as Map<String, dynamic>;
      
      
      final offsetDetailsRaw = data['offsetDetails'];
      Map<String, dynamic> offsetDetails = {};
      
      if (offsetDetailsRaw is Map) {

        offsetDetails = Map<String, dynamic>.from(offsetDetailsRaw);
      } else if (offsetDetailsRaw is List) {

        final offsetDetailsList = List<dynamic>.from(offsetDetailsRaw);
        for (final item in offsetDetailsList) {
          if (item is Map && item.containsKey('userId')) {
            final userId = item['userId'].toString();
            offsetDetails[userId] = {
              'isOffsetBefore': item['isOffsetBefore'] ?? true,
              'offsetDuration': item['offsetDuration'] ?? 0,
              'offsettedTime': item['offsettedTime'] ?? alarm.alarmTime,
            };
          }
        }
        debugPrint('🔧 Converted offsetDetails from Array to Map format');
      }
      

      offsetDetails[currentUserId!] = {
        'isOffsetBefore': true,
        'offsetDuration': 0,
        'offsettedTime': alarm.alarmTime,
      };
      
await _firebaseFirestore
    .collection('sharedAlarms')
    .doc(alarm.firestoreId)
    .update({
        'offsetDetails': offsetDetails,
  'sharedUserIds': FieldValue.arrayUnion([currentUserId]), 
});
      
      debugPrint('✅ User $currentUserId accepted shared alarm and added to offsetDetails');
    }
  }

  static Future<AlarmModel> saveSharedAlarm(UserModel? user, AlarmModel alarmRecord) async {
    if (user == null) {
      return alarmRecord;
    }
    

    alarmRecord.isSharedAlarmEnabled = true;
    

    await _firebaseFirestore
        .collection('sharedAlarms')
        .add(AlarmModel.toMap(alarmRecord))
        .then((value) => alarmRecord.firestoreId = value.id);
    
    return alarmRecord;
  }

  static Future<void> triggerRescheduleUpdate(AlarmModel alarmData) async {
    try {


      await _firebaseFirestore
          .collection('sharedAlarms')
          .doc(alarmData.firestoreId)
          .update({
        'lastUpdated': FieldValue.serverTimestamp(),
        'lastEditedUserId': _firebaseAuthInstance.currentUser?.uid,

        'alarmTime': alarmData.alarmTime,
        'minutesSinceMidnight': alarmData.minutesSinceMidnight,
        'isEnabled': alarmData.isEnabled,
      });
      
      debugPrint('✅ Triggered Firestore update for shared alarm reschedule: ${alarmData.firestoreId}');
    } catch (e) {
      debugPrint('❌ Error triggering Firestore reschedule update: $e');
    }
  }
}