import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controllers/add_or_update_alarm_controller.dart';

class AddOrUpdateAlarmView extends GetView<AddOrUpdateAlarmController> {
  AddOrUpdateAlarmView({Key? key}) : super(key: key);

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
                            offsetDetails: controller.offsetDetails,
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

                        Get.back();
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
          body:
              (controller.alarmRecord != null &&
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
                            Get.back();
                          },
                        )
                      ],
                    ))
                  : ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: ksecondaryBackgroundColor,
                          height: height * 0.28,
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
                              controller.selectedTime.value = dateTime;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.defaultDialog(
                                titlePadding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: ksecondaryBackgroundColor,
                                title: 'Repeat',
                                titleStyle:
                                    Theme.of(context).textTheme.displayMedium,
                                content: Obx(
                                  () => Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          controller.repeatDays[0] =
                                              !controller.repeatDays[0];
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: kprimaryTextColor
                                                            .withOpacity(0.5)),
                                                    value: controller
                                                        .repeatDays[0],
                                                    onChanged: (value) {
                                                      controller.repeatDays[0] =
                                                          !controller
                                                              .repeatDays[0];
                                                    }),
                                                Text(
                                                  'Monday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.repeatDays[1] =
                                              !controller.repeatDays[1];
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: kprimaryTextColor
                                                            .withOpacity(0.5)),
                                                    value: controller
                                                        .repeatDays[1],
                                                    onChanged: (value) {
                                                      controller.repeatDays[1] =
                                                          !controller
                                                              .repeatDays[1];
                                                    }),
                                                Text(
                                                  'Tuesday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.repeatDays[2] =
                                              !controller.repeatDays[2];
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: kprimaryTextColor
                                                            .withOpacity(0.5)),
                                                    value: controller
                                                        .repeatDays[2],
                                                    onChanged: (value) {
                                                      controller.repeatDays[2] =
                                                          !controller
                                                              .repeatDays[2];
                                                    }),
                                                Text(
                                                  'Wednesday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.repeatDays[3] =
                                              !controller.repeatDays[3];
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: kprimaryTextColor
                                                            .withOpacity(0.5)),
                                                    value: controller
                                                        .repeatDays[3],
                                                    onChanged: (value) {
                                                      controller.repeatDays[3] =
                                                          !controller
                                                              .repeatDays[3];
                                                    }),
                                                Text(
                                                  'Thursday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.repeatDays[4] =
                                              !controller.repeatDays[4];
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: kprimaryTextColor
                                                            .withOpacity(0.5)),
                                                    value: controller
                                                        .repeatDays[4],
                                                    onChanged: (value) {
                                                      controller.repeatDays[4] =
                                                          !controller
                                                              .repeatDays[4];
                                                    }),
                                                Text(
                                                  'Friday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.repeatDays[5] =
                                              !controller.repeatDays[5];
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: kprimaryTextColor
                                                            .withOpacity(0.5)),
                                                    value: controller
                                                        .repeatDays[5],
                                                    onChanged: (value) {
                                                      controller.repeatDays[5] =
                                                          !controller
                                                              .repeatDays[5];
                                                    }),
                                                Text(
                                                  'Saturday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.repeatDays[6] =
                                              !controller.repeatDays[6];
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: kprimaryTextColor
                                                            .withOpacity(0.5)),
                                                    value: controller
                                                        .repeatDays[6],
                                                    onChanged: (value) {
                                                      controller.repeatDays[6] =
                                                          !controller
                                                              .repeatDays[6];
                                                    }),
                                                Text(
                                                  'Sunday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          child: ListTile(
                              tileColor: ksecondaryBackgroundColor,
                              title: const Text('Repeat',
                                  style: TextStyle(
                                      color: kprimaryTextColor,
                                      fontWeight: FontWeight.w500)),
                              trailing: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Obx(
                                      () => Text(
                                        controller.daysRepeating.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: kprimaryTextColor),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: kprimaryDisabledTextColor,
                                    )
                                  ])),
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
                                    child: Text('Auto Dismissal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: kprimaryTextColor
                                                    .withOpacity(0.85))),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                      titlePadding: const EdgeInsets.symmetric(vertical: 20),
                                      backgroundColor: ksecondaryBackgroundColor,
                                      title: 'Timeout Duration',
                                      titleStyle: Theme.of(context).textTheme.displaySmall,
                                      content: Obx(
                                            () => Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            NumberPicker(
                                              value: controller.activityInterval.value,
                                              minValue: 0,
                                              maxValue: 1440,
                                              onChanged: (value) {
                                                if (value > 0) {
                                                  controller.isActivityenabled.value = true;
                                                } else {
                                                  controller.isActivityenabled.value = false;
                                                }
                                                controller.activityInterval.value = value;
                                              },
                                            ),
                                            Text(
                                              controller.activityInterval.value > 1 ? 'minutes' : 'minute',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: const Text(
                                      'Enable Activity',
                                      style: TextStyle(color: kprimaryTextColor),
                                    ),
                                    trailing: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Obx(
                                              () => Text(
                                            controller.activityInterval.value > 0
                                                ? '${controller.activityInterval.value} min'
                                                : 'Off',
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              color: (controller.isActivityenabled.value == false)
                                                  ? kprimaryDisabledTextColor
                                                  : kprimaryTextColor,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: kprimaryDisabledTextColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Divider(
                                  color: kprimaryDisabledTextColor,
                                ),
                                Obx(
                                  () => Container(
                                    child: (controller.weatherApiKeyExists.value ==
                                        true)
                                     ? ListTile(
                                      onTap: () async {
                                        await controller.getLocation();
                                        Get.defaultDialog(
                                            titlePadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                            backgroundColor:
                                            ksecondaryBackgroundColor,
                                            title: 'Select weather types',
                                            titleStyle: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            content: Obx(
                                                  () => Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (controller
                                                          .selectedWeather
                                                          .contains(WeatherTypes
                                                          .sunny)) {
                                                        controller.selectedWeather
                                                            .remove(WeatherTypes
                                                            .sunny);
                                                      } else {
                                                        controller.selectedWeather
                                                            .add(WeatherTypes
                                                            .sunny);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Checkbox(
                                                                side: BorderSide(
                                                                    width: 1.5,
                                                                    color: kprimaryTextColor
                                                                        .withOpacity(
                                                                        0.5)),
                                                                value: controller
                                                                    .selectedWeather
                                                                    .contains(
                                                                    WeatherTypes
                                                                        .sunny),
                                                                onChanged:
                                                                    (value) {
                                                                  if (controller
                                                                      .selectedWeather
                                                                      .contains(
                                                                      WeatherTypes
                                                                          .sunny)) {
                                                                    controller
                                                                        .selectedWeather
                                                                        .remove(WeatherTypes
                                                                        .sunny);
                                                                  } else {
                                                                    controller
                                                                        .selectedWeather
                                                                        .add(WeatherTypes
                                                                        .sunny);
                                                                  }
                                                                }),
                                                            Text(
                                                              'Sunny',
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                  fontSize:
                                                                  15),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (controller
                                                          .selectedWeather
                                                          .contains(WeatherTypes
                                                          .cloudy)) {
                                                        controller.selectedWeather
                                                            .remove(WeatherTypes
                                                            .cloudy);
                                                      } else {
                                                        controller.selectedWeather
                                                            .add(WeatherTypes
                                                            .cloudy);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Checkbox(
                                                                side: BorderSide(
                                                                    width: 1.5,
                                                                    color: kprimaryTextColor
                                                                        .withOpacity(
                                                                        0.5)),
                                                                value: controller
                                                                    .selectedWeather
                                                                    .contains(
                                                                    WeatherTypes
                                                                        .cloudy),
                                                                onChanged:
                                                                    (value) {
                                                                  if (controller
                                                                      .selectedWeather
                                                                      .contains(
                                                                      WeatherTypes
                                                                          .cloudy)) {
                                                                    controller
                                                                        .selectedWeather
                                                                        .remove(WeatherTypes
                                                                        .cloudy);
                                                                  } else {
                                                                    controller
                                                                        .selectedWeather
                                                                        .add(WeatherTypes
                                                                        .cloudy);
                                                                  }
                                                                }),
                                                            Text(
                                                              'Cloudy',
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                  fontSize:
                                                                  15),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (controller
                                                          .selectedWeather
                                                          .contains(WeatherTypes
                                                          .rainy)) {
                                                        controller.selectedWeather
                                                            .remove(WeatherTypes
                                                            .rainy);
                                                      } else {
                                                        controller.selectedWeather
                                                            .add(WeatherTypes
                                                            .rainy);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Checkbox(
                                                                side: BorderSide(
                                                                    width: 1.5,
                                                                    color: kprimaryTextColor
                                                                        .withOpacity(
                                                                        0.5)),
                                                                value: controller
                                                                    .selectedWeather
                                                                    .contains(
                                                                    WeatherTypes
                                                                        .rainy),
                                                                onChanged:
                                                                    (value) {
                                                                  if (controller
                                                                      .selectedWeather
                                                                      .contains(
                                                                      WeatherTypes
                                                                          .rainy)) {
                                                                    controller
                                                                        .selectedWeather
                                                                        .remove(WeatherTypes
                                                                        .rainy);
                                                                  } else {
                                                                    controller
                                                                        .selectedWeather
                                                                        .add(WeatherTypes
                                                                        .rainy);
                                                                  }
                                                                }),
                                                            Text(
                                                              'Rainy',
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                  fontSize:
                                                                  15),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (controller
                                                          .selectedWeather
                                                          .contains(WeatherTypes
                                                          .windy)) {
                                                        controller.selectedWeather
                                                            .remove(WeatherTypes
                                                            .windy);
                                                      } else {
                                                        controller.selectedWeather
                                                            .add(WeatherTypes
                                                            .windy);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Checkbox(
                                                                side: BorderSide(
                                                                    width: 1.5,
                                                                    color: kprimaryTextColor
                                                                        .withOpacity(
                                                                        0.5)),
                                                                value: controller
                                                                    .selectedWeather
                                                                    .contains(
                                                                    WeatherTypes
                                                                        .windy),
                                                                onChanged:
                                                                    (value) {
                                                                  if (controller
                                                                      .selectedWeather
                                                                      .contains(
                                                                      WeatherTypes
                                                                          .windy)) {
                                                                    controller
                                                                        .selectedWeather
                                                                        .remove(WeatherTypes
                                                                        .windy);
                                                                  } else {
                                                                    controller
                                                                        .selectedWeather
                                                                        .add(WeatherTypes
                                                                        .windy);
                                                                  }
                                                                }),
                                                            Text(
                                                              'Windy',
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                  fontSize:
                                                                  15),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (controller
                                                          .selectedWeather
                                                          .contains(WeatherTypes
                                                          .stormy)) {
                                                        controller.selectedWeather
                                                            .remove(WeatherTypes
                                                            .stormy);
                                                      } else {
                                                        controller.selectedWeather
                                                            .add(WeatherTypes
                                                            .stormy);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Checkbox(
                                                                side: BorderSide(
                                                                    width: 1.5,
                                                                    color: kprimaryTextColor
                                                                        .withOpacity(
                                                                        0.5)),
                                                                value: controller
                                                                    .selectedWeather
                                                                    .contains(
                                                                    WeatherTypes
                                                                        .stormy),
                                                                onChanged:
                                                                    (value) {
                                                                  if (controller
                                                                      .selectedWeather
                                                                      .contains(
                                                                      WeatherTypes
                                                                          .stormy)) {
                                                                    controller
                                                                        .selectedWeather
                                                                        .remove(WeatherTypes
                                                                        .stormy);
                                                                  } else {
                                                                    controller
                                                                        .selectedWeather
                                                                        .add(WeatherTypes
                                                                        .stormy);
                                                                  }
                                                                }),
                                                            Text(
                                                              'Stormy',
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                  fontSize:
                                                                  15),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      },
                                      tileColor: ksecondaryBackgroundColor,
                                      title: const Text('Enable Weather',
                                          style: TextStyle(
                                              color: kprimaryTextColor,
                                              fontWeight: FontWeight.w500)),
                                      trailing: InkWell(

                                        child: Wrap(
                                            crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                            children: [
                                              Obx(
                                                    () => Text(
                                                  controller.weatherTypes.value,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                      color: (controller
                                                          .isWeatherEnabled
                                                          .value ==
                                                          false)
                                                          ? kprimaryDisabledTextColor
                                                          : kprimaryTextColor),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.chevron_right,
                                                color: kprimaryDisabledTextColor,
                                              )
                                            ]),
                                      ),
                                  )
                                        : ListTile(
                                        onTap: () {
                                          Get.defaultDialog(
                                              contentPadding: EdgeInsets.all(10.0),
                                              titlePadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 20),
                                              backgroundColor:
                                              ksecondaryBackgroundColor,
                                              title: 'Disabled!',
                                              titleStyle: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall,
                                              content: Column(
                                                children: [
                                                  const Text(
                                                      "To use this feature, you have to add an OpenWeatherMap API key!"),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                                  kprimaryColor)),
                                                          child: Text(
                                                            'Go to settings',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .displaySmall!
                                                                .copyWith(
                                                                color:
                                                                ksecondaryTextColor),
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                            Get.toNamed(
                                                                '/settings');
                                                          },
                                                        ),
                                                        TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                              MaterialStateProperty.all(
                                                                  kprimaryTextColor
                                                                      .withOpacity(
                                                                      0.5))),
                                                          child: Text(
                                                            'Cancel',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .displaySmall!
                                                                .copyWith(
                                                                color:
                                                                kprimaryTextColor),
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ));
                                        },
                                        tileColor: ksecondaryBackgroundColor,
                                        title: const Text('Enable Weather',
                                            style: TextStyle(
                                                color: kprimaryTextColor,
                                                fontWeight: FontWeight.w500)),
                                        trailing: InkWell(

                                          child: Wrap(
                                              crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.lock,
                                                  color: kprimaryTextColor
                                                      .withOpacity(0.7),
                                                )
                                              ]),
                                        )),
                                ),),
                                const Divider(
                                  color: kprimaryDisabledTextColor,
                                ),
                                GestureDetector(
                                  onTapDown: (TapDownDetails details) async {
                                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                                    final RelativeRect position = RelativeRect.fromRect(
                                      Rect.fromPoints(
                                        details.globalPosition,
                                        details.globalPosition,
                                      ),
                                      Offset.zero & overlay.size,
                                    );

                                    await showMenu(
                                      color: ksecondaryBackgroundColor,
                                      context: context,
                                      position: position,
                                      items: [
                                        PopupMenuItem<int>(
                                          value: 0,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Off",
                                                style: TextStyle(
                                                  color: (controller.isLocationEnabled.value == true)
                                                      ? kprimaryDisabledTextColor
                                                      : kprimaryTextColor,
                                                ),
                                              ),
                                              Radio(
                                                fillColor: MaterialStateProperty.all(
                                                  (controller.isLocationEnabled.value == true)
                                                      ? kprimaryDisabledTextColor
                                                      : kprimaryColor,
                                                ),
                                                value: !controller.isLocationEnabled.value,
                                                groupValue: true,
                                                onChanged: (value) {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          value: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Choose location",
                                                style: TextStyle(
                                                  color: (controller.isLocationEnabled.value == false)
                                                      ? kprimaryDisabledTextColor
                                                      : kprimaryTextColor,
                                                ),
                                              ),
                                              Icon(
                                                Icons.chevron_right,
                                                color: (controller.isLocationEnabled.value == false)
                                                    ? kprimaryDisabledTextColor
                                                    : kprimaryTextColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).then((value) async {
                                      // Handle menu item selection
                                      if (value == 0) {
                                        controller.isLocationEnabled.value = false;
                                      } else if (value == 1) {
                                        if (controller.isLocationEnabled.value == false) {
                                          await controller.getLocation();
                                        }
                                        controller.isLocationEnabled.value = true;

                                        Get.defaultDialog(
                                          backgroundColor:
                                          ksecondaryBackgroundColor,
                                          title:
                                          'Set location to automatically cancel alarm!',
                                          titleStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          content: Column(
                                            children: [
                                              SizedBox(
                                                height: height * 0.65,
                                                width: width * 0.92,
                                                child: FlutterMap(
                                                  mapController:
                                                  controller.mapController,
                                                  options: MapOptions(
                                                    onTap: (tapPosition, point) {
                                                      controller.selectedPoint
                                                          .value = point;
                                                    },
                                                    screenSize: Size(
                                                        width * 0.3, height * 0.8),
                                                    center: controller
                                                        .selectedPoint.value,
                                                    zoom: 15,
                                                  ),
                                                  children: [
                                                    TileLayer(
                                                      urlTemplate:
                                                      'https://{s}tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                    ),
                                                    MarkerLayer(
                                                        markers:
                                                        controller.markersList),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty.all(
                                                        kprimaryColor)),
                                                child: Text(
                                                  'Save',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                      color:
                                                      ksecondaryTextColor),
                                                ),
                                                onPressed: () => Get.back(),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  child: ListTile(
                                    title: const Text(
                                      'Location Based',
                                      style: TextStyle(color: kprimaryTextColor),
                                    ),
                                    trailing: Obx(
                                          () => Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            controller.isLocationEnabled.value == false ? 'Off' : 'Enabled',
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              color: (controller.isLocationEnabled.value == false)
                                                  ? kprimaryDisabledTextColor
                                                  : kprimaryTextColor,
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: (controller.isLocationEnabled.value == false)
                                                ? kprimaryDisabledTextColor
                                                : kprimaryTextColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )


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
                                  child: Text('Challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.85))),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Shake to dismiss',
                                  style: TextStyle(color: kprimaryTextColor),
                                ),
                                onTap: () {
                                  Get.defaultDialog(
                                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                                    backgroundColor: ksecondaryBackgroundColor,
                                    title: 'Number of shakes',
                                    titleStyle: Theme.of(context).textTheme.displaySmall,
                                    content: Obx(
                                          () => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          NumberPicker(
                                            value: controller.shakeTimes.value,
                                            minValue: 0,
                                            maxValue: 100,
                                            onChanged: (value) {
                                              if (value > 0) {
                                                controller.isShakeEnabled.value = true;
                                              } else {
                                                controller.isShakeEnabled.value = false;
                                              }
                                              controller.shakeTimes.value = value;
                                            },
                                          ),
                                          Text(controller.shakeTimes.value > 1 ? 'times' : 'time')
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                trailing: InkWell(
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Obx(
                                            () => Text(
                                          controller.shakeTimes.value > 0
                                              ? controller.shakeTimes.value > 1
                                              ? '${controller.shakeTimes.value} times'
                                              : '${controller.shakeTimes.value} time'
                                              : 'Off',
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: (controller.isShakeEnabled.value == false)
                                                ? kprimaryDisabledTextColor
                                                : kprimaryTextColor,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: kprimaryDisabledTextColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              const Divider(
                                color: kprimaryDisabledTextColor,
                              ),
                              ListTile(
                                title: const Text('QR/Bar Code'),
                                onTap: () {
                                  controller.restartQRCodeController();
                                  Get.defaultDialog(
                                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                                    backgroundColor: ksecondaryBackgroundColor,
                                    title: 'Scan a QR/Bar Code',
                                    titleStyle: Theme.of(context).textTheme.displaySmall,
                                    content: Obx(
                                          () => Column(
                                        children: [
                                          controller.isQrEnabled.value == false
                                              ? SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: MobileScanner(
                                              controller: controller.qrController,
                                              fit: BoxFit.cover,
                                              onDetect: (capture) {
                                                final List<Barcode> barcodes = capture.barcodes;
                                                for (final barcode in barcodes) {
                                                  controller.qrValue.value = barcode.rawValue.toString();
                                                  print(barcode.rawValue.toString());
                                                  controller.isQrEnabled.value = true;
                                                }
                                              },
                                            ),
                                          )
                                              : Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0),
                                            child: Text(controller.qrValue.value),
                                          ),
                                          controller.isQrEnabled.value == true
                                              ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStateProperty.all(kprimaryColor),
                                                ),
                                                child: Text(
                                                  'Save',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(color: ksecondaryTextColor),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              ),
                                              TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStateProperty.all(kprimaryColor),
                                                ),
                                                child: Text(
                                                  'Retake',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(color: ksecondaryTextColor),
                                                ),
                                                onPressed: () async {
                                                  controller.qrController.dispose();
                                                  controller.restartQRCodeController();
                                                  controller.isQrEnabled.value = false;
                                                },
                                              ),
                                            ],
                                          )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                trailing: InkWell(
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Obx(
                                            () => Text(
                                          controller.isQrEnabled.value == true ? 'Enabled' : 'Off',
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: (controller.isQrEnabled.value == false)
                                                ? kprimaryDisabledTextColor
                                                : kprimaryTextColor,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: kprimaryDisabledTextColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              const Divider(
                                color: kprimaryDisabledTextColor,
                              ),
                              ListTile(
                                title: const Text('Maths'),
                                onTap: () {
                                  controller.isMathsEnabled.value = true;
                                  Get.defaultDialog(
                                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                                    backgroundColor: ksecondaryBackgroundColor,
                                    title: 'Solve Maths questions',
                                    titleStyle: Theme.of(context).textTheme.displaySmall,
                                    content: Obx(
                                          () => Column(
                                        children: [
                                          Text(
                                            Utils.getDifficultyLabel(controller.mathsDifficulty.value),
                                            style: Theme.of(context).textTheme.displaySmall,
                                          ),
                                          Text(
                                            Utils.generateMathProblem(controller.mathsDifficulty.value)[0],
                                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                              color: kprimaryTextColor.withOpacity(0.78),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                                            child: Slider(
                                              min: 0.0,
                                              max: 2.0,
                                              divisions: 2,
                                              value: controller.mathsSliderValue.value,
                                              onChanged: (newValue) {
                                                controller.mathsSliderValue.value = newValue;
                                                controller.mathsDifficulty.value = Utils.getDifficulty(newValue);
                                              },
                                            ),
                                          ),
                                          Obx(
                                                () => Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                NumberPicker(
                                                  value: controller.numMathsQuestions.value,
                                                  minValue: 1,
                                                  maxValue: 100,
                                                  onChanged: (value) => controller.numMathsQuestions.value = value,
                                                ),
                                                Text(controller.numMathsQuestions.value > 1 ? 'questions' : 'question'),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(kprimaryColor),
                                                  ),
                                                  child: Text(
                                                    'Save',
                                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                                      color: ksecondaryTextColor,
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Get.back();
                                                  },
                                                ),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(kprimaryColor),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                                      color: ksecondaryTextColor,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    controller.isMathsEnabled.value = false;
                                                    Get.back();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                trailing: InkWell(
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Obx(
                                            () => Text(
                                          controller.isMathsEnabled == true
                                              ? Utils.getDifficultyLabel(controller.mathsDifficulty.value)
                                              : 'Off',
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            color: (controller.isMathsEnabled.value == false)
                                                ? kprimaryDisabledTextColor
                                                : kprimaryTextColor,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: kprimaryDisabledTextColor,
                                      ),
                                    ],
                                  ),
                                ),
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
                              Container(
                                child: (controller.userModel != null)
                                ? ListTile(
                                  title: const Text(
                                    'Enable Shared Alarm',
                                    style: TextStyle(color: kprimaryTextColor),
                                  ),
                                  onTap: () {
                                    // Toggle the value of isSharedAlarmEnabled
                                    controller.isSharedAlarmEnabled.value = !controller.isSharedAlarmEnabled.value;
                                  },
                                  trailing: Obx(
                                        () => Switch(
                                      onChanged: (value) {
                                        // You can optionally add the onChanged callback here as well
                                        controller.isSharedAlarmEnabled.value = value;
                                      },
                                      value: controller.isSharedAlarmEnabled.value,
                                    ),
                                  ),
                                )

                                  :ListTile(
                                    onTap: () {
                                      Get.defaultDialog(
                                          contentPadding:
                                          const EdgeInsets.all(10.0),
                                          titlePadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 20),
                                          backgroundColor:
                                          ksecondaryBackgroundColor,
                                          title: 'Disabled!',
                                          titleStyle: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                          content: Column(
                                            children: [
                                              const Text(
                                                  "To use this feature, you have link your Google account!"),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                              kprimaryColor)),
                                                      child: Text(
                                                        'Go to settings',
                                                        style: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .displaySmall!
                                                            .copyWith(
                                                            color:
                                                            ksecondaryTextColor),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                        Get.toNamed(
                                                            '/settings');
                                                      },
                                                    ),
                                                    TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStateProperty.all(
                                                              kprimaryTextColor
                                                                  .withOpacity(0.5))),
                                                      child: Text(
                                                        'Cancel',
                                                        style: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .displaySmall!
                                                            .copyWith(
                                                            color:
                                                            kprimaryTextColor),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ));
                                    },
                                    title: const Text(
                                      'Enable Shared Alarm',
                                      style: TextStyle(color: kprimaryTextColor),
                                    ),
                                    trailing:InkWell(

                                      child: Icon(
                                        Icons.lock,
                                        color: kprimaryTextColor
                                            .withOpacity(0.7),
                                      ),
                                    )),
                              ),
                              const Divider(
                                color: kprimaryDisabledTextColor,
                              ),
                              Obx(
                                    () => Container(
                                      child: (controller
                                          .isSharedAlarmEnabled.value ==
                                          true)
                                      ?ListTile(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: controller.alarmID));
                                            Get.snackbar(
                                              'Success!',
                                              'Alarm ID has been copied!',
                                              snackPosition:
                                              SnackPosition.BOTTOM,
                                              backgroundColor: Colors.green,
                                              colorText: ksecondaryTextColor,
                                              maxWidth: width,
                                              duration:
                                              const Duration(seconds: 2),
                                            );
                                          },
                                          title: const Text(
                                            'Alarm ID',
                                            style:
                                            TextStyle(color: kprimaryTextColor),
                                          ),
                                          trailing:  InkWell(

                                            child: Icon(Icons.copy,
                                                color: kprimaryTextColor
                                                    .withOpacity(0.7)),
                                          )
                                      )
                                      : ListTile(
                                          onTap: () {
                                            Get.defaultDialog(
                                                titlePadding: const EdgeInsets
                                                    .symmetric(vertical: 20),
                                                backgroundColor:
                                                ksecondaryBackgroundColor,
                                                title: 'Disabled!',
                                                titleStyle: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                                content: Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.all(
                                                          20.0),
                                                      child: Text(
                                                          "To copy Alarm ID you have enable shared alarm!"),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10.0),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                kprimaryColor)),
                                                        child: Text(
                                                          'Okay',
                                                          style: Theme.of(
                                                              context)
                                                              .textTheme
                                                              .displaySmall!
                                                              .copyWith(
                                                              color:
                                                              ksecondaryTextColor),
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ));
                                          },
                                          title: const Text(
                                            'Alarm ID',
                                            style:
                                            TextStyle(color: kprimaryTextColor),
                                          ),
                                          trailing:  InkWell(

                                            child: Icon(
                                              Icons.lock,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.7),
                                            ),
                                          )),
                                    )
                              ),
                              Obx(

                                () => Container(
                                  child: (controller.isSharedAlarmEnabled.value)
                                      ? const Divider(
                                          color: kprimaryDisabledTextColor,
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                              Obx(
                                () => (controller.isSharedAlarmEnabled.value)
                                    ? InkWell(
                                        onTap: () {
                                          Get.defaultDialog(
                                            titlePadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 20),
                                            backgroundColor:
                                                ksecondaryBackgroundColor,
                                            title: 'Offset Duration',
                                            titleStyle: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Obx(
                                                  () => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      NumberPicker(
                                                          value: controller
                                                              .offsetDuration
                                                              .value,
                                                          minValue: 0,
                                                          maxValue: 1440,
                                                          onChanged: (value) {
                                                            controller
                                                                .offsetDuration
                                                                .value = value;
                                                          }),
                                                      Text(controller
                                                                  .offsetDuration
                                                                  .value >
                                                              1
                                                          ? 'minutes'
                                                          : 'minute')
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Obx(
                                                      () => ElevatedButton(
                                                        onPressed: () {
                                                          controller
                                                              .isOffsetBefore
                                                              .value = true;
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: (controller
                                                                  .isOffsetBefore
                                                                  .value)
                                                              ? kprimaryColor
                                                              : kprimaryTextColor
                                                                  .withOpacity(
                                                                      0.08),
                                                          foregroundColor: (controller
                                                                  .isOffsetBefore
                                                                  .value)
                                                              ? ksecondaryTextColor
                                                              : kprimaryTextColor,
                                                        ),
                                                        child: const Text(
                                                            "Before",
                                                            style: TextStyle(
                                                                fontSize: 14)),
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => ElevatedButton(
                                                        onPressed: () {
                                                          controller
                                                              .isOffsetBefore
                                                              .value = false;
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: (!controller
                                                                  .isOffsetBefore
                                                                  .value)
                                                              ? kprimaryColor
                                                              : kprimaryTextColor
                                                                  .withOpacity(
                                                                      0.08),
                                                          foregroundColor: (!controller
                                                                  .isOffsetBefore
                                                                  .value)
                                                              ? ksecondaryTextColor
                                                              : kprimaryTextColor,
                                                        ),
                                                        child: const Text(
                                                            "After",
                                                            style: TextStyle(
                                                                fontSize: 14)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                            title: const Text('Alarm Offset'),
                                            trailing: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Obx(
                                                    () => Text(
                                                      controller.offsetDuration
                                                                  .value >
                                                              0
                                                          ? 'Enabled'
                                                          : 'Off',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: (controller
                                                                          .offsetDuration
                                                                          .value >
                                                                      0)
                                                                  ? kprimaryTextColor
                                                                  : kprimaryDisabledTextColor),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.chevron_right,
                                                    color:
                                                        kprimaryDisabledTextColor,
                                                  )
                                                ])),
                                      )
                                    : SizedBox(),
                              ),
                              Obx(
                                () => Container(
                                  child:
                                      (controller.isSharedAlarmEnabled.value &&
                                              controller.alarmRecord != null)
                                          ? const Divider(
                                              color: kprimaryDisabledTextColor,
                                            )
                                          : const SizedBox(),
                                ),
                              ),
                              Obx(
                                    () => Container(
                                    child: (controller
                                        .isSharedAlarmEnabled.value &&
                                        controller.alarmRecord != null)
                                        ? (controller.alarmRecord!.ownerId !=
                                        controller.userModel!.id)
                                        ? ListTile(
                                        title: const Text(
                                          'Alarm Owner',
                                          style: TextStyle(
                                              color: kprimaryTextColor),
                                        ),
                                        trailing: Text(
                                          controller
                                              .alarmRecord!.ownerName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              color:
                                              kprimaryDisabledTextColor),
                                        ))
                                        : ListTile(
                                      title: const Text(
                                        'Shared Users',
                                        style: TextStyle(
                                            color: kprimaryTextColor),
                                      ),
                                      trailing: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                            kprimaryBackgroundColor,
                                            builder: (BuildContext
                                            context) {
                                              final userDetails =
                                              RxList<UserModel?>(
                                                  []);

                                              return Obx(() {
                                                if (controller
                                                    .sharedUserIds
                                                    .isEmpty) {
                                                  return const Center(
                                                      child: Text(
                                                          "No shared users!"));
                                                }

                                                return FutureBuilder<
                                                    List<UserModel?>>(
                                                  future: controller
                                                      .fetchUserDetailsForSharedUsers(),
                                                  builder: (BuildContext
                                                  context,
                                                      AsyncSnapshot<
                                                          List<
                                                              UserModel?>>
                                                      snapshot) {
                                                    if (snapshot
                                                        .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                        CircularProgressIndicator(
                                                          color:
                                                          kprimaryColor,
                                                        ),
                                                      );
                                                    }

                                                    userDetails
                                                        .value =
                                                        snapshot.data ??
                                                            [];

                                                    return Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child:
                                                            Text(
                                                              'Shared Users',
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            ),
                                                          ),
                                                          for (UserModel? user
                                                          in userDetails
                                                              .value)
                                                            Column(
                                                              children: [
                                                                ListTile(
                                                                  title:
                                                                  Text(
                                                                    user!.fullName,
                                                                    style: TextStyle(color: kprimaryTextColor),
                                                                  ),
                                                                  trailing:
                                                                  TextButton(
                                                                    style: ButtonStyle(
                                                                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                                      minimumSize: MaterialStateProperty.all(const Size(80, 30)),
                                                                      maximumSize: MaterialStateProperty.all(const Size(80, 30)),
                                                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                                                    ),
                                                                    child: Text(
                                                                      'Remove',
                                                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                                        color: kprimaryTextColor.withOpacity(0.9),
                                                                      ),
                                                                    ),

                                                                    for (UserModel? user
                                                                        in userDetails)
                                                                      Column(
                                                                        children: [
                                                                          ListTile(
                                                                            title:
                                                                                Text(
                                                                              user!.fullName,
                                                                              style: const TextStyle(color: kprimaryTextColor),
                                                                            ),
                                                                            trailing:
                                                                                TextButton(
                                                                              style: ButtonStyle(
                                                                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                                                minimumSize: MaterialStateProperty.all(const Size(80, 30)),
                                                                                maximumSize: MaterialStateProperty.all(const Size(80, 30)),
                                                                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                                                              ),
                                                                              child: Text(
                                                                                'Remove',
                                                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                                                      color: kprimaryTextColor.withOpacity(0.9),
                                                                                    ),
                                                                              ),
                                                                              onPressed: () async {
                                                                                await FirestoreDb.removeUserFromAlarmSharedUsers(user, controller.alarmID);
                                                                                // Update sharedUserIds value after removing the user
                                                                                controller.sharedUserIds.remove(user.id);

                                                                                // Remove the user from userDetails list
                                                                                userDetails.remove(user);

                                                                      // Update the list
                                                                      userDetails.refresh();
                                                                    },
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  color:
                                                                  kprimaryDisabledTextColor,
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              });
                                            },
                                          );
                                        },
                                        child: Icon(
                                            Icons.chevron_right,
                                            color: kprimaryTextColor
                                                .withOpacity(0.7)),
                                      ),
                                    )
                                        : const SizedBox()),
                              ),
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