import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_haptic_feedback.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/weather_api.dart';
import '../controllers/settings_controller.dart';
import 'google_sign_in.dart';

class SettingsView extends GetView<SettingsController> {
  SettingsView({Key? key}) : super(key: key);

  final HapticFeedbackController hapticFeedbackController =
      Get.find<HapticFeedbackController>();

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              children: [
                WeatherApi(
                  controller: controller,
                  width: width,
                  height: height,
                  hapticFeedbackController: hapticFeedbackController,
                ),
                const SizedBox(
                  height: 20,
                ),
                GoogleSignIn(
                  controller: controller,
                  width: width,
                  height: height,
                  hapticFeedbackController: hapticFeedbackController,
                ),
                const SizedBox(
                  height: 20,
                ),
                EnableHapticFeedback(
                  controller: hapticFeedbackController,
                  height: height,
                  width: width,
                ),
              ],
            ),
          ),
        ));
  }
}
