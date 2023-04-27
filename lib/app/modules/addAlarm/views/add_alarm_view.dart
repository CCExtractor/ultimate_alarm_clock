import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controllers/add_alarm_controller.dart';

class AddAlarmView extends GetView<AddAlarmController> {
  AddAlarmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return WithForegroundTask(
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.all(18.0),
            child: SizedBox(
              height: height * 0.06,
              width: width * 0.8,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kprimaryColor)),
                child: Text(
                  'Save',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: ksecondaryTextColor),
                ),
                onPressed: () async {
                  AlarmModel alarmRecord = AlarmModel(
                      days: controller.repeatDays.toList(),
                      alarmTime: Utils.timeOfDayToString(TimeOfDay.fromDateTime(
                          controller.selectedTime.value)),
                      intervalToAlarm: Utils.getMillisecondsToAlarm(
                          DateTime.now(), controller.selectedTime.value),
                      isActivityEnabled: controller.isActivityenabled.value,
                      minutesSinceMidnight: Utils.timeOfDayToInt(
                          TimeOfDay.fromDateTime(
                              controller.selectedTime.value)),
                      isLocationEnabled: controller.isLocationEnabled.value,
                      location: Utils.geoPointToString(Utils.latLngToGeoPoint(
                          controller.selectedPoint.value)));

                  try {
                    await controller.createAlarm(alarmRecord);
                  } catch (e) {
                    print(e);
                  }

                  Get.back();
                },
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: ksecondaryBackgroundColor,
            elevation: 0.0,
            centerTitle: true,
            title: Obx(
              () => Text(
                "Rings in ${controller.timeToAlarm.value}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: ksecondaryBackgroundColor,
                height: height * 0.28,
                width: width,
                child: TimePickerSpinner(
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
                      titlePadding: EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: ksecondaryBackgroundColor,
                      title: 'Repeat',
                      titleStyle: Theme.of(context).textTheme.displayMedium,
                      content: Obx(
                        () => Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.repeatDays[0] =
                                    !controller.repeatDays[0];
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.5)),
                                          value: controller.repeatDays[0],
                                          onChanged: (value) {
                                            controller.repeatDays[0] =
                                                !controller.repeatDays[0];
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
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.5)),
                                          value: controller.repeatDays[1],
                                          onChanged: (value) {
                                            controller.repeatDays[1] =
                                                !controller.repeatDays[1];
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
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.5)),
                                          value: controller.repeatDays[2],
                                          onChanged: (value) {
                                            controller.repeatDays[2] =
                                                !controller.repeatDays[2];
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
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.5)),
                                          value: controller.repeatDays[3],
                                          onChanged: (value) {
                                            controller.repeatDays[3] =
                                                !controller.repeatDays[3];
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
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.5)),
                                          value: controller.repeatDays[4],
                                          onChanged: (value) {
                                            controller.repeatDays[4] =
                                                !controller.repeatDays[4];
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
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.5)),
                                          value: controller.repeatDays[5],
                                          onChanged: (value) {
                                            controller.repeatDays[5] =
                                                !controller.repeatDays[5];
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
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: kprimaryTextColor
                                                  .withOpacity(0.5)),
                                          value: controller.repeatDays[6],
                                          onChanged: (value) {
                                            controller.repeatDays[6] =
                                                !controller.repeatDays[6];
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
                        // mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => Text(
                              controller.daysRepeating.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color:
                                          (controller.isLocationEnabled.value ==
                                                  false)
                                              ? kprimaryDisabledTextColor
                                              : kprimaryTextColor),
                            ),
                          ),
                          Icon(
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
                child: Column(children: [
                  Obx(
                    () => ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text(
                            'Enable Activity',
                            style: const TextStyle(color: kprimaryTextColor),
                          ),
                          trailing: Switch(
                            onChanged: (value) {
                              controller.isActivityenabled.value = value;
                            },
                            value: controller.isActivityenabled.value,
                          ),
                        ),
                        const Divider(
                          color: kprimaryDisabledTextColor,
                        ),
                        ListTile(
                          title: const Text(
                            'Location Based',
                            style: TextStyle(color: kprimaryTextColor),
                          ),
                          trailing: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                controller.isLocationEnabled.value == false
                                    ? 'Off'
                                    : 'Enabled',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: (controller
                                                    .isLocationEnabled.value ==
                                                false)
                                            ? kprimaryDisabledTextColor
                                            : kprimaryTextColor),
                              ),
                              PopupMenuButton(
                                onSelected: (value) async {
                                  if (value == 0) {
                                    controller.isLocationEnabled.value = false;
                                  } else if (value == 1) {
                                    await controller.getLocation();
                                    // Get.back();
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
                                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                ),
                                                MarkerLayer(
                                                    markers:
                                                        controller.markersList),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
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
                                },
                                color: kprimaryBackgroundColor,
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: (controller.isLocationEnabled.value ==
                                          false)
                                      ? kprimaryDisabledTextColor
                                      : kprimaryTextColor,
                                ),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Off",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: (controller
                                                                .isLocationEnabled
                                                                .value ==
                                                            true)
                                                        ? kprimaryDisabledTextColor
                                                        : kprimaryTextColor),
                                          ),
                                          Radio(
                                              fillColor: MaterialStateProperty
                                                  .all((controller
                                                              .isLocationEnabled
                                                              .value ==
                                                          true)
                                                      ? kprimaryDisabledTextColor
                                                      : kprimaryColor),
                                              value: !controller
                                                  .isLocationEnabled.value,
                                              groupValue: true,
                                              onChanged: (value) {}),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Choose location",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: (controller
                                                                .isLocationEnabled
                                                                .value ==
                                                            false)
                                                        ? kprimaryDisabledTextColor
                                                        : kprimaryTextColor),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: (controller.isLocationEnabled
                                                        .value ==
                                                    false)
                                                ? kprimaryDisabledTextColor
                                                : kprimaryTextColor,
                                          ),
                                        ],
                                      ),
                                    )
                                  ];
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              )
            ],
          )),
    );
  }
}
