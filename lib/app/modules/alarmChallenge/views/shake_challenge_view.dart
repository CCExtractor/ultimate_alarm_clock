import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'dart:math' as math;

import '../controllers/alarm_challenge_controller.dart';

// ignore: must_be_immutable
class ShakeChallengeView extends GetView<AlarmChallengeController> {
  ShakeChallengeView({super.key});

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    // var width = Get.width;
    // var height = Get.height;
    // ignore: unused_local_variable
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
                          Obx(
                            () => Text(
                              'Shake your phone!'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: themeController
                                        .primaryTextColor.value
                                        .withOpacity(0.7),
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.08,
                          ),
                          Obx(
                            () => Transform.rotate(
                              angle: -10 * math.pi / 180,
                              child: Icon(
                                Icons.vibration,
                                size: height * 0.2,
                                color: themeController.primaryTextColor.value
                                    .withOpacity(0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.08,
                          ),
                          Obx(
                            () => Text(
                              controller.shakedCount.value.toString(),
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
