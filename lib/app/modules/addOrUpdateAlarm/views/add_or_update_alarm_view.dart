import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/alarm_id_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/alarm_offset_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/label_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/location_activity_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/maths_challenge_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/qr_bar_code_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/repeat_once_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/repeat_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/screen_activity_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shake_to_dismiss_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_alarm_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_users_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/snooze_duration_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/weather_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import '../controllers/add_or_update_alarm_controller.dart';

class AddOrUpdateAlarmView extends GetView<AddOrUpdateAlarmController> {
  AddOrUpdateAlarmView({Key? key}) : super(key: key);

  final HapticFeedbackController hapticFeedbackController =
      Get.find<HapticFeedbackController>();

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return WithForegroundTask(
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: (controller.alarmRecord != null &&
                  controller.mutexLock.value == true)
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    height: height * 0.06,
                    width: width * 0.8,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor)),
                      child: Text(
                        (controller.alarmRecord == null) ? 'Save' : 'Update',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: ksecondaryTextColor),
                      ),
                      onPressed: () async {
                        hapticFeedbackController.hapticFeedback();
                        if (controller.userModel != null) {
                          controller.offsetDetails[controller.userModel!.id] = {
                            'offsettedTime': Utils.timeOfDayToString(
                                TimeOfDay.fromDateTime(
                                    Utils.calculateOffsetAlarmTime(
                                        controller.selectedTime.value,
                                        controller.isOffsetBefore.value,
                                        controller.offsetDuration.value))),
                            'offsetDuration': controller.offsetDuration.value,
                            'isOffsetBefore': controller.isOffsetBefore.value,
                          };
                        } else {
                          controller.offsetDetails.value = {};
                        }
                        AlarmModel alarmRecord = AlarmModel(
                            snoozeDuration: controller.snoozeDuration.value,
                            offsetDetails: controller.offsetDetails,
                            label: controller.label.value,
                            isOneTime: controller.isOneTime.value,
                            lastEditedUserId: controller.lastEditedUserId,
                            mutexLock: controller.mutexLock.value,
                            alarmID: controller.alarmID,
                            ownerId: controller.ownerId,
                            ownerName: controller.ownerName,
                            activityInterval:
                                controller.activityInterval.value * 60000,
                            days: controller.repeatDays.toList(),
                            alarmTime: Utils.timeOfDayToString(
                                TimeOfDay.fromDateTime(
                                    controller.selectedTime.value)),
                            mainAlarmTime: Utils.timeOfDayToString(
                                TimeOfDay.fromDateTime(
                                    controller.selectedTime.value)),
                            intervalToAlarm: Utils.getMillisecondsToAlarm(
                                DateTime.now(), controller.selectedTime.value),
                            isActivityEnabled:
                                controller.isActivityenabled.value,
                            minutesSinceMidnight: Utils.timeOfDayToInt(
                                TimeOfDay.fromDateTime(
                                    controller.selectedTime.value)),
                            isLocationEnabled: controller.isLocationEnabled.value,
                            weatherTypes: Utils.getIntFromWeatherTypes(controller.selectedWeather.toList()),
                            isWeatherEnabled: controller.isWeatherEnabled.value,
                            location: Utils.geoPointToString(
                              Utils.latLngToGeoPoint(
                                  controller.selectedPoint.value),
                            ),
                            isSharedAlarmEnabled: controller.isSharedAlarmEnabled.value,
                            isQrEnabled: controller.isQrEnabled.value,
                            qrValue: controller.qrValue.value,
                            isMathsEnabled: controller.isMathsEnabled.value,
                            numMathsQuestions: controller.numMathsQuestions.value,
                            mathsDifficulty: controller.mathsDifficulty.value.index,
                            isShakeEnabled: controller.isShakeEnabled.value,
                            shakeTimes: controller.shakeTimes.value);

                        // Adding offset details to the database if its a shared alarm
                        if (controller.isSharedAlarmEnabled.value) {
                          alarmRecord.offsetDetails = controller.offsetDetails;
                          alarmRecord.mainAlarmTime = Utils.timeOfDayToString(
                              TimeOfDay.fromDateTime(
                                  controller.selectedTime.value));
                        }

                        try {
                          if (controller.alarmRecord == null) {
                            await controller.createAlarm(alarmRecord);
                          } else {
                            AlarmModel updatedAlarmModel =
                                controller.updatedAlarmModel();
                            await controller.updateAlarm(updatedAlarmModel);
                          }
                        } catch (e) {
                          print(e);
                        }

                        await controller.checkOverlayPermissionAndNavigate();
                      },
                    ),
                  ),
                ),
          appBar: AppBar(
            backgroundColor: (controller.alarmRecord != null &&
                    controller.mutexLock.value == true)
                ? kprimaryBackgroundColor
                : ksecondaryBackgroundColor,
            elevation: 0.0,
            centerTitle: true,
            title: (controller.alarmRecord != null &&
                    controller.mutexLock.value == true)
                ? const Text('')
                : Obx(
                    () => Text(
                      "Rings in ${controller.timeToAlarm.value}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
          ),
          body: (controller.alarmRecord != null &&
                  controller.mutexLock.value == true)
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Uh-oh!',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: kprimaryDisabledTextColor),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/locked.svg',
                      height: height * 0.24,
                      width: width * 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'This alarm is currently being edited!',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: kprimaryDisabledTextColor),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor)),
                      child: Text(
                        'Go back',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: ksecondaryTextColor),
                      ),
                      onPressed: () {
                        hapticFeedbackController.hapticFeedback();
                        Get.back();
                      },
                    )
                  ],
                ))
              : ListView(
                  children: [
                    Container(
                      color: ksecondaryBackgroundColor,
                      height: height * 0.32,
                      width: width,
                      child: TimePickerSpinner(
                        time: controller.selectedTime.value,
                        isForce2Digits: true,
                        alignment: Alignment.center,
                        is24HourMode: false,
                        normalTextStyle: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontWeight: FontWeight.normal,
                                color: kprimaryDisabledTextColor),
                        highlightedTextStyle:
                            Theme.of(context).textTheme.displayMedium,
                        onTimeChange: (dateTime) {
                          hapticFeedbackController.hapticFeedback();
                          controller.selectedTime.value = dateTime;
                        },
                      ),
                    ),
                    RepeatTile(controller: controller, hapticFeedbackController: hapticFeedbackController,),
                    Container(
                      color: ksecondaryBackgroundColor,
                      child: const Divider(
                        color: kprimaryDisabledTextColor,
                      ),
                    ),
                    RepeatOnceTile(controller: controller, hapticFeedbackController: hapticFeedbackController,),
                    Container(
                      color: ksecondaryBackgroundColor,
                      child: const Divider(
                        color: kprimaryDisabledTextColor,
                      ),
                    ),
                    SnoozeDurationTile(controller: controller, hapticFeedbackController: hapticFeedbackController,),
                    Container(
                      color: ksecondaryBackgroundColor,
                      child: const Divider(
                        color: kprimaryDisabledTextColor,
                      ),
                    ),
                    LabelTile(controller: controller, hapticFeedbackController: hapticFeedbackController,),
                    Container(
                      color: ksecondaryTextColor,
                      height: 10,
                      width: width,
                    ),
                    Container(
                      color: ksecondaryBackgroundColor,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text('Automatic Cancellation',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: kprimaryTextColor
                                                .withOpacity(0.85))),
                              ),
                            ),
                            ScreenActivityTile(
                              controller: controller, hapticFeedbackController: hapticFeedbackController,
                            ),
                            const Divider(
                              color: kprimaryDisabledTextColor,
                            ),
                            WeatherTile(
                              controller: controller, hapticFeedbackController: hapticFeedbackController,
                            ),
                            const Divider(
                              color: kprimaryDisabledTextColor,
                            ),
                            LocationTile(
                                controller: controller,
                                height: height,
                                width: width, hapticFeedbackController: hapticFeedbackController,)
                          ]),
                    ),
                    Container(
                      color: ksecondaryTextColor,
                      height: 10,
                      width: width,
                    ),
                    Container(
                      color: ksecondaryBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text('Challenges',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: kprimaryTextColor
                                              .withOpacity(0.85))),
                            ),
                          ),
                          ShakeToDismiss(
                            controller: controller, hapticFeedbackController: hapticFeedbackController,
                          ),
                          const Divider(
                            color: kprimaryDisabledTextColor,
                          ),
                          QrBarCode(controller: controller, hapticFeedbackController: hapticFeedbackController,),
                          const Divider(
                            color: kprimaryDisabledTextColor,
                          ),
                          MathsChallenge(
                            controller: controller, hapticFeedbackController: hapticFeedbackController,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: ksecondaryTextColor,
                      height: 10,
                      width: width,
                    ),
                    Container(
                      color: ksecondaryBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text('Shared Alarm',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: kprimaryTextColor
                                              .withOpacity(0.85))),
                            ),
                          ),
                          SharedAlarm(
                            controller: controller, hapticFeedbackController: hapticFeedbackController,
                          ),
                          const Divider(
                            color: kprimaryDisabledTextColor,
                          ),
                          AlarmIDTile(controller: controller, width: width, hapticFeedbackController: hapticFeedbackController,),
                          Obx(
                            () => Container(
                              child: (controller.isSharedAlarmEnabled.value)
                                  ? const Divider(
                                      color: kprimaryDisabledTextColor,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          AlarmOffset(
                            controller: controller, hapticFeedbackController: hapticFeedbackController,
                          ),
                          Obx(
                            () => Container(
                              child: (controller.isSharedAlarmEnabled.value &&
                                      controller.alarmRecord != null)
                                  ? const Divider(
                                      color: kprimaryDisabledTextColor,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          SharedUsers(controller: controller, hapticFeedbackController: hapticFeedbackController,),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.15,
                    )
                  ],
                )),
    );
  }
}
