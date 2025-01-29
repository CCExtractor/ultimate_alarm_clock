import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class SaveUpdateButton extends StatelessWidget {
  const SaveUpdateButton({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: height * 0.06,
        width: width * 0.8,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kprimaryColor),
          ),
          child: _buildButtonText(context),
          onPressed: () async {
            Utils.hapticFeedback();
            await _handlePermissionAndNavigate();

            if (await _checkPermissions()) {
              if (!controller.homeController.isProfile.value) {
                await _saveOrUpdateAlarm();
              } else {
                _createProfileIfNeeded();
              }
            }
          },
        ),
      ),
    );
  }

  Text _buildButtonText(BuildContext context) {
    return Text(
      controller.alarmRecord.value.alarmID == '' ? 'Save'.tr : 'Update'.tr,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: themeController.secondaryTextColor.value,
          ),
    );
  }

  Future<bool> _checkPermissions() async {
    final isSystemAlertWindowGranted =
        await Permission.systemAlertWindow.isGranted;
    final isBatteryOptimizationGranted =
        await Permission.ignoreBatteryOptimizations.isGranted;

    return isSystemAlertWindowGranted && isBatteryOptimizationGranted;
  }

  Future<void> _handlePermissionAndNavigate() async {
    await controller.checkOverlayPermissionAndNavigate();
  }

  Future<void> _saveOrUpdateAlarm() async {
    if (controller.userModel.value != null) {
      _setOffsetDetails();
    } else {
      controller.offsetDetails.value = {};
    }

    try {
      final alarmRecord = _createAlarmRecord();

      if (controller.alarmRecord.value.alarmID == '') {
        await controller.createAlarm(alarmRecord);
      } else {
        final updatedAlarmModel = controller.updatedAlarmModel();
        await controller.updateAlarm(updatedAlarmModel);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _setOffsetDetails() {
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
  }

  AlarmModel _createAlarmRecord() {
    return AlarmModel(
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
        TimeOfDay.fromDateTime(controller.selectedTime.value),
      ),
      mainAlarmTime: Utils.timeOfDayToString(
        TimeOfDay.fromDateTime(controller.selectedTime.value),
      ),
      intervalToAlarm: Utils.getMillisecondsToAlarm(
        DateTime.now(),
        controller.selectedTime.value,
      ),
      isActivityEnabled: controller.isActivityenabled.value,
      minutesSinceMidnight: Utils.timeOfDayToInt(
        TimeOfDay.fromDateTime(controller.selectedTime.value),
      ),
      isLocationEnabled: controller.isLocationEnabled.value,
      weatherTypes: Utils.getIntFromWeatherTypes(
        controller.selectedWeather.toList(),
      ),
      isWeatherEnabled: controller.isWeatherEnabled.value,
      location: Utils.geoPointToString(
        Utils.latLngToGeoPoint(controller.selectedPoint.value),
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
      alarmDate: controller.selectedDate.value.toString().substring(0, 11),
      profile: controller.homeController.selectedProfile.value,
      isGuardian: controller.isGuardian.value,
      guardianTimer: 0,
      guardian: controller.contactTextEditingController.text,
      isCall: controller.isCall.value,
      ringOn: controller.isFutureDate.value,
    );
  }

  void _createProfileIfNeeded() {
    if (controller.profileTextEditingController.text.isNotEmpty) {
      controller.createProfile();
    }
  }
}
