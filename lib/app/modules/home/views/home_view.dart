import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
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
        onPressed: () => Get.toNamed('add-alarm'),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: GlowingOverscrollIndicator(
              color: kprimaryDisabledTextColor,
              axisDirection: AxisDirection.down,
              child: StreamBuilder<QuerySnapshot>(
                  stream: controller.streamAlarms,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: kprimaryColor,
                      ));
                    } else {
                      final alarms =
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return AlarmModel.fromDocumentSnapshot(
                            documentSnapshot: document);
                      }).toList();

                      alarms.sort((a, b) => a.isEnabled == b.isEnabled
                          ? 0
                          : a.isEnabled
                              ? -1
                              : 1);
                      if (alarms.isEmpty) {
                        return Center(
                            child: Text(
                          'Add an alarm to get started!',
                          style: Theme.of(context).textTheme.displaySmall,
                        ));
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
                            final alarm = alarms[index];
                            final time12 =
                                Utils.convertTo12HourFormat(alarm.alarmTime);
                            return Center(
                              child: Container(
                                width: width * 0.91,
                                height: height * 0.135,
                                decoration: const BoxDecoration(
                                    color: ksecondaryBackgroundColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('One Time',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: (alarm
                                                                        .isEnabled ==
                                                                    true)
                                                                ? kprimaryTextColor
                                                                : kprimaryDisabledTextColor)),
                                                Row(
                                                  children: [
                                                    Text(
                                                      time12[0],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayLarge!
                                                          .copyWith(
                                                              color: (alarm
                                                                          .isEnabled ==
                                                                      true)
                                                                  ? kprimaryTextColor
                                                                  : kprimaryDisabledTextColor),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 3.0),
                                                      child: Text(
                                                        time12[1],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                                color: (alarm
                                                                            .isEnabled ==
                                                                        true)
                                                                    ? kprimaryTextColor
                                                                    : kprimaryDisabledTextColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                        // Flexible(
                                        //   flex: 3,
                                        //   child: Transform.rotate(
                                        //     angle: 30 * math.pi / 180,
                                        //     child: VerticalDivider(
                                        //       color: kprimaryColor,
                                        //       thickness: 3.5,
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 0,
                                                child: Switch(
                                                    value: alarm.isEnabled,
                                                    onChanged: (bool value) {
                                                      alarm.isEnabled = value;
                                                      FirestoreDb.updateAlarm(
                                                          alarm);
                                                    }),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: PopupMenuButton(
                                                  onSelected: (value) {
                                                    if (value == 0) {
                                                      Get.back();
                                                      Get.offNamed(
                                                          'alarm-control');
                                                    } else if (value == 1) {
                                                      FirestoreDb.deleteAlarm(
                                                          alarm.id!);
                                                    }
                                                  },
                                                  color:
                                                      kprimaryBackgroundColor,
                                                  icon: Icon(Icons.more_vert,
                                                      color: (alarm.isEnabled ==
                                                              true)
                                                          ? kprimaryTextColor
                                                          : kprimaryDisabledTextColor),
                                                  itemBuilder: (context) {
                                                    return [
                                                      PopupMenuItem<int>(
                                                        value: 0,
                                                        child: Text(
                                                          "Preview Alarm",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 1,
                                                        child: Text(
                                                          "Delete Alarm",
                                                          style:
                                                              Theme.of(context)
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
                            );
                          });
                    }
                  }),
            ),
          ),
        ],
      )),
    );
  }
}
