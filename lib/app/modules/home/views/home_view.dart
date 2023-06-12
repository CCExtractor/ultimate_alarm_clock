import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      // backgroundColor: kprimaryBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-alarm'),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(25, 25, 0, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next alarm',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: kprimaryDisabledTextColor),
                      ),
                      Obx(
                        () => Text(controller.alarmTime.value,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    color:
                                        kprimaryTextColor.withOpacity(0.75))),
                      )
                    ],
                  )),
              IconButton(
                onPressed: () {
                  Get.toNamed('/settings');
                },
                icon: const Icon(Icons.settings),
                color: kprimaryTextColor.withOpacity(0.75),
                iconSize: 27,
              )
            ],
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: GlowingOverscrollIndicator(
                    color: kprimaryDisabledTextColor,
                    axisDirection: AxisDirection.down,
                    child: StreamBuilder(
                        stream: controller.streamAlarms,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: kprimaryColor,
                            ));
                          } else {
                            final alarms = snapshot.data;

                            if (alarms!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/empty.svg',
                                      height: height * 0.3,
                                      width: width * 0.8,
                                    ),
                                    Text(
                                      'Add an alarm to get started!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              color: kprimaryDisabledTextColor),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListView.separated(
                                separatorBuilder: (context, _) {
                                  return SizedBox(height: height * 0.02);
                                },
                                itemCount: alarms.length + 1,
                                itemBuilder: (context, index) {
                                  // Spacing after last card
                                  if (index == alarms.length) {
                                    return SizedBox(height: height * 0.02);
                                  }
                                  final AlarmModel alarm = alarms[index];
                                  final time12 = Utils.convertTo12HourFormat(
                                      alarm.alarmTime);
                                  final repeatDays =
                                      Utils.getRepeatDays(alarm.days);
                                  // Main card
                                  return InkWell(
                                    onTap: () {
                                      Get.toNamed('/update-alarm',
                                          arguments: alarm);
                                    },
                                    child: Center(
                                      child: Container(
                                        width: width * 0.91,
                                        height: height * 0.135,
                                        decoration: const BoxDecoration(
                                            color: ksecondaryBackgroundColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            repeatDays
                                                                .replaceAll(
                                                                    "Never",
                                                                    "One Time"),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: (alarm.isEnabled ==
                                                                            true)
                                                                        ? kprimaryColor
                                                                        : kprimaryDisabledTextColor)),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              time12[0],
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displayLarge!
                                                                  .copyWith(
                                                                      color: (alarm.isEnabled ==
                                                                              true)
                                                                          ? kprimaryTextColor
                                                                          : kprimaryDisabledTextColor),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      3.0),
                                                              child: Text(
                                                                time12[1],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium!
                                                                    .copyWith(
                                                                        color: (alarm.isEnabled ==
                                                                                true)
                                                                            ? kprimaryTextColor
                                                                            : kprimaryDisabledTextColor),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 0,
                                                        child: Switch(
                                                            value:
                                                                alarm.isEnabled,
                                                            onChanged: (bool
                                                                value) async {
                                                              alarm.isEnabled =
                                                                  value;

                                                              if (alarm
                                                                      .isSharedAlarmEnabled ==
                                                                  true) {
                                                                await FirestoreDb
                                                                    .updateAlarm(
                                                                        alarm);
                                                              } else {
                                                                await IsarDb
                                                                    .updateAlarm(
                                                                        alarm);
                                                              }
                                                              controller
                                                                      .refreshTimer =
                                                                  true;
                                                              controller
                                                                  .refreshUpcomingAlarms();
                                                            }),
                                                      ),
                                                      Expanded(
                                                        flex: 0,
                                                        child: PopupMenuButton(
                                                          onSelected:
                                                              (value) async {
                                                            if (value == 0) {
                                                              Get.back();
                                                              Get.offNamed(
                                                                  '/alarm-ring',
                                                                  arguments:
                                                                      alarm);
                                                            } else if (value ==
                                                                1) {
                                                              print(alarm
                                                                  .isSharedAlarmEnabled);

                                                              if (alarm
                                                                      .isSharedAlarmEnabled ==
                                                                  true) {
                                                                await FirestoreDb
                                                                    .deleteAlarm(
                                                                        alarm
                                                                            .firestoreId!);
                                                              } else {
                                                                await IsarDb
                                                                    .deleteAlarm(
                                                                        alarm
                                                                            .isarId);
                                                              }

                                                              controller
                                                                      .refreshTimer =
                                                                  true;
                                                              controller
                                                                  .refreshUpcomingAlarms();
                                                            }
                                                          },
                                                          color:
                                                              kprimaryBackgroundColor,
                                                          icon: Icon(
                                                              Icons.more_vert,
                                                              color: (alarm
                                                                          .isEnabled ==
                                                                      true)
                                                                  ? kprimaryTextColor
                                                                  : kprimaryDisabledTextColor),
                                                          itemBuilder:
                                                              (context) {
                                                            return [
                                                              PopupMenuItem<
                                                                  int>(
                                                                value: 0,
                                                                child: Text(
                                                                  "Preview Alarm",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                              ),
                                                              PopupMenuItem<
                                                                  int>(
                                                                value: 1,
                                                                child: Text(
                                                                  "Delete Alarm",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                              )
                                                            ];
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
