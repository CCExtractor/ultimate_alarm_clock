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
                    alarmTime: Utils.timeOfDayToString(
                        TimeOfDay.fromDateTime(controller.selectedTime.value)),
                    intervalToAlarm: Utils.getMillisecondsToAlarm(
                        DateTime.now(), controller.selectedTime.value),
                    isActivityEnabled: controller.isActivityenabled.value,
                    minutesSinceMidnight: Utils.timeOfDayToInt(
                        TimeOfDay.fromDateTime(controller.selectedTime.value)),
                    isLocationEnabled: controller.isLocationEnabled.value,
                  );

                  await controller.createAlarm(alarmRecord);

                  Get.back();
                },
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: ksecondaryBackgroundColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'Add your alarm',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          body: Column(
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
                                          color: (controller.isLocationEnabled
                                                      .value ==
                                                  false)
                                              ? kprimaryDisabledTextColor
                                              : kprimaryTextColor),
                                ),
                                PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 0) {
                                      controller.isLocationEnabled.value =
                                          false;
                                    } else if (value == 1) {
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
                                                  screenSize: Size(width * 0.3,
                                                      height * 0.8),
                                                  center: LatLng(
                                                      51.509364, -0.128928),
                                                  zoom: 9.2,
                                                ),
                                                children: [
                                                  TileLayer(
                                                    urlTemplate:
                                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                  ),
                                                  MarkerLayer(
                                                      markers: controller
                                                          .markersList),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  color: kprimaryBackgroundColor,
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color:
                                        (controller.isLocationEnabled.value ==
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
                                              color: (controller
                                                          .isLocationEnabled
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
                            onTap: () {}),
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
