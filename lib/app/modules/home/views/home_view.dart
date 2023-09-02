import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final HapticFeedbackController hapticFeedbackController =
      Get.find<HapticFeedbackController>();

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Obx(
        () => Container(
            child: (controller.isUserSignedIn.value)
                ? ExpandableFab(
                    key: controller.floatingButtonKey,
                    initialOpen: false,
                    type: ExpandableFabType.up,
                    childrenOffset: Offset.zero,
                    distance: 70,
                    child: const Icon(Icons.add),
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        onPressed: () {
                          hapticFeedbackController.hapticFeedback();
                          controller.floatingButtonKey.currentState!.toggle();
                          Get.defaultDialog(
                            title: "Join an alarm",
                            titlePadding:
                                const EdgeInsets.fromLTRB(0, 21, 0, 0),
                            backgroundColor: ksecondaryBackgroundColor,
                            titleStyle: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: kprimaryTextColor),
                            contentPadding: const EdgeInsets.all(21),
                            content: TextField(
                              controller: controller.alarmIdController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              cursorColor: kprimaryTextColor.withOpacity(0.75),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kprimaryTextColor
                                              .withOpacity(0.75),
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kprimaryTextColor
                                              .withOpacity(0.75),
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kprimaryTextColor
                                              .withOpacity(0.75),
                                          width: 1),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(12))),
                                  hintText: 'Enter Alarm ID',
                                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: kprimaryDisabledTextColor)),
                            ),
                            buttonColor: ksecondaryBackgroundColor,
                            confirm: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kprimaryColor)),
                              child: Text(
                                'Join',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: ksecondaryTextColor),
                              ),
                              onPressed: () async {
                                hapticFeedbackController.hapticFeedback();
                                var result =
                                    await FirestoreDb.addUserToAlarmSharedUsers(
                                        controller.userModel.value,
                                        controller.alarmIdController.text);

                                if (result != true) {
                                  Get.defaultDialog(
                                      titlePadding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      backgroundColor:
                                          ksecondaryBackgroundColor,
                                      title: 'Error!',
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.close,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Text(
                                              result == null
                                                  ? "You cannot join your own alarm!"
                                                  : "An alarm with this ID doesn't exist!",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          TextButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          kprimaryColor)),
                                              child: Text(
                                                'Okay',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                        color:
                                                            ksecondaryTextColor),
                                              ),
                                              onPressed: () {
                                                hapticFeedbackController.hapticFeedback();
                                                Get.back();
                                              }),
                                        ],
                                      ));
                                } else {
                                  Get.back();
                                }
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.alarm,
                              color: ksecondaryTextColor,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Join alarm',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: ksecondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        onPressed: () {
                          hapticFeedbackController.hapticFeedback();
                          controller.floatingButtonKey.currentState!.toggle();
                          Get.toNamed('/add-update-alarm');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add,
                              color: ksecondaryTextColor,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Create alarm',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: ksecondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ExpandableFab(
                    initialOpen: false,
                    child: const Icon(Icons.add),
                    key: controller.floatingButtonKeyLoggedOut,
                    children: const [],
                    onOpen: () {
                      controller.floatingButtonKeyLoggedOut.currentState!
                          .toggle();
                      hapticFeedbackController.hapticFeedback();
                      Get.toNamed('/add-update-alarm');
                    },
                  )),
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
                  hapticFeedbackController.hapticFeedback();
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
                    child: Obx(() {
                      return FutureBuilder(
                          future:
                              controller.initStream(controller.userModel.value),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              final Stream streamAlarms = snapshot.data;

                              return StreamBuilder(
                                  stream: streamAlarms,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: kprimaryColor,
                                      ));
                                    } else {
                                      final alarms = snapshot.data;
                                      controller.refreshUpcomingAlarms();
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
                                                        color:
                                                            kprimaryDisabledTextColor),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return ListView.separated(
                                          separatorBuilder: (context, _) {
                                            return SizedBox(
                                                height: height * 0.02);
                                          },
                                          itemCount: alarms.length + 1,
                                          itemBuilder: (context, index) {
                                            // Spacing after last card
                                            if (index == alarms.length) {
                                              return SizedBox(
                                                  height: height * 0.1);
                                            }
                                            final AlarmModel alarm =
                                                alarms[index];
                                            final time12 =
                                                Utils.convertTo12HourFormat(
                                                    alarm.alarmTime);
                                            final repeatDays =
                                                Utils.getRepeatDays(alarm.days);
                                            // Main card
                                            return InkWell(
                                              onTap: () {
                                                hapticFeedbackController.hapticFeedback();
                                                Get.toNamed('/add-update-alarm',
                                                    arguments: alarm);
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Card(
                                                    color:
                                                        ksecondaryBackgroundColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 25.0,
                                                          top: Utils.isChallengeEnabled(
                                                                      alarm) ||
                                                                  Utils
                                                                      .isAutoDismissalEnabled(
                                                                          alarm)
                                                              ? 8.0
                                                              : 0.0,
                                                          bottom: Utils.isChallengeEnabled(
                                                                      alarm) ||
                                                                  Utils
                                                                      .isAutoDismissalEnabled(
                                                                          alarm)
                                                              ? 8.0
                                                              : 0.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
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
                                                                    repeatDays.replaceAll(
                                                                        "Never",
                                                                        "One Time"),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color: alarm.isEnabled == true
                                                                              ? kprimaryColor
                                                                              : kprimaryDisabledTextColor,
                                                                        ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        time12[
                                                                            0],
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .displayLarge!
                                                                            .copyWith(
                                                                              color: alarm.isEnabled == true ? kprimaryTextColor : kprimaryDisabledTextColor,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 3.0),
                                                                        child:
                                                                            Text(
                                                                          time12[
                                                                              1],
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .displayMedium!
                                                                              .copyWith(
                                                                                color: alarm.isEnabled == true ? kprimaryTextColor : kprimaryDisabledTextColor,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  if (Utils.isChallengeEnabled(alarm) ||
                                                                      Utils.isAutoDismissalEnabled(
                                                                          alarm) ||
                                                                      alarm
                                                                          .isSharedAlarmEnabled)
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        if (alarm
                                                                            .isSharedAlarmEnabled)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.share_arrival_time,
                                                                              size: 24,
                                                                              color: kprimaryTextColor.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        if (alarm
                                                                            .isLocationEnabled)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.location_pin,
                                                                              size: 24,
                                                                              color: kprimaryTextColor.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        if (alarm
                                                                            .isActivityEnabled)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.screen_lock_portrait,
                                                                              size: 24,
                                                                              color: kprimaryTextColor.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        if (alarm
                                                                            .isWeatherEnabled)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.cloudy_snowing,
                                                                              size: 24,
                                                                              color: kprimaryTextColor.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        if (alarm
                                                                            .isQrEnabled)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.qr_code_scanner,
                                                                              size: 24,
                                                                              color: kprimaryTextColor.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        if (alarm
                                                                            .isShakeEnabled)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.vibration,
                                                                              size: 24,
                                                                              color: kprimaryTextColor.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        if (alarm
                                                                            .isMathsEnabled)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.calculate,
                                                                              size: 24,
                                                                              color: kprimaryTextColor.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 0,
                                                                    child:
                                                                        Switch(
                                                                      value: alarm
                                                                          .isEnabled,
                                                                      onChanged:
                                                                          (bool
                                                                              value) async {
                                                                                hapticFeedbackController.hapticFeedback();
                                                                        alarm.isEnabled =
                                                                            value;

                                                                        if (alarm.isSharedAlarmEnabled ==
                                                                            true) {
                                                                          await FirestoreDb.updateAlarm(
                                                                              alarm.ownerId,
                                                                              alarm);
                                                                        } else {
                                                                          await IsarDb.updateAlarm(
                                                                              alarm);
                                                                        }
                                                                        controller.refreshTimer =
                                                                            true;
                                                                        controller
                                                                            .refreshUpcomingAlarms();
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 0,
                                                                    child:
                                                                        PopupMenuButton(
                                                                      onSelected:
                                                                          (value) async {
                                                                            hapticFeedbackController.hapticFeedback();
                                                                        if (value ==
                                                                            0) {
                                                                          Get.back();
                                                                          Get.offNamed(
                                                                              '/alarm-ring',
                                                                              arguments: alarm);
                                                                        } else if (value ==
                                                                            1) {
                                                                          print(
                                                                              alarm.isSharedAlarmEnabled);

                                                                          if (alarm.isSharedAlarmEnabled ==
                                                                              true) {
                                                                            await FirestoreDb.deleteAlarm(controller.userModel.value,
                                                                                alarm.firestoreId!);
                                                                          } else {
                                                                            await IsarDb.deleteAlarm(alarm.isarId);
                                                                          }

                                                                          controller.refreshTimer =
                                                                              true;
                                                                          controller
                                                                              .refreshUpcomingAlarms();
                                                                        }
                                                                      },
                                                                      color:
                                                                          kprimaryBackgroundColor,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        color: alarm.isEnabled ==
                                                                                true
                                                                            ? kprimaryTextColor
                                                                            : kprimaryDisabledTextColor,
                                                                      ),
                                                                      itemBuilder:
                                                                          (context) {
                                                                        return [
                                                                          PopupMenuItem<
                                                                              int>(
                                                                            value:
                                                                                0,
                                                                            child:
                                                                                Text(
                                                                              "Preview Alarm",
                                                                              style: Theme.of(context).textTheme.bodyMedium,
                                                                            ),
                                                                          ),
                                                                          if (alarm.isSharedAlarmEnabled == false || (alarm.isSharedAlarmEnabled == true &&
                                                                              alarm.ownerId == controller.userModel.value!.id))
                                                                            PopupMenuItem<int>(
                                                                              value: 1,
                                                                              child: Text(
                                                                                "Delete Alarm",
                                                                                style: Theme.of(context).textTheme.bodyMedium,
                                                                              ),
                                                                            ),
                                                                        ];
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  });
                            } else {
                              return const CircularProgressIndicator();
                            }
                          });
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
