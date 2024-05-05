import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmRing/controllers/alarm_ring_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timerRing/controllers/timer_ring_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class TimerRingView extends GetView<TimerRingController> {
  TimerRingView({super.key});
  final themeController = Get.find<ThemeController>();

  TextButton getAddRestartButtons(
    BuildContext context,
    int restartMinutes,
    String title,
  ) {
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
        controller.addMinutes(restartMinutes);
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
          'Note',
          "You can't go back while the timer is ringing",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: height * 0.06,
              width: width * 0.8,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    kprimaryColor,
                  ),
                ),
                onPressed: () async {
                  Get.offNamed('/bottom-navigation-bar');
                },
                child: Text(
                  'Dismiss',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor
                            : ksecondaryTextColor,
                      ),
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Column(
                    children: [
                      (controller.isStart.value)
                          ? Column(
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
                                  // ignore: lines_longer_than_80_chars
                                  "${controller.minutes.toString().padLeft(2, '0')}"
                                  // ignore: lines_longer_than_80_chars
                                  ":${controller.seconds.toString().padLeft(2, '0')}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(fontSize: 50),
                                ),
                              ],
                            )
                          :SvgPicture.asset(
                              'assets/images/in_no_time.svg',
                              height: height * 0.3,
                              width: width * 0.8,
                            ),
                      SizedBox(
                        height: height * 0.10,
                      ),
                      Text(
                        'Time\'s up!',
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryTextColor
                                      : kprimaryTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(
                        height: 20,
                        width: 0,
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.isStart.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              getAddRestartButtons(context, 1, '+1 min'),
                              getAddRestartButtons(context, 2, '+2 min'),
                              getAddRestartButtons(context, 5, '+5 min'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: AlarmControlController()
                        .currentlyRingingAlarm
                        .value
                        .note
                        .isNotEmpty,
                    child: Text(
                      AlarmControlController().currentlyRingingAlarm.value.note,
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
                    visible: !controller.isStart.value,
                    child: Obx(
                      () => Padding(
                        padding: Get.arguments != null
                            ? const EdgeInsets.symmetric(vertical: 90.0)
                            : EdgeInsets.zero,
                        child: SizedBox(
                          height: height * 0.06,
                          width: width * 0.8,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                kprimaryColor,
                              ),
                            ),
                            child: Text(
                              'Restart'.tr,
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
                              controller.reStartTimer();
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
