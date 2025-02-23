import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/alarm_ring_controller.dart';

// ignore: must_be_immutable
class AlarmControlView extends GetView<AlarmControlController> {
  AlarmControlView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  Obx getAddSnoozeButtons(
      BuildContext context, int snoozeMinutes, String title) {
    return Obx(
      () => TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            themeController.secondaryBackgroundColor.value,
          ),
        ),
        child: Text(
          title.tr,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: themeController.primaryTextColor.value,
                fontWeight: FontWeight.w600,
              ),
        ),
        onPressed: () {
          Utils.hapticFeedback();
          controller.addMinutes(snoozeMinutes);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }

        Get.snackbar(
          'Note'.tr,
          "You can't go back while the alarm is ringing".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Center(
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
                                ? "${controller.minutes.toString().padLeft(2, '0')}"
                                    ":${controller.seconds.toString().padLeft(2, '0')}"
                                : (controller.is24HourFormat.value)
                                    ? '${controller.timeNow24Hr}'
                                    : '${controller.timeNow[0]} ${controller.timeNow[1]}',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 50),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 0,
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.isSnoozing.value,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  getAddSnoozeButtons(context, 1, '+1 min'),
                                  getAddSnoozeButtons(context, 2, '+2 min'),
                                  getAddSnoozeButtons(context, 5, '+5 min'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () {
                        return Visibility(
                          visible: controller
                              .currentlyRingingAlarm.value.note.isNotEmpty,
                          child: Text(
                            controller.currentlyRingingAlarm.value.note,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: themeController.primaryTextColor.value,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        );
                      },
                    ),
                    Obx(
                      () => Visibility(
                        visible: !controller.isSnoozing.value,
                        child: Obx(
                          () => Padding(
                            padding: Get.arguments != null
                                ? const EdgeInsets.symmetric(vertical: 90.0)
                                : EdgeInsets.zero,
                            child: SizedBox(
                              height: height * 0.07,
                              width: width * 0.5,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    themeController
                                        .secondaryBackgroundColor.value,
                                  ),
                                ),
                                child: Text(
                                  'Snooze'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: themeController
                                            .primaryTextColor.value,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                onPressed: () {
                                  Utils.hapticFeedback();
                                  controller.startSnooze();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 80,
                left: width * 0.1,
                right: width * 0.1,
                child: Obx(
                  () => Visibility(
                    visible: controller.showButton.value,
                    child: SizedBox(
                      height: height * 0.07,
                      width: width * 0.8,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            kprimaryColor,
                          ),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          if (controller
                              .currentlyRingingAlarm.value.isGuardian) {
                            controller.guardianTimer.cancel();
                          }
                          if (Utils.isChallengeEnabled(
                            controller.currentlyRingingAlarm.value,
                          )) {
                            Get.toNamed(
                              '/alarm-challenge',
                              arguments: controller.currentlyRingingAlarm.value,
                            );
                          } else {
                            Get.offNamed(
                              '/bottom-navigation-bar',
                              arguments: controller.currentlyRingingAlarm.value,
                            );
                          }
                        },
                        child: Text(
                          Utils.isChallengeEnabled(
                            controller.currentlyRingingAlarm.value,
                          )
                              ? 'Start Challenge'.tr
                              : 'Dismiss'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: themeController.secondaryTextColor.value,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.red,
                  child: TextButton(
                    onPressed: () {
                      Utils.hapticFeedback();
                      Get.offNamed('/bottom-navigation-bar');
                    },
                    child: Text(
                      'Exit Preview'.tr,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
