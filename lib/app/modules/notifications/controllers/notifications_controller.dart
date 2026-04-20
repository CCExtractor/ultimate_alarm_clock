import 'dart:convert';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../data/models/alarm_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/providers/firestore_provider.dart';
import '../../home/controllers/home_controller.dart';
import '../../../utils/utils.dart';

class NotificationsController extends GetxController {

  late List notifications = [].obs;
  HomeController homeController = Get.find<HomeController>();
  late List allProfiles = [].obs;
  final selectedProfile = 'Default'.obs;

  @override
  void onInit() async {
    super.onInit();
    debugPrint('🔔 NotificationsController onInit');
    debugPrint('   - User signed in: ${homeController.isUserSignedIn.value}');
    debugPrint('   - User model: ${homeController.userModel.value?.email ?? 'null'}');
    
    notifications = homeController.notifications;
    selectedProfile.value = homeController.selectedProfile.value;
    allProfiles = await getAllProfiles();
    
    debugPrint('   - Initial notifications count: ${notifications.length}');
  }

  Future getAllProfiles() async {
    List allProfiles = await IsarDb.getProfileList();
    return allProfiles;
  }

  Future importProfile(String email, String profileName) async {
    final profileSet = await FirestoreDb.receiveProfile(email, profileName);
    final profile = ProfileModel.fromMap(profileSet['profileData']);
    final List alarmList = profileSet['alarmData'];
    final isPresent = await IsarDb.profileExists(profileName);
    if (isPresent) {
      profile.profileName = '${profile.profileName}(dup)';
      await IsarDb.addProfile(profile);
      for (final alarm in alarmList) {
        final a = AlarmModel.fromMap(alarm);
        a.profile = profile.profileName;
        a.alarmID = Uuid().v4();
        await IsarDb.addAlarm(a);
      }
    } else {
      await IsarDb.addProfile(profile);
      for (final alarm in alarmList) {
        final a = AlarmModel.fromMap(alarm);
        a.alarmID = Uuid().v4();
        await IsarDb.addAlarm(a);
      }
    }
  }

  // Function to import alarm settings that's shared
  Future importAlarm(String email, String alarmName) async {
    final alarmMap = await FirestoreDb.receiveAlarm(email, alarmName);
    final alarm = await AlarmModel.fromMap(alarmMap);
    alarm.alarmID = Uuid().v4();
    alarm.profile = selectedProfile.value;
    await IsarDb.addAlarm(alarm);
  }

    Future acceptSharedALarm(String alarmOwnerId, String alarmId) async {
    try {
    final alarmMap = await FirestoreDb.receiveAlarm(alarmOwnerId, alarmId);
      final alarm = AlarmModel.fromMap(alarmMap);
    alarm.alarmID = Uuid().v4();
    alarm.profile = selectedProfile.value;
      
      // Accept the shared alarm in Firestore
    await FirestoreDb.acceptSharedAlarm(alarmOwnerId, alarm);
      
      // IMPORTANT: Immediately schedule the shared alarm on this device
      await scheduleAcceptedSharedAlarm(alarm);
      
      debugPrint('✅ Successfully accepted and scheduled shared alarm: ${alarm.alarmTime}');
    } catch (e) {
      debugPrint('❌ Error accepting shared alarm: $e');
      rethrow;
    }
  }

  /// Schedules a shared alarm immediately after acceptance
  Future<void> scheduleAcceptedSharedAlarm(AlarmModel alarm) async {
    try {
      // Calculate time to alarm
      TimeOfDay alarmTimeOfDay = Utils.stringToTimeOfDay(alarm.alarmTime);
      DateTime alarmDateTime = Utils.timeOfDayToDateTime(alarmTimeOfDay);
      int intervalToAlarm = Utils.getMillisecondsToAlarm(DateTime.now(), alarmDateTime);
      
      if (intervalToAlarm <= 0) {
        debugPrint('⏰ Accepted shared alarm time is in the past, not scheduling: ${alarm.alarmTime}');
        return;
      }
      
      debugPrint('📅 Scheduling accepted shared alarm: ${alarm.alarmTime} (${intervalToAlarm}ms from now)');
      
      // Get the home controller to access the alarm channel
      final homeController = Get.find<HomeController>();
      
      // Schedule the alarm via native code
      await homeController.alarmChannel.invokeMethod('scheduleAlarm', {
        'isSharedAlarm': true,
        'isActivityEnabled': alarm.isActivityEnabled,
        'isLocationEnabled': alarm.isLocationEnabled,
        'locationConditionType': alarm.locationConditionType,
        'isWeatherEnabled': alarm.isWeatherEnabled,
        'weatherConditionType': alarm.weatherConditionType,
        'intervalToAlarm': intervalToAlarm,
        'location': alarm.location,
        'weatherTypes': jsonEncode(alarm.weatherTypes),
        'alarmID': alarm.firestoreId ?? '',
        'smartControlCombinationType': alarm.smartControlCombinationType,
      });
      
      // Update the home controller's shared alarm cache
      await homeController.updateSharedAlarmCache(alarm, intervalToAlarm);
      
      // Update tracking in home controller
      homeController.lastScheduledAlarmId = alarm.firestoreId ?? '';
      homeController.lastScheduledAlarmTime = alarmTimeOfDay;
      homeController.lastScheduledAlarmIsShared = true;
      
      debugPrint('✅ Successfully scheduled accepted shared alarm: ${alarm.alarmTime}');
      
      // Show confirmation to user
      Get.snackbar(
        'Shared Alarm Accepted! 🔔',
        'The alarm will ring at ${alarm.alarmTime}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 30,
        ),
      );
      
    } catch (e) {
      debugPrint('❌ Error scheduling accepted shared alarm: $e');
      
      // Show error to user
      Get.snackbar(
        'Error',
        'Failed to schedule the shared alarm. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      rethrow;
    }
  }
}

