import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/input_time_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/alarm_id_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/alarm_offset_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/choose_ringtone_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/delete_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/label_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/location_activity_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/maths_challenge_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/note.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/qr_bar_code_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/repeat_once_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/repeat_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/screen_activity_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shake_to_dismiss_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_alarm_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_users_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/snooze_duration_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/weather_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import '../controllers/add_or_update_alarm_controller.dart';

class AddOrUpdateAlarmView extends GetView<AddOrUpdateAlarmController> {
  AddOrUpdateAlarmView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();
  InputTimeController inputTimeController = Get.put(InputTimeController());
  SettingsController settingsController = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }

          Get.defaultDialog(
            titlePadding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            backgroundColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            title: 'Discard Changes?',
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Column(
              children: [
                Text(
                  'You have unsaved changes. Are you sure you want to leave this'
                  ' page?',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: kprimaryBackgroundColor,
                              ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Get.offNamedUntil(
                            '/home',
                            (route) => route.settings.name == '/splash-screen',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: themeController.isLightMode.value
                                ? Colors.red.withOpacity(0.9)
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Leave',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? Colors.red.withOpacity(0.9)
                                    : Colors.red,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
                            MaterialStateProperty.all(kprimaryColor),
                      ),
                      child: Text(
                        (controller.alarmRecord == null) ? 'Save' : 'Update',
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryTextColor
                                      : ksecondaryTextColor,
                                ),
                      ),
                      onPressed: () async {
                        Utils.hapticFeedback();
                        if (controller.userModel != null) {
                          controller.offsetDetails[controller.userModel!.id] = {
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
                          snoozeDuration: controller.snoozeDuration.value,
                          offsetDetails: controller.offsetDetails,
                          label: controller.label.value,
                          note: controller.note.value,
                          isOneTime: controller.isOneTime.value,
                          lastEditedUserId: controller.lastEditedUserId,
                          mutexLock: controller.mutexLock.value,
                          alarmID: controller.alarmID,
                          ownerId: controller.ownerId,
                          ownerName: controller.ownerName,
                          deleteAfterGoesOff:
                              controller.deleteAfterGoesOff.value,
                          activityInterval:
                              controller.activityInterval.value * 60000,
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
                          isSharedAlarmEnabled:
                              controller.isSharedAlarmEnabled.value,
                          isQrEnabled: controller.isQrEnabled.value,
                          qrValue: controller.qrValue.value,
                          isMathsEnabled: controller.isMathsEnabled.value,
                          numMathsQuestions: controller.numMathsQuestions.value,
                          mathsDifficulty:
                              controller.mathsDifficulty.value.index,
                          isShakeEnabled: controller.isShakeEnabled.value,
                          shakeTimes: controller.shakeTimes.value,
                          ringtoneName: controller.customRingtoneName.value,
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
                          if (controller.alarmRecord == null) {
                            await controller.createAlarm(alarmRecord);
                          } else {
                            AlarmModel updatedAlarmModel =
                                controller.updatedAlarmModel();
                            await controller.updateAlarm(updatedAlarmModel);
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }

                        await controller.checkOverlayPermissionAndNavigate();
                      },
                    ),
                  ),
                ),
          appBar: AppBar(
            backgroundColor: (controller.alarmRecord != null &&
                    controller.mutexLock.value == true)
                ? themeController.isLightMode.value
                    ? kLightPrimaryBackgroundColor
                    : kprimaryBackgroundColor
                : themeController.isLightMode.value
                    ? kLightSecondaryBackgroundColor
                    : ksecondaryBackgroundColor,
            elevation: 0.0,
            centerTitle: true,
            iconTheme: Theme.of(context).iconTheme,
            title: (controller.alarmRecord != null &&
                    controller.mutexLock.value == true)
                ? const Text('')
                : Obx(
                    () => Text(
                      'Rings in ${controller.timeToAlarm.value}',
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
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryDisabledTextColor
                                    : kprimaryDisabledTextColor,
                              ),
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
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryDisabledTextColor
                                    : kprimaryDisabledTextColor,
                              ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          'Go back',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightSecondaryTextColor
                                    : ksecondaryTextColor,
                              ),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          Get.back();
                        },
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    Container(
                        color: themeController.isLightMode.value
                            ? kLightSecondaryBackgroundColor
                            : ksecondaryBackgroundColor,
                        height: height * 0.32,
                        width: width,
                        child: Obx(() {
                          return InkWell(
                            onTap: () {
                              Utils.hapticFeedback();
                              inputTimeController.changeDatePicker();
                            },
                            child: inputTimeController.isTimePicker.value
                                ? TimePickerSpinner(
                                    time: controller.selectedTime.value,
                                    isForce2Digits: true,
                                    alignment: Alignment.center,
                                    is24HourMode:
                                        settingsController.is24HrsEnabled.value,
                                    normalTextStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                    highlightedTextStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                    onTimeChange: (dateTime) {
                                      Utils.hapticFeedback();
                                      controller.selectedTime.value = dateTime;
                                      inputTimeController.inputHrsController
                                          .text = settingsController
                                              .is24HrsEnabled.value
                                          ? dateTime.hour.toString()
                                          : (dateTime.hour == 0
                                              ? 12.toString()
                                              : (dateTime.hour > 12
                                                  ? (dateTime.hour - 12)
                                                      .toString()
                                                  : dateTime.hour.toString()));
                                      inputTimeController.inputMinutesController
                                          .text = dateTime.minute.toString();
                                      inputTimeController.changePeriod(
                                          dateTime.hour >= 12 ? 'PM' : 'AM');
                                    },
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: TextField(
                                          onChanged: (_) {
                                            inputTimeController.setTime();
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'HH',
                                              border: InputBorder.none),
                                          textAlign: TextAlign.center,
                                          controller: inputTimeController
                                              .inputHrsController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    '[1,2,3,4,5,6,7,8,9,0]')),
                                            LengthLimitingTextInputFormatter(2),
                                            LimitRange(
                                                0,
                                                settingsController
                                                        .is24HrsEnabled.value
                                                    ? 23
                                                    : 12)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                        child: Text(
                                          ':',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: TextField(
                                          onChanged: (_) {
                                            inputTimeController.setTime();
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'MM',
                                              border: InputBorder.none),
                                          textAlign: TextAlign.center,
                                          controller: inputTimeController
                                              .inputMinutesController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    '[1,2,3,4,5,6,7,8,9,0]')),
                                            LengthLimitingTextInputFormatter(2),
                                            LimitRange(00, 59)
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Visibility(
                                        visible: !settingsController
                                            .is24HrsEnabled.value,
                                        child: DropdownButton(
                                          underline: Container(),
                                          value: inputTimeController.isAM.value
                                              ? 'AM'
                                              : 'PM',
                                          dropdownColor:
                                              themeController.isLightMode.value
                                                  ? kLightPrimaryBackgroundColor
                                                  : kprimaryBackgroundColor,
                                          items:
                                              ['AM', 'PM'].map((String period) {
                                            return DropdownMenuItem<String>(
                                              value: period,
                                              child: Text(period),
                                            );
                                          }).toList(),
                                          onChanged: (getPeriod) {
                                            inputTimeController
                                                .changePeriod(getPeriod!);

                                            inputTimeController.setTime();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                          );
                        })),
                    RepeatTile(
                      controller: controller,
                      themeController: themeController,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      child: Divider(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryDisabledTextColor
                            : kprimaryDisabledTextColor,
                      ),
                    ),
                    Obx(() => (!controller.repeatDays
                            .every((element) => element == false))
                        ? RepeatOnceTile(
                            controller: controller,
                            themeController: themeController,
                          )
                        : const SizedBox()),
                    Obx(() => (!controller.repeatDays
                            .every((element) => element == false))
                        ? Container(
                            color: themeController.isLightMode.value
                                ? kLightSecondaryBackgroundColor
                                : ksecondaryBackgroundColor,
                            child: Divider(
                              color: themeController.isLightMode.value
                                  ? kLightPrimaryDisabledTextColor
                                  : kprimaryDisabledTextColor,
                            ),
                          )
                        : const SizedBox()),
                    SnoozeDurationTile(
                      controller: controller,
                      themeController: themeController,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      child: Divider(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryDisabledTextColor
                            : kprimaryDisabledTextColor,
                      ),
                    ),
                    Obx(
                      () => (controller.repeatDays
                              .every((element) => element == false))
                          ? DeleteAfterGoesOff(
                              controller: controller,
                              themeController: themeController,
                            )
                          : const SizedBox(),
                    ),
                    Obx(
                      () => (controller.repeatDays
                              .every((element) => element == false))
                          ? Container(
                              color: themeController.isLightMode.value
                                  ? kLightSecondaryBackgroundColor
                                  : ksecondaryBackgroundColor,
                              child: Divider(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryDisabledTextColor
                                    : kprimaryDisabledTextColor,
                              ),
                            )
                          : const SizedBox(),
                    ),
                    LabelTile(
                      controller: controller,
                      themeController: themeController,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      child: Divider(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryDisabledTextColor
                            : kprimaryDisabledTextColor,
                      ),
                    ),
                    NoteTile(
                      controller: controller,
                      themeController: themeController,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      child: Divider(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryDisabledTextColor
                            : kprimaryDisabledTextColor,
                      ),
                    ),
                    ChooseRingtoneTile(
                      controller: controller,
                      themeController: themeController,
                      height: height,
                      width: width,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightPrimaryBackgroundColor
                          : ksecondaryTextColor,
                      height: 10,
                      width: width,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Automatic Cancellation',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryTextColor
                                              .withOpacity(0.85)
                                          : kprimaryTextColor.withOpacity(0.85),
                                    ),
                              ),
                            ),
                          ),
                          ScreenActivityTile(
                            controller: controller,
                            themeController: themeController,
                          ),
                          Divider(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryDisabledTextColor
                                : kprimaryDisabledTextColor,
                          ),
                          WeatherTile(
                            controller: controller,
                            themeController: themeController,
                          ),
                          Divider(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryDisabledTextColor
                                : kprimaryDisabledTextColor,
                          ),
                          LocationTile(
                            controller: controller,
                            height: height,
                            width: width,
                            themeController: themeController,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightPrimaryBackgroundColor
                          : ksecondaryTextColor,
                      height: 10,
                      width: width,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Challenges',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryTextColor
                                              .withOpacity(0.85)
                                          : kprimaryTextColor.withOpacity(0.85),
                                    ),
                              ),
                            ),
                          ),
                          ShakeToDismiss(
                            controller: controller,
                            themeController: themeController,
                          ),
                          Divider(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryDisabledTextColor
                                : kprimaryDisabledTextColor,
                          ),
                          QrBarCode(
                            controller: controller,
                            themeController: themeController,
                          ),
                          Divider(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryDisabledTextColor
                                : kprimaryDisabledTextColor,
                          ),
                          MathsChallenge(
                            controller: controller,
                            themeController: themeController,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightPrimaryBackgroundColor
                          : ksecondaryTextColor,
                      height: 10,
                      width: width,
                    ),
                    Container(
                      color: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Shared Alarm',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryTextColor
                                              .withOpacity(0.85)
                                          : kprimaryTextColor.withOpacity(0.85),
                                    ),
                              ),
                            ),
                          ),
                          SharedAlarm(
                            controller: controller,
                            themeController: themeController,
                          ),
                          Divider(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryDisabledTextColor
                                : kprimaryDisabledTextColor,
                          ),
                          AlarmIDTile(
                            controller: controller,
                            width: width,
                            themeController: themeController,
                          ),
                          Obx(
                            () => Container(
                              child: (controller.isSharedAlarmEnabled.value)
                                  ? Divider(
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryDisabledTextColor
                                          : kprimaryDisabledTextColor,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          AlarmOffset(
                            controller: controller,
                            themeController: themeController,
                          ),
                          Obx(
                            () => Container(
                              child: (controller.isSharedAlarmEnabled.value &&
                                      controller.alarmRecord != null)
                                  ? Divider(
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryDisabledTextColor
                                          : kprimaryDisabledTextColor,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          SharedUsers(
                            controller: controller,
                            themeController: themeController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.15,
                    ),
                  ],
                ),
        ));
  }
}