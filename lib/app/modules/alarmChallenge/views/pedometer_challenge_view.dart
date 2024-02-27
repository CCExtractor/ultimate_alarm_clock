import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/controllers/alarm_challenge_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class PedometerChallengeView extends GetView<AlarmChallengeController> {
  PedometerChallengeView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    var height = Get.height;

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
                          Text(
                            'Walk it Out!',
                            style:
                                Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryTextColor.withOpacity(0.7)
                                          : kprimaryTextColor.withOpacity(0.7),
                                    ),
                          ),
                          SizedBox(
                            height: height * 0.08,
                          ),
                          Icon(
                            Icons.directions_walk,
                            size: height * 0.2,
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor.withOpacity(0.7)
                                : kprimaryTextColor.withOpacity(0.7),
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
