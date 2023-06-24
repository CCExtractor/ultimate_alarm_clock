import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class RepeatTile extends StatelessWidget {
  const RepeatTile({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: ksecondaryBackgroundColor,
            title: 'Repeat',
            titleStyle: Theme.of(context).textTheme.displayMedium,
            content: Obx(
              () => Column(
                children: [
                  InkWell(
                    onTap: () {
                      controller.repeatDays[0] = !controller.repeatDays[0];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                side: BorderSide(
                                    width: 1.5,
                                    color: kprimaryTextColor.withOpacity(0.5)),
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
                      controller.repeatDays[1] = !controller.repeatDays[1];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                side: BorderSide(
                                    width: 1.5,
                                    color: kprimaryTextColor.withOpacity(0.5)),
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
                      controller.repeatDays[2] = !controller.repeatDays[2];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                side: BorderSide(
                                    width: 1.5,
                                    color: kprimaryTextColor.withOpacity(0.5)),
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
                      controller.repeatDays[3] = !controller.repeatDays[3];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                side: BorderSide(
                                    width: 1.5,
                                    color: kprimaryTextColor.withOpacity(0.5)),
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
                      controller.repeatDays[4] = !controller.repeatDays[4];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                side: BorderSide(
                                    width: 1.5,
                                    color: kprimaryTextColor.withOpacity(0.5)),
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
                      controller.repeatDays[5] = !controller.repeatDays[5];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                side: BorderSide(
                                    width: 1.5,
                                    color: kprimaryTextColor.withOpacity(0.5)),
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
                      controller.repeatDays[6] = !controller.repeatDays[6];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                side: BorderSide(
                                    width: 1.5,
                                    color: kprimaryTextColor.withOpacity(0.5)),
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
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kprimaryColor
                                // Set the desired background color
                                ),
                            child: Text(
                              'Done',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: ksecondaryTextColor),
                            ),
                          ),
                        ],
                      ),
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
                  color: kprimaryTextColor, fontWeight: FontWeight.w500)),
          trailing:
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
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
    );
  }
}
