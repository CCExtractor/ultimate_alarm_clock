import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/uac_text_button.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../settings/controllers/theme_controller.dart';

class SaveOrUpdateButton extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const SaveOrUpdateButton({
    super.key,
    required this.controller,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: height * 0.06,
        width: width * 0.8,
        child: UACTextButton(
          isButtonPrimary: true,
          isTextPrimary: false,
          text: (controller.alarmRecord.value.alarmID == '')
              ? 'Save'.tr
              : 'Update'.tr,
          onPressed: () async {
            Utils.hapticFeedback();
            await controller.checkOverlayPermissionAndNavigate();

            if ((await Permission.systemAlertWindow.isGranted) &&
                (await Permission.ignoreBatteryOptimizations.isGranted)) {
              if (!controller.homeController.isProfile.value) {
                if (controller.userModel.value != null) {
                  controller.offsetDetails[controller.userModel.value!.id] = {
                    'offsettedTime': Utils.timeOfDayToString(
                      TimeOfDay.fromDateTime(
                        Utils.calculateOffsetAlarmTime(
                          controller.selectedTime.value,
                          controller.isOffsetBefore.value,
                          controller.offsetDuration.value,
                        ),
                      ),
                    ),
                    'offsetDuration': controller.offsetDuration.value,
                    'isOffsetBefore': controller.isOffsetBefore.value,
                  };
                } else {
                  controller.offsetDetails.value = {};
                }
                AlarmModel alarmRecord = AlarmModel(
                  deleteAfterGoesOff: controller.deleteAfterGoesOff.value,
                  snoozeDuration: controller.snoozeDuration.value,
                  volMax: controller.volMax.value,
                  volMin: controller.volMin.value,
                  gradient: controller.gradient.value,
                  offsetDetails: controller.offsetDetails,
                  label: controller.label.value,
                  note: controller.note.value,
                  showMotivationalQuote: controller.showMotivationalQuote.value,
                  isOneTime: controller.isOneTime.value,
                  lastEditedUserId: controller.lastEditedUserId.value,
                  mutexLock: controller.mutexLock.value,
                  alarmID: controller.alarmID,
                  ownerId: controller.ownerId.value,
                  ownerName: controller.ownerName.value,
                  activityInterval: controller.activityInterval.value * 60000,
                  days: controller.repeatDays.toList(),
                  alarmTime: Utils.timeOfDayToString(
                    TimeOfDay.fromDateTime(
                      controller.selectedTime.value,
                    ),
                  ),
                  mainAlarmTime: Utils.timeOfDayToString(
                    TimeOfDay.fromDateTime(
                      controller.selectedTime.value,
                    ),
                  ),
                  intervalToAlarm: Utils.getMillisecondsToAlarm(
                    DateTime.now(),
                    controller.selectedTime.value,
                  ),
                  isActivityEnabled: controller.isActivityenabled.value,
                  minutesSinceMidnight: Utils.timeOfDayToInt(
                    TimeOfDay.fromDateTime(
                      controller.selectedTime.value,
                    ),
                  ),
                  isLocationEnabled: controller.isLocationEnabled.value,
                  weatherTypes: Utils.getIntFromWeatherTypes(
                    controller.selectedWeather.toList(),
                  ),
                  isWeatherEnabled: controller.isWeatherEnabled.value,
                  location: Utils.geoPointToString(
                    Utils.latLngToGeoPoint(
                      controller.selectedPoint.value,
                    ),
                  ),
                  isSharedAlarmEnabled: controller.isSharedAlarmEnabled.value,
                  isQrEnabled: controller.isQrEnabled.value,
                  qrValue: controller.qrValue.value,
                  isMathsEnabled: controller.isMathsEnabled.value,
                  numMathsQuestions: controller.numMathsQuestions.value,
                  mathsDifficulty: controller.mathsDifficulty.value.index,
                  isShakeEnabled: controller.isShakeEnabled.value,
                  shakeTimes: controller.shakeTimes.value,
                  isPedometerEnabled: controller.isPedometerEnabled.value,
                  numberOfSteps: controller.numberOfSteps.value,
                  ringtoneName: controller.customRingtoneName.value,
                  activityMonitor: controller.isActivityMonitorenabled.value,
                  alarmDate:
                      controller.selectedDate.value.toString().substring(0, 11),
                  profile: controller.homeController.selectedProfile.value,
                  isGuardian: controller.isGuardian.value,
                  guardianTimer: 0,
                  guardian: controller.contactTextEditingController.text,
                  isCall: controller.isCall.value,
                  ringOn: controller.isFutureDate.value,
                );

                // Adding offset details to the database if
                // its a shared alarm
                if (controller.isSharedAlarmEnabled.value) {
                  alarmRecord.offsetDetails = controller.offsetDetails;
                  alarmRecord.mainAlarmTime = Utils.timeOfDayToString(
                    TimeOfDay.fromDateTime(
                      controller.selectedTime.value,
                    ),
                  );
                }
                try {
                  if (controller.alarmRecord.value.alarmID == '') {
                    await controller.createAlarm(alarmRecord);
                  } else {
                    AlarmModel updatedAlarmModel =
                        controller.updatedAlarmModel();
                    await controller.updateAlarm(updatedAlarmModel);
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              } else {
                controller.createProfile();
              }
            }
          },
        ),
      ),
    );
  }
}
