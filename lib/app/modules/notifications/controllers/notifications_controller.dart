import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/alarm_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/providers/firestore_provider.dart';
import '../../home/controllers/home_controller.dart';

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

  Future importAlarm(String email, String alarmName) async {
    final alarmMap = await FirestoreDb.receiveAlarm(email, alarmName);
    final alarm = await AlarmModel.fromMap(alarmMap);
    alarm.alarmID = Uuid().v4();
    alarm.profile = selectedProfile.value;
    await IsarDb.addAlarm(alarm);
  }
}
