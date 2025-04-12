import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timerRing/controllers/timer_ring_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/uac_text_button.dart';

class TimerRingView extends GetView<TimerRingController> {
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }

        Get.snackbar(
          'Note',
          "You can't go back while the timer is ringing",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: height * 0.06,
              width: width * 0.8,
              child: UACTextButton(
                isButtonPrimary: true,
                isTextPrimary: false,
                text: 'Stop'.tr,
                onPressed: () async {
                  Get.offNamed('/bottom-navigation-bar');
                },
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/in_no_time.svg',
                  height: height * 0.3,
                  width: width * 0.8,
                ),
                SizedBox(
                  height: height * 0.10,
                ),
                Obx(
                  () => Text(
                    'Time\'s up!',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: themeController.primaryTextColor.value,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
