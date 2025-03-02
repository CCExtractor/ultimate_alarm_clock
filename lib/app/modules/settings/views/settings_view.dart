import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/debug/views/debug_screen.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/customize_undo_duration.dart';

import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_24Hour_format.dart';

import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_haptic_feedback.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/enable_sorted_alarm_list.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/language_menu.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/views/theme_value_tile.dart';
import 'package:ultimate_alarm_clock/app/routes/app_pages.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import '../controllers/settings_controller.dart';
import 'google_sign_in.dart';

class SettingsView extends GetView<SettingsController> {
  SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Settings'.tr,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: controller.themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Obx(
            () => Icon(
              Icons.adaptive.arrow_back,
              color: controller.themeController.primaryTextColor.value,
            ),
          ),
          onPressed: () {
            Utils.hapticFeedback();
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              children: [

                GoogleSignIn(
                  controller: controller,
                  width: width,
                  height: height,
                  themeController: controller.themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                EnableHapticFeedback(
                  height: height,
                  width: width,
                  controller: controller,
                  themeController: controller.themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Enable24HourFormat(
                  height: height,
                  width: width,
                  controller: controller,
                  themeController: controller.themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                EnableSortedAlarmList(
                  controller: controller,
                  height: height,
                  width: width,
                  themeController: controller.themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ThemeValueTile(
                  controller: controller,
                  height: height,
                  width: width,
                  themeController: controller.themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomizeUndoDuration(
                    width: width,
                    height: height,
                    themeController: controller.themeController),
                const SizedBox(
                  height: 20,
                ),
                LanguageMenu(
                  controller: controller,
                  height: height,
                  width: width,
                  themeController: controller.themeController,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    Get.to(DebugScreen());
                  },
                  child: Container(
                    width: width * 0.91,
                    height: height * 0.1,
                    decoration: Utils.getCustomTileBoxDecoration(
                      isLightMode:
                      controller.themeController.currentTheme.value == ThemeMode.light,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Debug screen',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                  
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
