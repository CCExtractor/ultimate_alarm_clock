import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timerRing/controllers/timer_ring_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class TimerRingView extends GetView<TimerRingController> {
  final ThemeController themeController = Get.find<ThemeController>();

  TimerRingView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: height * 0.06,
              width: width * 0.8,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    kprimaryColor,
                  ),
                ),
                onPressed: () async {
                  Get.offNamed('/bottom-navigation-bar');
                },
                child: Text(
                  'Stop',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor
                            : ksecondaryTextColor,
                      ),
                ),
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
                Text(
                  'Time\'s up!',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor
                            : kprimaryTextColor,
                        fontWeight: FontWeight.bold,
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
