import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controllers/stopwatch_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/end_drawer.dart';
import '../../../utils/utils.dart';

// ignore: must_be_immutable
class StopwatchView extends GetView<StopwatchController> {
  StopwatchView({super.key});
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: controller.hasFlags.value ? height * 0.1 : height * 0.3,
              ),
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
                  heroTag: 'flag',
                  onPressed: controller.addFlag,
                  child: Icon(
                    Icons.flag,
                    size: 33,
                    color: themeController.secondaryTextColor.value,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'start',
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
                  heroTag: 'stop',
                  onPressed: controller.resetTime,
                  child: const Icon(
                    Icons.stop_rounded,
                    size: 33,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Obx(
                () => AnimatedList(
                  key: controller.listKey, // Add this key to controller
                  initialItemCount: controller.flags.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index, animation) {
                    final reversedIndex = controller.flags.length - 1 - index;
                    return SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: const Offset(0, -0.3),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: ListTile(
                        minVerticalPadding: 0,
                        title: Text(
                          '${controller.flags[reversedIndex].number}',
                          style: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        trailing: Text(
                          "+${DateFormat('mm:ss:SS').format(
                            DateTime(0)
                                .add(controller.flags[reversedIndex].lapTime),
                          )}",
                          style: TextStyle(
                            fontSize: 12.0,
                            height: -0.5,
                            color:
                                themeController.primaryDisabledTextColor.value,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('mm:ss:SS').format(
                            DateTime(0)
                                .add(controller.flags[reversedIndex].totalTime),
                          ),
                          style: TextStyle(
                            fontSize: 14.0,
                            color:
                                themeController.primaryDisabledTextColor.value,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
        endDrawer: buildEndDrawer(context),);
  }
}
