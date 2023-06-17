import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class FirestoreDb {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

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
    final DocumentReference docRef = _usersCollection.doc(userModel.id);
    await docRef.set(userModel.toJson());
  }

  static addAlarm(UserModel? user, AlarmModel alarmRecord) async {
    if (user == null) return alarmRecord;
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
      UserModel? user, String time) async {
    if (user == null) return Utils.genFakeAlarmModel();
    QuerySnapshot snapshot = await _alarmsCollection(user)
        .where('isEnabled', isEqualTo: true)
        .where('alarmTime', isEqualTo: time)
        .get();

    List list = snapshot.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
    }).toList();

    return list[0];
  }

  static Future<AlarmModel> getLatestAlarm(
      UserModel? user, AlarmModel alarmRecord, bool wantNextAlarm) async {
    if (user == null) return alarmRecord;

    // Get all alarms
    QuerySnapshot snapshot = await getAlarms(user).first;
    List<AlarmModel> alarms = snapshot.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
    }).toList();

    if (alarms.isEmpty) {
      alarmRecord.minutesSinceMidnight = -1;
      return alarmRecord;
    } else {
      // Get the current time in minutes
      int nowInMinutes = Utils.timeOfDayToInt(TimeOfDay.now());

      // Filter out disabled alarms
      List<AlarmModel> enabledAlarms =
          alarms.where((alarm) => alarm.isEnabled).toList();

      if (enabledAlarms.isEmpty) {
        alarmRecord.minutesSinceMidnight = -1;
        return alarmRecord;
      }

      // Sort alarms by their time
      enabledAlarms.sort(
          (a, b) => a.minutesSinceMidnight.compareTo(b.minutesSinceMidnight));

      // Find the latest alarm
      AlarmModel? latestAlarm;

      if (wantNextAlarm) {
        for (var alarm in enabledAlarms) {
          if (alarm.minutesSinceMidnight > nowInMinutes) {
            latestAlarm = alarm;
            break;
          }
        }
      } else {
        for (var i = enabledAlarms.length - 1; i >= 0; i--) {
          if (enabledAlarms[i].minutesSinceMidnight < nowInMinutes) {
            latestAlarm = enabledAlarms[i];
            break;
          }
        }
      }

      // If no latest alarm is found, use the first or last alarm depending on wantNextAlarm
      latestAlarm ??= wantNextAlarm ? enabledAlarms.first : enabledAlarms.last;

      return latestAlarm ?? alarmRecord;
    }
  }

  static updateAlarm(String? userId, AlarmModel alarmRecord) async {
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('alarms')
        .doc(alarmRecord.firestoreId)
        .update(AlarmModel.toMap(alarmRecord));
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

  static Stream<QuerySnapshot<Object?>> getAlarms(UserModel? user) {
    if (user != null) {
      Stream<QuerySnapshot<Object?>> sharedAlarmsStream = _firebaseFirestore
          .collectionGroup('alarms')
          .where('sharedUserIds', arrayContains: user.id)
          .snapshots(includeMetadataChanges: true);

      Stream<QuerySnapshot<Object?>> userAlarmsStream = _alarmsCollection(user)
          .orderBy('minutesSinceMidnight', descending: false)
          .snapshots(includeMetadataChanges: true);

      return StreamGroup.merge([sharedAlarmsStream, userAlarmsStream]);
    } else {
      return _alarmsCollection(user)
          .orderBy('minutesSinceMidnight', descending: false)
          .snapshots();
    }
  }

  static deleteAlarm(UserModel? user, String id) async {
    await _alarmsCollection(user).doc(id).delete();
  }

  static Future<bool> addUserToAlarmSharedUsers(
      UserModel? userModel, String alarmID) async {
    String userModelId = userModel!.id;

    final alarmQuerySnapshot = await _firebaseFirestore
        .collectionGroup('alarms')
        .where('alarmID', isEqualTo: alarmID)
        .get();

    if (alarmQuerySnapshot.size == 0) {
      return false;
    }
    final alarmDoc = alarmQuerySnapshot.docs[0];
    final sharedUserIds =
        List<String>.from(alarmDoc.data()['sharedUserIds'] ?? []);

    if (!sharedUserIds.contains(userModelId)) {
      sharedUserIds.add(userModelId);
      await alarmDoc.reference.update({'sharedUserIds': sharedUserIds});
    }
    return true;
  }

  static Future<List<String>> removeUserFromAlarmSharedUsers(
      UserModel? userModel, String alarmID) async {
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
}
