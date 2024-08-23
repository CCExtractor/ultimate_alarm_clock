import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/views/maths_challenge_view.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/views/pedometer_challenge_view.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/views/qr_challenge_view.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/views/shake_challenge_view.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/alarm_challenge_controller.dart';

class AlarmChallengeView extends GetView<AlarmChallengeController> {
  AlarmChallengeView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;

    return GestureDetector(
      onTap: () {
        Utils.hapticFeedback();
        controller.restartTimer();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => LinearProgressIndicator(
                minHeight: 2,
                value: controller.progress.value,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(kprimaryColor),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (controller.alarmRecord.isShakeEnabled)
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.isShakeOngoing.value !=
                                        Status.completed &&
                                    controller.alarmRecord.isShakeEnabled) {
                                  controller.shakedCount.value =
                                      controller.alarmRecord.shakeTimes;
                                  controller.isShakeOngoing.value =
                                      Status.ongoing;
                                  Get.to(() => ShakeChallengeView());
                                }
                              },
                              child: Obx(
                                () => Container(
                                  width: width * 0.91,
                                  height: height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(18),
                                    ),
                                    color: themeController.secondaryBackgroundColor.value,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.vibration,
                                        color: themeController.primaryTextColor.value.withOpacity(0.8),
                                        size: 28,
                                      ),
                                      Text(
                                        'Shake Challenge'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: themeController.primaryTextColor.value,
                                            ),
                                      ),
                                      Obx(
                                        () => Icon(
                                          controller.isShakeOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.arrow_forward_ios_sharp,
                                          color: themeController.primaryTextColor.value
                                                  .withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                            width: 0,
                          ),
                          if (controller.alarmRecord.isMathsEnabled)
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.isMathsOngoing.value !=
                                        Status.completed &&
                                    controller.alarmRecord.isMathsEnabled) {
                                  controller.isMathsOngoing.value =
                                      Status.ongoing;
                                  Get.to(() => MathsChallengeView());
                                }
                              },
                              child: Obx(
                                () => Container(
                                  width: width * 0.91,
                                  height: height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(18),
                                    ),
                                    color: themeController.secondaryBackgroundColor.value,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.calculate_sharp,
                                        color: themeController.primaryTextColor.value.withOpacity(0.8),
                                        size: 28,
                                      ),
                                      Text(
                                        'Maths Challenge'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: themeController.primaryTextColor.value,
                                            ),
                                      ),
                                      Obx(
                                        () => Icon(
                                          controller.isQrOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.arrow_forward_ios_sharp,
                                          color: themeController.primaryTextColor.value
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                            width: 0,
                          ),
                          if (controller.alarmRecord.isQrEnabled)
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.isQrOngoing.value !=
                                        Status.completed &&
                                    controller.alarmRecord.isQrEnabled) {
                                  Get.to(() => QRChallengeView());
                                }
                              },
                              child: Obx(
                                 () => Container(
                                  width: width * 0.91,
                                  height: height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(18),
                                    ),
                                    color: themeController.secondaryBackgroundColor.value,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner,
                                        color: themeController.primaryTextColor.value.withOpacity(0.8),
                                        size: 28,
                                      ),
                                      Text(
                                        'QR/Bar Code Challenge'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: themeController.primaryTextColor.value,
                                            ),
                                      ),
                                      Obx(
                                        () => Icon(
                                          controller.isQrOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.arrow_forward_ios_sharp,
                                          color: themeController.primaryTextColor.value
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                            width: 0,
                          ),
                          if (controller.alarmRecord.isPedometerEnabled)
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.isPedometerOngoing.value !=
                                        Status.completed &&
                                    controller.alarmRecord.isPedometerEnabled) {
                                  controller.numberOfSteps =
                                      controller.alarmRecord.numberOfSteps;
                                  controller.isPedometerOngoing.value =
                                      Status.ongoing;
                                  Get.to(() => PedometerChallengeView());
                                }
                              },
                              child: Obx(
                                () => Container(
                                  width: width * 0.91,
                                  height: height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(18),
                                    ),
                                    color: themeController.secondaryBackgroundColor.value,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.directions_walk,
                                        color: themeController.primaryTextColor.value.withOpacity(0.8),
                                        size: 28,
                                      ),
                                      Text(
                                        'Pedometer Challenge',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: themeController.primaryTextColor.value,
                                            ),
                                      ),
                                      Obx(
                                        () => Icon(
                                          controller.isPedometerOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.arrow_forward_ios_sharp,
                                          color: themeController.primaryTextColor.value
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                            width: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
