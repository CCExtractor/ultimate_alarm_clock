import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_haptic_feedback.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_sorted_alarm_list.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/theme_value_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/weather_api.dart';
import '../controllers/settings_controller.dart';
import 'google_sign_in.dart';

class SettingsView extends GetView<SettingsController> {
  SettingsView({Key? key}) : super(key: key);

  HomeController homeController = Get.find<HomeController>();
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          elevation: 0.0,
          iconTheme: Theme.of(context).iconTheme,
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
                  themeController: themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                GoogleSignIn(
                  controller: controller,
                  width: width,
                  height: height,
                  themeController: themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                EnableHapticFeedback(
                  height: height,
                  width: width,
                  controller: controller,
                  themeController: themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                EnableSortedAlarmList(
                  controller: controller,
                  height: height,
                  width: width,
                  themeController: themeController,
                ),
                const SizedBox(
                  height: 20,
                ), 
                ThemeValueTile(
                  controller: controller,
                  height: height,
                  width: width,
                  themeController: themeController,
                ),
              ],
            ),
          ),
        ));
  }
}
