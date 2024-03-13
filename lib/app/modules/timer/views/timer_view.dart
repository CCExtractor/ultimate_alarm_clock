import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/input_time_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/routes/app_pages.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/end_drawer.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class TimerView extends GetView<TimerController> {
  TimerView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();
  InputTimeController inputTimeController = Get.put(InputTimeController());

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
                return IconButton(
                  onPressed: () {
                    Utils.hapticFeedback();
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                  ),
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.75)
                      : kprimaryTextColor.withOpacity(0.75),
                  iconSize: 27,
                  // splashRadius: 0.000001,
                );
              },
            ),
          ],
        ),
      ),
      body: Obx(
        () => controller.isTimerRunning.value
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Obx(
                      () {
                        final hours = controller.strDigits(
                          controller.remainingTime.value.inHours.remainder(24),
                        );
                        final minutes = controller.strDigits(
                          controller.remainingTime.value.inMinutes
                              .remainder(60),
                        );
                        final seconds = controller.strDigits(
                          controller.remainingTime.value.inSeconds
                              .remainder(60),
                        );
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  hours,
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
                                  minutes,
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
                                  seconds,
                                  style: const TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'stop',
                          onPressed: () async {
                            Utils.hapticFeedback();
                            controller.stopTimer();
                            int timerId =
                                await SecureStorageProvider().readTimerId();
                            await IsarDb.deleteAlarm(timerId);
                          },
                          child: const Icon(Icons.close_rounded),
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
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            size: 33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : InkWell(
                onTap: () {
                  Utils.hapticFeedback();
                  inputTimeController.changeTimePickerTimer();
                },
                child: Obx(
                  () => Container(
                    color: themeController.isLightMode.value
                        ? kLightPrimaryBackgroundColor
                        : kprimaryBackgroundColor,
                    height: height * 0.32,
                    width: width,
                    child: inputTimeController.isTimePickerTimer.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hours',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  NumberPicker(
                                    minValue: 0,
                                    maxValue: 23,
                                    value: controller.hours.value,
                                    onChanged: (value) {
                                      Utils.hapticFeedback();
                                      controller.hours.value = value;
                                    },
                                    infiniteLoop: true,
                                    itemWidth: width * 0.17,
                                    zeroPad: true,
                                    selectedTextStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryColor,
                                        ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontSize: 20,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          width: width * 0.005,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                        bottom: BorderSide(
                                          width: width * 0.005,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                  top: height * 0.035,
                                ),
                                child: Text(
                                  ':',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: themeController.isLightMode.value
                                            ? kLightPrimaryDisabledTextColor
                                            : kprimaryDisabledTextColor,
                                      ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Minutes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  NumberPicker(
                                    minValue: 0,
                                    maxValue: 59,
                                    value: controller.minutes.value,
                                    onChanged: (value) {
                                      controller.minutes.value = value;
                                    },
                                    infiniteLoop: true,
                                    itemWidth: width * 0.17,
                                    zeroPad: true,
                                    selectedTextStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryColor,
                                        ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontSize: 20,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          width: width * 0.005,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                        bottom: BorderSide(
                                          width: width * 0.005,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                  top: height * 0.035,
                                ),
                                child: Text(
                                  ':',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: themeController.isLightMode.value
                                            ? kLightPrimaryDisabledTextColor
                                            : kprimaryDisabledTextColor,
                                      ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Seconds',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  NumberPicker(
                                    minValue: 0,
                                    maxValue: 59,
                                    value: controller.seconds.value,
                                    onChanged: (value) {
                                      controller.seconds.value = value;
                                    },
                                    infiniteLoop: true,
                                    itemWidth: width * 0.17,
                                    zeroPad: true,
                                    selectedTextStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryColor,
                                        ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontSize: 20,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          width: width * 0.005,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                        bottom: BorderSide(
                                          width: width * 0.005,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hours',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: TextField(
                                      onChanged: (_) {
                                        inputTimeController.setTimerTime();
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'HH',
                                        border: InputBorder.none,
                                      ),
                                      textAlign: TextAlign.center,
                                      controller: inputTimeController
                                          .inputHoursControllerTimer,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                            '[1,2,3,4,5,6,7,8,9,0]',
                                          ),
                                        ),
                                        LengthLimitingTextInputFormatter(
                                          2,
                                        ),
                                        LimitRange(
                                          0,
                                          23,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                  top: height * 0.035,
                                ),
                                child: Text(
                                  ':',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: themeController.isLightMode.value
                                            ? kLightPrimaryDisabledTextColor
                                            : kprimaryDisabledTextColor,
                                      ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Minutes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: TextField(
                                      onChanged: (_) {
                                        inputTimeController.setTimerTime();
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'MM',
                                        border: InputBorder.none,
                                      ),
                                      textAlign: TextAlign.center,
                                      controller: inputTimeController
                                          .inputMinutesControllerTimer,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                            '[1,2,3,4,5,6,7,8,9,0]',
                                          ),
                                        ),
                                        LengthLimitingTextInputFormatter(
                                          2,
                                        ),
                                        LimitRange(
                                          0,
                                          59,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                  top: height * 0.035,
                                ),
                                child: Text(
                                  ':',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: themeController.isLightMode.value
                                            ? kLightPrimaryDisabledTextColor
                                            : kprimaryDisabledTextColor,
                                      ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Seconds',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightPrimaryDisabledTextColor
                                              : kprimaryDisabledTextColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: TextField(
                                      onChanged: (_) {
                                        inputTimeController.setTimerTime();
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'SS',
                                        border: InputBorder.none,
                                      ),
                                      textAlign: TextAlign.center,
                                      controller: inputTimeController
                                          .inputSecondsControllerTimer,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                            '[1,2,3,4,5,6,7,8,9,0]',
                                          ),
                                        ),
                                        LengthLimitingTextInputFormatter(
                                          2,
                                        ),
                                        LimitRange(
                                          0,
                                          59,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
      ),
      floatingActionButton: Obx(
        () => controller.isTimerRunning.value
            ? const SizedBox()
            : Obx(
                () => AbsorbPointer(
                  absorbing: controller.hours.value == 0 &&
                          controller.minutes.value == 0 &&
                          controller.seconds.value == 0
                      ? true
                      : false,
                  child: FloatingActionButton(
                    onPressed: () {
                      Utils.hapticFeedback();
                      controller.remainingTime.value = Duration(
                        hours: controller.hours.value,
                        minutes: controller.minutes.value,
                        seconds: controller.seconds.value,
                      );
                      controller.startTimer();
                      controller.createTimer();
                    },
                    backgroundColor: controller.hours.value == 0 &&
                            controller.minutes.value == 0 &&
                            controller.seconds.value == 0
                        ? kprimaryDisabledTextColor
                        : kprimaryColor,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 33,
                    ),
                  ),
                ),
              ),
      ),
      endDrawer: buildEndDrawer(context),
    );
  }
}
