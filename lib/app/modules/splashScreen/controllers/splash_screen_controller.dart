import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SplashScreenController extends GetxController {
  MethodChannel alarmChannel = MethodChannel('ulticlock');

  getCurrentlyRingingAlarm() async {
    UserModel? _userModel = await SecureStorageProvider().retrieveUserModel();
    AlarmModel _alarmRecord = Utils.genFakeAlarmModel();
    AlarmModel isarLatestAlarm =
        await IsarDb.getLatestAlarm(_alarmRecord, false);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_userModel, _alarmRecord, false);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);
    debugPrint('CURRENT RINGING : ${latestAlarm.alarmTime}');

    return latestAlarm;
  }

  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      AlarmModel test = await getCurrentlyRingingAlarm();
      print("MAIN SAYS: ${test.isEnabled} ${test.alarmTime}");
      if (test.isEnabled &&
          test.alarmTime == Utils.timeOfDayToString(TimeOfDay.now())) {
        Get.offNamed('/alarm-ring');
      } else {
        Get.offNamed('/home');
      }
    });
    super.onInit();
  }
}
