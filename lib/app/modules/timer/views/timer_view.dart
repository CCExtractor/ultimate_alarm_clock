// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/views/timer_animation.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/end_drawer.dart';
import 'package:ultimate_alarm_clock/app/utils/hover_preset_button.dart';
import 'package:ultimate_alarm_clock/app/utils/preset_button.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/custom_time_picker.dart';

import '../../../data/models/timer_model.dart';

class TimerView extends GetView<TimerController> {
  TimerView({Key? key}) : super(key: key);
  final GlobalKey dialogKey = GlobalKey();
  final ThemeController themeController = Get.find<ThemeController>();
  // var width = Get.width;
  // var height = Get.height;
  
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / 8.9),
        child: AppBar(
          toolbarHeight: height / 7.9,
          elevation: 0.0,
          title: Obx(
            () => Text(
              'Timer',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: themeController.primaryTextColor.value.withOpacity(
                      0.75,
                    ),
                    fontSize: 26,
                  ),
            ),
          ),
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => Visibility(
          visible:
              controller.isbottom.value && controller.timerList.length >= 3,
          child: Container(
            height: 85,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  Utils.hapticFeedback();
                  timerSelector(context, width, height);
                },
                backgroundColor: kprimaryColor,
                child: const Icon(
                  Icons.add_alarm,
                  color: ksecondaryBackgroundColor,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final hasTimers = controller.timerList.isNotEmpty;

        return Stack(
          children: [
            // Main content: Timer list
            if (hasTimers)
              Positioned.fill(
                child: StreamBuilder<List<TimerModel>>(
                  stream: IsarDb.getTimers(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(kprimaryColor),
                        ),
                      );
                    } else {
                      List<TimerModel> timers = snapshot.data!;
                      return ListView.builder(
                        controller: controller.scrollController,
                        itemCount: timers.length +
                            1, // Include space for addATimerSpace only if not sticky
                        padding: const EdgeInsets.only(bottom: 80),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == timers.length) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  buildAddTimerSection(context, width, height),
                            );
                          }
                          return TimerAnimatedCard(
                            key: ValueKey(timers[index].timerId),
                            index: index,
                            timer: timers[index],
                          );
                        },
                      );
                    }
                  },
                ),
              ),

            // No timers: Centered addATimerSpace and preset buttons
            if (!hasTimers)
              Center(
                child: buildAddTimerSection(context, width, height),
              ),
          ],
        );
      }),
      endDrawer: buildEndDrawer(context),
    );
  }

  Widget buildAddTimerSection(
    BuildContext context,
    double width,
    double height,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        addATimerSpace(context, width, height),
        Visibility(
          visible: controller.timerList.length <= 2,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              presetButton(context, '+1:00', const Duration(minutes: 1)),
              presetButton(context, '+5:00', const Duration(minutes: 5)),
              presetButton(context, '+10:00', const Duration(minutes: 10)),
              presetButton(context, '+15:00', const Duration(minutes: 15)),
            ],
          ),
        ),
      ],
    );
  }

  Widget addATimerSpace(BuildContext context, double width, double height) {
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          timerSelector(context, width, height);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_alarm_outlined,
                  color: themeController.primaryTextColor.value.withOpacity(
                    0.75,
                  ),
                  size: 30,
                ),
              ),
            ),
            Text(
              'Tap here to add a timer',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void timerSelector(BuildContext context, double width, double height) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: themeController.primaryBackgroundColor.value,
              child: Container(
                key: dialogKey,
                width: width,
                margin: const EdgeInsets.only(
                  top: 5,
                ),
                padding: const EdgeInsets.fromLTRB(
                  10,
                  10,
                  10,
                  5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timer Add Icon and Text
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 20),
                        const SizedBox(width: 10),
                        Obx(
                          () => Text(
                            'Add timer',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: themeController.primaryTextColor.value
                                      .withOpacity(0.7),
                                  fontSize: 15,
                                ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            controller.changeTimePickerTimer();
                          },
                          child: Obx(
                            () => Icon(
                              Icons.keyboard,
                              color: themeController.primaryTextColor.value
                                  .withOpacity(0.7),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Utils.hapticFeedback();
                      },
                      child: Obx(
                        () => Container(
                          color: themeController.primaryBackgroundColor.value,
                          width: width,
                          child: controller.isTimePickerTimer.value
                              ? _buildAdaptiveTimerPicker(context, width, height, themeController)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Hours',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: themeController
                                                    .primaryDisabledTextColor
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(
                                          height: height * 0.008,
                                        ),
                                        SizedBox(
                                          width: width * 0.18,
                                          child: TextField(
                                            onChanged: (_) {
                                              controller.setTimerTime();
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'HH',
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: controller.inputHoursControllerTimer,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(
                                                  r'[0-9]',
                                                ),
                                              ),
                                              LengthLimitingTextInputFormatter(
                                                2,
                                              ),
                                              LimitRange(
                                                0,
                                                99,
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
                                              color: themeController
                                                  .primaryDisabledTextColor
                                                  .value,
                                            ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Minutes',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: themeController
                                                    .primaryDisabledTextColor
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(
                                          height: height * 0.008,
                                        ),
                                        SizedBox(
                                          width: width * 0.18,
                                          child: TextField(
                                            onChanged: (_) {
                                              controller.setTimerTime();
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'MM',
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: controller.inputMinutesControllerTimer,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(
                                                  r'[0-9]',
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
                                              color: themeController
                                                  .primaryDisabledTextColor
                                                  .value,
                                            ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sec',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: themeController
                                                    .primaryDisabledTextColor
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(
                                          height: height * 0.008,
                                        ),
                                        SizedBox(
                                          width: width * 0.18,
                                          child: TextField(
                                            onChanged: (_) {
                                              controller.setTimerTime();
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'SS',
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: controller.inputSecondsControllerTimer,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(
                                                  r'[0-9]',
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20.00, 20.00, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Obx(
                                  () => Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          color: themeController
                                              .primaryTextColor.value
                                              .withOpacity(0.5),
                                          fontSize: 15,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                controller.remainingTime.value = Duration(
                                  hours: controller.hours.value,
                                  minutes: controller.minutes.value,
                                  seconds: controller.seconds.value,
                                );
                                if (controller.hours.value != 0 ||
                                    controller.minutes.value != 0 ||
                                    controller.seconds.value != 0) {
                                  controller.createTimer();
                                }
                                controller.hours.value = 0;
                                controller.minutes.value = 1;
                                controller.seconds.value = 0;
                                controller.setTextFieldTimerTime();

                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Obx(
                                  () => Text(
                                    'OK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          color: themeController
                                              .primaryTextColor.value
                                              .withOpacity(0.5),
                                          fontSize: 15,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Preset Buttons Floating
            Visibility(
              visible: controller.timerList.length > 2,
              child: Positioned(
                top: 60,
                child: Material(
                  elevation: 5.0,
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        hoverPresetButton(
                          context,
                          '+1:00',
                          const Duration(minutes: 1),
                        ),
                        hoverPresetButton(
                          context,
                          '+5:00',
                          const Duration(minutes: 5),
                        ),
                        hoverPresetButton(
                          context,
                          '+10:00',
                          const Duration(minutes: 10),
                        ),
                        hoverPresetButton(
                          context,
                          '+15:00',
                          const Duration(minutes: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdaptiveTimerPicker(BuildContext context, double width, double height, ThemeController themeController) {
    // Check if font scaling is too high for NumberPicker
    final systemScale = MediaQuery.textScaleFactorOf(context);
    final combinedScale = systemScale;
    final useCustomPicker = combinedScale > 1.5;

    if (useCustomPicker) {
      // Use simplified custom picker for timer
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimerUnitColumn(
              context: context,
              label: 'Hours',
              value: controller.hours.value,
              minValue: 0,
              maxValue: 99,
              onChanged: (value) {
                Utils.hapticFeedback();
                controller.hours.value = value;
                controller.setTextFieldTimerTime();
              },
              width: width,
              themeController: themeController,
              systemScale: systemScale,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: (24 * systemScale).clamp(20.0, 40.0),
                  fontWeight: FontWeight.bold,
                  color: themeController.primaryDisabledTextColor.value,
                ),
              ),
            ),
            _buildTimerUnitColumn(
              context: context,
              label: 'Minutes',
              value: controller.minutes.value,
              minValue: 0,
              maxValue: 59,
              onChanged: (value) {
                Utils.hapticFeedback();
                controller.minutes.value = value;
                controller.setTextFieldTimerTime();
              },
              width: width,
              themeController: themeController,
              systemScale: systemScale,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: (24 * systemScale).clamp(20.0, 40.0),
                  fontWeight: FontWeight.bold,
                  color: themeController.primaryDisabledTextColor.value,
                ),
              ),
            ),
            _buildTimerUnitColumn(
              context: context,
              label: 'Seconds',
              value: controller.seconds.value,
              minValue: 0,
              maxValue: 59,
              onChanged: (value) {
                Utils.hapticFeedback();
                controller.seconds.value = value;
                controller.setTextFieldTimerTime();
              },
              width: width,
              themeController: themeController,
              systemScale: systemScale,
            ),
          ],
        ),
      );
    } else {
      // Use enhanced NumberPicker for normal scaling
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hours Picker
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hours',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                ),
                SizedBox(height: height * 0.008),
                NumberPicker(
                  minValue: 0,
                  maxValue: 99,
                  value: controller.hours.value,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.hours.value = value;
                    controller.setTextFieldTimerTime();
                  },
                  infiniteLoop: true,
                  itemWidth: Utils.getResponsiveNumberPickerItemWidth(
                    context,
                    screenWidth: width,
                    baseWidthFactor: 0.15,
                  ),
                  itemHeight: Utils.getResponsiveNumberPickerItemHeight(
                    context,
                    baseFontSize: 30,
                  ),
                  zeroPad: true,
                  selectedTextStyle: Utils.getResponsiveNumberPickerSelectedTextStyle(
                    context,
                    baseFontSize: 30,
                    color: kprimaryColor,
                  ),
                  textStyle: Utils.getResponsiveNumberPickerTextStyle(
                    context,
                    baseFontSize: 18,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: width * 0.005,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                      bottom: BorderSide(
                        width: width * 0.005,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Colon separator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                ':',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeController.primaryDisabledTextColor.value,
                ),
              ),
            ),
            // Minutes Picker
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Minutes',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                ),
                SizedBox(height: height * 0.008),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: controller.minutes.value,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.minutes.value = value;
                    controller.setTextFieldTimerTime();
                  },
                  infiniteLoop: true,
                  itemWidth: Utils.getResponsiveNumberPickerItemWidth(
                    context,
                    screenWidth: width,
                    baseWidthFactor: 0.15,
                  ),
                  itemHeight: Utils.getResponsiveNumberPickerItemHeight(
                    context,
                    baseFontSize: 30,
                  ),
                  zeroPad: true,
                  selectedTextStyle: Utils.getResponsiveNumberPickerSelectedTextStyle(
                    context,
                    baseFontSize: 30,
                    color: kprimaryColor,
                  ),
                  textStyle: Utils.getResponsiveNumberPickerTextStyle(
                    context,
                    baseFontSize: 18,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: width * 0.005,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                      bottom: BorderSide(
                        width: width * 0.005,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Colon separator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                ':',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeController.primaryDisabledTextColor.value,
                ),
              ),
            ),
            // Seconds Picker
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seconds',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                ),
                SizedBox(height: height * 0.008),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: controller.seconds.value,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.seconds.value = value;
                    controller.setTextFieldTimerTime();
                  },
                  infiniteLoop: true,
                  itemWidth: Utils.getResponsiveNumberPickerItemWidth(
                    context,
                    screenWidth: width,
                    baseWidthFactor: 0.15,
                  ),
                  itemHeight: Utils.getResponsiveNumberPickerItemHeight(
                    context,
                    baseFontSize: 30,
                  ),
                  zeroPad: true,
                  selectedTextStyle: Utils.getResponsiveNumberPickerSelectedTextStyle(
                    context,
                    baseFontSize: 30,
                    color: kprimaryColor,
                  ),
                  textStyle: Utils.getResponsiveNumberPickerTextStyle(
                    context,
                    baseFontSize: 18,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: width * 0.005,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                      bottom: BorderSide(
                        width: width * 0.005,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTimerUnitColumn({
    required BuildContext context,
    required String label,
    required int value,
    required int minValue,
    required int maxValue,
    required Function(int) onChanged,
    required double width,
    required ThemeController themeController,
    required double systemScale,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: (14 * systemScale).clamp(12.0, 24.0),
            fontWeight: FontWeight.bold,
            color: themeController.primaryDisabledTextColor.value,
          ),
        ),
        SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.2,
          ),
          width: (width * 0.18).clamp(70.0, 100.0),
          decoration: BoxDecoration(
            color: kprimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kprimaryColor.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Plus button
              InkWell(
                onTap: () {
                  Utils.hapticFeedback();
                  int newValue = value + 1;
                  if (newValue > maxValue) newValue = minValue;
                  onChanged(newValue);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all((8 * systemScale).clamp(6.0, 12.0)),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: kprimaryColor,
                    size: (20 * systemScale).clamp(16.0, 28.0),
                  ),
                ),
              ),
              // Current value display
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: (4 * systemScale).clamp(2.0, 8.0),
                    horizontal: 4,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: (20 * systemScale).clamp(16.0, 32.0),
                        fontWeight: FontWeight.bold,
                        color: kprimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Minus button
              InkWell(
                onTap: () {
                  Utils.hapticFeedback();
                  int newValue = value - 1;
                  if (newValue < minValue) newValue = maxValue;
                  onChanged(newValue);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all((8 * systemScale).clamp(6.0, 12.0)),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: kprimaryColor,
                    size: (20 * systemScale).clamp(16.0, 28.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
