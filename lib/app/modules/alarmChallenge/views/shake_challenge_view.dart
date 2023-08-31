import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'dart:math' as math;

import '../controllers/alarm_challenge_controller.dart';

class ShakeChallengeView extends GetView<AlarmChallengeController> {
  ShakeChallengeView({Key? key}) : super(key: key);

  final HapticFeebackService _hapticFeebackService = Get.find();

  void _hapticFeedback() {
    _hapticFeebackService.hapticFeedback();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var width = Get.width;
    var height = Get.height;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            _hapticFeedback();
            controller.restartTimer();
          },
          child: Column(
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
                            Text(
                              'Shake your phone!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          kprimaryTextColor.withOpacity(0.7)),
                            ),
                            SizedBox(
                              height: height * 0.08,
                            ),
                            Transform.rotate(
                              angle: -10 * math.pi / 180,
                              child: Icon(
                                Icons.vibration,
                                size: height * 0.2,
                                color: kprimaryTextColor.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.08,
                            ),
                            Obx(
                              () => Text(
                                controller.shakedCount.value.toString(),
                                style: TextStyle(fontSize: 35),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
