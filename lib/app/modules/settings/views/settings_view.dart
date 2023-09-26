import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_haptic_feedback.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_sorted_alarm_list.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/weather_api.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import '../controllers/settings_controller.dart';
import 'google_sign_in.dart';

class SettingsView extends GetView<SettingsController> {
  SettingsView({Key? key}) : super(key: key);

  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.adaptive.arrow_back),
            onPressed: () {
              Utils.hapticFeedback();
              Navigator.of(context).pop();
            },
          ),
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
                ),
                const SizedBox(
                  height: 20,
                ),
                GoogleSignIn(
                  controller: controller,
                  width: width,
                  height: height,
                ),
                const SizedBox(
                  height: 20,
                ),
                EnableHapticFeedback(
                  height: height,
                  width: width,
                  controller: controller,
                ),
                const SizedBox(
                  height: 20,
                ),
                EnableSortedAlarmList(
                  controller: controller,
                  height: height,
                  width: width,
                ),
              ],
            ),
          ),
        ));
  }
}
