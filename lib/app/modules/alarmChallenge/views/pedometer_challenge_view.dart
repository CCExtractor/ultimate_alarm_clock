// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/controllers/alarm_challenge_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class PedometerChallengeView extends GetView<AlarmChallengeController> {
  PedometerChallengeView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: GestureDetector(
        onTap: () {
          Utils.hapticFeedback();
          controller.restartTimer();
        },
        child: Column(
          children: [
            // --- THE NEW MASSIVE TEXT TIMER ---
            // --- THE OPTIMIZED TEXT TIMER ---
            Obx(() {
              // Directly read the clean integer from the new engine!
              int secondsLeft = controller.timeRemaining.value;
              String timerText = "00:${secondsLeft.toString().padLeft(2, '0')}";

              return Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Text(
                  timerText,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: secondsLeft <= 5
                        ? Colors.red
                        : themeController.primaryTextColor.value,
                  ),
                ),
              );
            }),
            // -----------------------------------
            // -----------------------------------
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                                () => Text(
                              'Walk it Out!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                                color: themeController.primaryTextColor.value.withOpacity(0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.08,
                          ),
                          Obx(
                                () => Icon(
                              Icons.directions_walk,
                              size: height * 0.2,
                              color: themeController.primaryTextColor.value.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.08,
                          ),
                          Obx(
                                () => Text(
                              (controller.alarmRecord.numberOfSteps -
                                  controller.stepsCount.value >=
                                  0
                                  ? controller.alarmRecord.numberOfSteps -
                                  controller.stepsCount.value
                                  : 0)
                                  .toString(),
                              style: const TextStyle(fontSize: 35),
                            ),
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