import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/alarm_ring_ignore_controller.dart';

class AlarmControlIgnoreView extends GetView<AlarmControlIgnoreController> {
  AlarmControlIgnoreView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: height * 0.06,
              width: width * 0.8,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kprimaryColor)),
                child: Text(
                  'Dismiss',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: themeController.isLightMode.value
                          ? kLightPrimaryTextColor
                          : ksecondaryTextColor),
                ),
                onPressed: () {
                  Utils.hapticFeedback();
                  Get.offNamed('/home');
                },
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => Column(
                    children: [
                      Text(
                        controller.formattedDate.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 10,
                        width: 0,
                      ),
                      Text(
                        "${controller.timeNow[0]} ${controller.timeNow[1]}",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontSize: 50),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.055,
                  width: width * 0.25,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            themeController.isLightMode.value ? kLightSecondaryBackgroundColor : ksecondaryBackgroundColor)),
                    child: Text(
                      'Snooze',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Utils.hapticFeedback();
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
