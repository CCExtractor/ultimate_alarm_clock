import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class TimerView extends GetView<TimerController> {
  TimerView({Key? key}) : super(key: key);
  String timeLabel = '00 hrs : 00 min : 00 sec';
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
      body: Obx(
        () => controller.isTimerRunning.value
            ? Column(
                children: [
                  Text(timeLabel),
                  SizedBox(height: 10),
                  SizedBox(
                    height: height * 0.3,
                  ),
                  Center(
                    child: Obx(() {
                      final hours = controller.strDigits(
                        controller.remainingTime.value.inHours.remainder(24),
                      );
                      final minutes = controller.strDigits(
                        controller.remainingTime.value.inMinutes.remainder(60),
                      );
                      final seconds = controller.strDigits(
                        controller.remainingTime.value.inSeconds.remainder(60),
                      );
                      return Text(
                        '$hours:$minutes:$seconds',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeController.isLightMode.value
                              ? kLightPrimaryTextColor
                              : kprimaryTextColor,
                          fontSize: 50,
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: height * 0.15,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        SizedBox(
                          width: width * 0.20,
                        ),
                        FloatingActionButton.small(
                          heroTag: 'stop',
                          onPressed: () async {
                            Utils.hapticFeedback();
                            controller.stopTimer();
                            int timerId =
                                await SecureStorageProvider().readTimerId();
                            await IsarDb.deleteAlarm(timerId);
                          },
                          child: const Icon(Icons.close),
                        ),
                        SizedBox(
                          width: width * 0.11,
                        ),
                        FloatingActionButton(
                          heroTag: 'pause',
                          onPressed: () {
                            Utils.hapticFeedback();
                            controller.isTimerPaused.value
                                ? controller.resumeTimer()
                                : controller.pauseTimer();
                          },
                          child: Icon(
                            controller.isTimerPaused.value
                                ? Icons.play_arrow
                                : Icons.pause,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Obx(
                () => Stack(
                  children: [
                    ListView(
                      children: [
                        Text(
                          'Hours : Minutes : Seconds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kLightPrimaryBackgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          color: themeController.isLightMode.value
                              ? kLightPrimaryBackgroundColor
                              : kprimaryBackgroundColor,
                          height: height * 0.32,
                          width: width,
                          child: Obx(
                            () => TimePickerSpinner(
                              time: DateTime(0, 0, 0, 0, 1, 0),
                              minutesInterval: 1,
                              secondsInterval: 1,
                              is24HourMode: true,
                              isShowSeconds: true,
                              alignment: Alignment.center,
                              normalTextStyle: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryDisabledTextColor
                                        : kprimaryDisabledTextColor,
                                  ),
                              highlightedTextStyle:
                                  Theme.of(context).textTheme.displayMedium,
                              onTimeChange: (dateTime) {
                                final hours = dateTime.hour;
                                final minutes = dateTime.minute;
                                final seconds = dateTime.second;
                                timeLabel='Timer Duration - $hours hrs : $minutes min : $seconds sec';
                                Utils.hapticFeedback();
                                controller.remainingTime.value = Duration(
                                  hours: hours,
                                  minutes: minutes,
                                  seconds: seconds,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: Obx(
        () => controller.isTimerRunning.value
            ? const SizedBox()
            : Obx(
                () => AbsorbPointer(
                  absorbing: controller.remainingTime.value.inHours == 0 &&
                          controller.remainingTime.value.inMinutes == 0 &&
                          controller.remainingTime.value.inSeconds == 0
                      ? true
                      : false,
                  child: FloatingActionButton(
                    onPressed: () {
                            Utils.hapticFeedback();
                            controller.startTimer();
                            controller.createTimer();
                          },
                    backgroundColor:
                        controller.remainingTime.value.inHours == 0 &&
                                controller.remainingTime.value.inMinutes == 0 &&
                                controller.remainingTime.value.inSeconds == 0
                            ? kprimaryDisabledTextColor
                            : kprimaryColor,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
