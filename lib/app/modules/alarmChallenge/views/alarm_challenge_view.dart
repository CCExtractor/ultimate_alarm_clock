import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/views/maths_challenge_view.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/views/qr_challenge_view.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/views/shake_challenge_view.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../controllers/alarm_challenge_controller.dart';

class AlarmChallengeView extends GetView<AlarmChallengeController> {
  const AlarmChallengeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;

    return GestureDetector(
      onTap: () => controller.restartTimer(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => LinearProgressIndicator(
                minHeight: 2,
                value: controller.progress.value,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor),
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
                          InkWell(
                            onTap: () {
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
                            child: Container(
                              width: width * 0.91,
                              height: height * 0.1,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                color: ksecondaryBackgroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.vibration,
                                    color: kprimaryTextColor.withOpacity(0.8),
                                    size: 28,
                                  ),
                                  Text(
                                    'Shake Challenge',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: kprimaryTextColor,
                                        ),
                                  ),
                                  Obx(
                                    () => Icon(
                                      (controller.alarmRecord.isShakeEnabled)
                                          ? controller.isShakeOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.arrow_forward_ios_sharp
                                          : controller.isShakeOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.close,
                                      color: kprimaryTextColor.withOpacity(0.2),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 0,
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.isMathsOngoing.value !=
                                      Status.completed &&
                                  controller.alarmRecord.isMathsEnabled) {
                                controller.isMathsOngoing.value =
                                    Status.ongoing;
                                Get.to(() => MathsChallengeView());
                              }
                            },
                            child: Container(
                              width: width * 0.91,
                              height: height * 0.1,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                color: ksecondaryBackgroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.calculate_sharp,
                                    color: kprimaryTextColor.withOpacity(0.8),
                                    size: 28,
                                  ),
                                  Text(
                                    'Maths Challenge',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: kprimaryTextColor,
                                        ),
                                  ),
                                  Obx(
                                    () => Icon(
                                      (controller.alarmRecord.isMathsEnabled)
                                          ? controller.isQrOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.arrow_forward_ios_sharp
                                          : controller.isQrOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.close,
                                      color: kprimaryTextColor.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 0,
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.isQrOngoing.value !=
                                      Status.completed &&
                                  controller.alarmRecord.isQrEnabled) {
                                Get.to(() => QRChallengeView());
                              }
                            },
                            child: Container(
                              width: width * 0.91,
                              height: height * 0.1,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                color: ksecondaryBackgroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.qr_code_scanner,
                                    color: kprimaryTextColor.withOpacity(0.8),
                                    size: 28,
                                  ),
                                  Text(
                                    'QR/Bar Code Challenge',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: kprimaryTextColor,
                                        ),
                                  ),
                                  Obx(
                                    () => Icon(
                                      (controller.alarmRecord.isQrEnabled)
                                          ? controller.isQrOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.arrow_forward_ios_sharp
                                          : controller.isQrOngoing.value ==
                                                  Status.completed
                                              ? Icons.done
                                              : Icons.close,
                                      color: kprimaryTextColor.withOpacity(0.2),
                                    ),
                                  ),
                                ],
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
