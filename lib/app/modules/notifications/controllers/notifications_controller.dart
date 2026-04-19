import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/alarm_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/providers/firestore_provider.dart';
import '../../home/controllers/home_controller.dart';
import '../../../utils/utils.dart';

class NotificationsController extends GetxController {
  //TODO: Implement NotificationsController

  late List notifications = [].obs;
  HomeController homeController = Get.find<HomeController>();
  late List allProfiles = [].obs;
  final selectedProfile = 'Default'.obs;

  @override
  void onInit() async {
    super.onInit();
    notifications = homeController.notifications;
    selectedProfile.value = homeController.selectedProfile.value;
    allProfiles = await getAllProfiles();
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

  Future importAlarm(Map notification) async {
    final alarmMap = await _resolveAlarmMap(notification);
    if (alarmMap == null) {
      Get.snackbar('Notification', 'Shared alarm data is missing');
      return;
    }
    final alarm = AlarmModel.fromMap(alarmMap);
    alarm.alarmID = Uuid().v4();
    alarm.profile = selectedProfile.value;
    await IsarDb.addAlarm(alarm);
  }

  Future<Map<String, dynamic>?> _resolveAlarmMap(Map notification) async {
    final embeddedPayload = parseAlarmPayload(notification);
    if (embeddedPayload != null) {
      return embeddedPayload;
    }

    final owner = notification['owner']?.toString();
    final alarmName =
        (notification['alarmId'] ?? notification['AlarmName'])?.toString();

    if (owner == null || alarmName == null) {
      return null;
    }

    final legacyAlarm = await FirestoreDb.receiveAlarm(owner, alarmName);
    if (legacyAlarm == null) {
      return null;
    }
    return Map<String, dynamic>.from(legacyAlarm);
  }

  static Map<String, dynamic>? parseAlarmPayload(Map notification) {
    final payload = notification['alarmData'];
    if (payload is Map) {
      return Map<String, dynamic>.from(payload as Map);
    }
    return null;
  }

  static String getAlarmLabel(Map notification) {
    final payload = parseAlarmPayload(notification);
    if (payload != null && payload['label'] is String) {
      final label = payload['label'] as String;
      if (label.trim().isNotEmpty) {
        return label;
      }
    }
    return (notification['alarmLabel'] ?? '').toString();
  }

  static String getAlarmTime(Map notification) {
    final payload = parseAlarmPayload(notification);
    if (payload != null && payload['alarmTime'] is String) {
      final time = payload['alarmTime'] as String;
      if (time.trim().isNotEmpty) {
        return time;
      }
    }
    return (notification['alarmTime'] ?? '--:--').toString();
  }

  static String getAlarmRepeat(Map notification) {
    final payload = parseAlarmPayload(notification);
    if (payload != null && payload['days'] is List) {
      final days = (payload['days'] as List)
          .map((item) => item == true)
          .toList()
          .cast<bool>();
      return Utils.getRepeatDays(days);
    }
    final fallback = notification['alarmRepeat']?.toString() ?? '';
    return fallback.isEmpty ? 'Never'.tr : fallback;
  }
}
