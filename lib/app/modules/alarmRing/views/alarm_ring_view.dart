import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/alarm_ring_controller.dart';

class AlarmControlView extends GetView<AlarmControlController> {
  AlarmControlView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  TextButton getAddSnoozeButtons(
      BuildContext context, int snoozeMinutes, String title) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
        ),
      ),
      child: Text(
        title.tr,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor
                  : kprimaryTextColor,
              fontWeight: FontWeight.w600,
            ),
      ),
      onPressed: () {
        Utils.hapticFeedback();
        controller.addMinutes(snoozeMinutes);
      },
    );
  }

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

        Get.snackbar(
          'Note'.tr,
          "You can't go back while the alarm is ringing".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Obx(
                  () => SizedBox(
                    height: height * 0.06,
                    width: width * 0.8,
                    child: controller.showButton.value
                        ? TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                kprimaryColor,
                              ),
                            ),
                            child: Text(
                              Utils.isChallengeEnabled(
                                controller.currentlyRingingAlarm.value,
                              )
                                  ? 'Start Challenge'.tr
                                  : 'Dismiss'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryTextColor
                                        : ksecondaryTextColor,
                                  ),
                            ),
                            onPressed: () async {
                              Utils.hapticFeedback();
                              if (Utils.isChallengeEnabled(
                                controller.currentlyRingingAlarm.value,
                              )) {
                                Get.toNamed(
                                  '/alarm-challenge',
                                  arguments:
                                      controller.currentlyRingingAlarm.value,
                                );
                              } else {
                                await controller.deleteOneTimeAlarm(
                                    controller.currentlyRingingAlarm.value);
                                Get.offNamed(
                                  '/bottom-navigation-bar',
                                  arguments:
                                      controller.currentlyRingingAlarm.value,
                                );
                              }
                            },
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              (Get.arguments != null)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => SizedBox(
                          height: height * 0.06,
                          width: width,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                themeController.isLightMode.value
                                    ? kLightPrimaryTextColor.withOpacity(0.7)
                                    : kprimaryTextColor.withOpacity(0.7),
                              ),
                            ),
                            child: Text(
                              'Exit Preview'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryTextColor
                                        : ksecondaryTextColor,
                                  ),
                            ),
                            onPressed: () {
                              Utils.hapticFeedback();
                              Get.offNamed('/bottom-navigation-bar');
                            },
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
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
                            ? "${controller.minutes.toString().padLeft(2, '0')}"
                                // ignore: lines_longer_than_80_chars
                                ":${controller.seconds.toString().padLeft(2, '0')}"
                            : '${controller.timeNow[0]} '
                                '${controller.timeNow[1]}',
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
                  () => Visibility(
                    visible:
                        controller.currentlyRingingAlarm.value.note.isNotEmpty,
                    child: Text(
                      controller.currentlyRingingAlarm.value.note,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
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
                                themeController.isLightMode.value
                                    ? kLightSecondaryBackgroundColor
                                    : ksecondaryBackgroundColor,
                              ),
                            ),
                            child: Text(
                              'Snooze'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryTextColor
                                        : kprimaryTextColor,
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
        ),
      ),
    );
  }
}
