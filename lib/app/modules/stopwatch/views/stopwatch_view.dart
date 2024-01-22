import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controllers/stopwatch_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../controllers/stopwatch_controller.dart';

class StopwatchView extends GetView<StopwatchController> {
  StopwatchView({Key? key}) : super(key: key);
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / 7.9),
        child: AppBar(
          toolbarHeight: height / 7.9,
          elevation: 0.0,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Utils.hapticFeedback();
                controller.saveTimerStateToStorage();
                Get.toNamed('/settings');
              },
              icon: const Icon(
                Icons.settings,
                size: 27,
              ),
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor.withOpacity(0.75)
                  : kprimaryTextColor.withOpacity(0.75),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  controller.result,
                  style: const TextStyle(
                      fontSize: 60.0, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: controller.toggleTimer,
                  child: Obx(() => Icon(
                        controller.isTimerPaused.value
                            ? Icons.play_arrow
                            : Icons.pause,
                      )),
                ),
                // Reset button
                FloatingActionButton(
                  onPressed: controller.resetTime,
                  child: Icon(Icons.square_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
