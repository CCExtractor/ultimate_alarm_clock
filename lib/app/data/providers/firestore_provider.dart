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
    int nowInMinutes = 0;
    if (wantNextAlarm == true) {
      nowInMinutes = Utils.timeOfDayToInt(TimeOfDay(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1));
    } else {
      nowInMinutes = Utils.timeOfDayToInt(TimeOfDay(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1));
    }

    late List<AlarmModel> alarms;

    // Get all enabled alarms
    QuerySnapshot snapshot =
        await _alarmsCollection(user).where('isEnabled', isEqualTo: true).get();
    alarms = snapshot.docs.map((DocumentSnapshot document) {
      return AlarmModel.fromDocumentSnapshot(documentSnapshot: document);
    }).toList();

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

        // If alarm is one-time and has already passed, set time until next alarm to next day
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

  static updateAlarm(UserModel? user, AlarmModel alarmRecord) async {
    if (user == null) return alarmRecord;
    await _alarmsCollection(user)
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
          .snapshots();
      // Stream<QuerySnapshot<Object?>> sharedAlarmsStream =
      //     _alarmsCollection(user)
      //         .orderBy('minutesSinceMidnight', descending: false)
      //         .snapshots();
      Stream<QuerySnapshot<Object?>> userAlarmsStream = _alarmsCollection(user)
          .orderBy('minutesSinceMidnight', descending: false)
          .snapshots();
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
}
