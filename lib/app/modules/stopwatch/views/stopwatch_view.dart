import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controllers/stopwatch_controller.dart';
import 'package:ultimate_alarm_clock/app/routes/app_pages.dart';
import 'package:ultimate_alarm_clock/app/utils/end_drawer.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

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
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Obx(
                      () => IconButton(
                        onPressed: () {
                      Utils.hapticFeedback();
                      Scaffold.of(context).openEndDrawer();
                    },
                        icon: const Icon(
                      Icons.menu,
                    ),
                        color: themeController.primaryTextColor.value
                        .withOpacity(0.75),
                        iconSize: 27,
                    // splashRadius: 0.000001,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.3,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      controller.result.split(':')[0],
                      style: const TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller.result.split(':')[1],
                      style: const TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller.result.split(':')[2],
                      style: const TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "start",
                onPressed: controller.toggleTimer,
                child: Obx(
                  () => Icon(
                    controller.isTimerPaused.value
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    size: 33,
                  ),
                ),
              ),
              // Reset button
              FloatingActionButton(
                heroTag: "stop",
                onPressed: controller.resetTime,
                child: Icon(
                  Icons.stop_rounded,
                  size: 33,
                ),
              ),
            ],
          ),
        ],
      ),
      endDrawer: buildEndDrawer(context)
    );
  }
}
