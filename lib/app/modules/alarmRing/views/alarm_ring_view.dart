import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:vibration/vibration.dart';

import '../controllers/alarm_ring_controller.dart';

class AlarmControlView extends GetView<AlarmControlController> {
  const AlarmControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Obx(
                        () => SizedBox(
                          height: height * 0.06,
                          width: width * 0.8,
                          child: controller.showButton.value
                              ? TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kprimaryColor)),
                                  child: Text(
                                    Utils.isChallengeEnabled(controller
                                            .currentlyRingingAlarm.value)
                                        ? 'Start Challenge'
                                        : 'Dismiss',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(color: ksecondaryTextColor),
                                  ),
                                  onPressed: () {
                                    if (Utils.isChallengeEnabled(controller
                                        .currentlyRingingAlarm.value)) {
                                      Get.toNamed('/alarm-challenge',
                                          arguments: controller
                                              .currentlyRingingAlarm.value);
                                    } else {
                                      Get.offNamed('/home');
                                    }
                                  },
                                )
                              : SizedBox(),
                        ),
                      )),
                  (Get.arguments != null)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: height * 0.06,
                              width: width,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kprimaryTextColor.withOpacity(0.7))),
                                child: Text(
                                  'Exit Preview',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: ksecondaryTextColor),
                                ),
                                onPressed: () {
                                  Get.offNamed('/home');
                                },
                              )),
                        )
                      : SizedBox()
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                      () => Column(
                        children: [
                          Text(
                            controller.formattedDate.value,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 10,
                            width: 0,
                          ),
                          Text(
                            (controller.isSnoozing.value)
                                ? "${controller.minutes.toString().padLeft(2, '0')}:${controller.seconds.toString().padLeft(2, '0')}"
                                : "${controller.timeNow[0]} ${controller.timeNow[1]}",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 50),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.055,
                      width: width * 0.25,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ksecondaryBackgroundColor)),
                        child: Text(
                          'Snooze',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: kprimaryTextColor,
                                  fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          controller.startSnooze();
                        },
                      ),
                    )
                  ],
                ),
              )),
        ),
        onWillPop: () async {
          Get.snackbar("Note", "You can't go back while the alarm is ringing");
          return false;
        });
  }
}
