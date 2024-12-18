import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/input_time_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/views/timer_animation.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/end_drawer.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../../data/models/timer_model.dart';

class TimerView extends GetView<TimerController> {
  TimerView({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();
  final InputTimeController inputTimeController =
      Get.put(InputTimeController());
  var width = Get.width;
  var height = Get.height;
  @override
  Widget build(BuildContext context) {
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
                    color: themeController.primaryTextColor.value.withOpacity(0.75),
                    iconSize: 27,
                    // splashRadius: 0.000001,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Obx(() => controller.timerList.value.length == 0
          ? addATimerSpace(context)
          : StreamBuilder(
              stream: IsarDb.getTimers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData && snapshot.data != []) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                        kprimaryColor,
                      ),
                    ),
                  );
                } else {
                  // list of pause values of timers
                  List<TimerModel>? listOfTimers = snapshot.data;
                  return ListView.builder(
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          TimerAnimatedCard(
                            key: ValueKey(listOfTimers![index].timerId),
                            index: index,
                            timer: listOfTimers![index],
                          ),
                          if (index == snapshot.data!.length - 1)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: addATimerSpace(context),
                            )
                        ],
                      );
                    },
                  );
                }
              },
            )),
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.isbottom.value,
          child: Container(
            height: 85,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  Utils.hapticFeedback();
                  TimerSelector(context);
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
      endDrawer: buildEndDrawer(context),
    );
  }

  Widget addATimerSpace(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          TimerSelector(context);
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

  void TimerSelector(BuildContext context) {
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: themeController.primaryBackgroundColor.value,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 20),
            child: Row(
              children: [
                const Icon(
                  Icons.timer,
                  size: 20,
                ),
                Obx(
                  () => Text(
                    '  Add timer',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: themeController.primaryTextColor.value.withOpacity(
                                  0.5,
                                ),
                          fontSize: 15,
                        ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      inputTimeController.changeTimePickerTimer();
                    },
                    child: Obx(
                      () => Icon(
                        Icons.keyboard,
                        color:
                        themeController.primaryTextColor.value.withOpacity(
                                    0.5,
                                  ),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Utils.hapticFeedback();
            },
            child: Obx(
              () => Container(
                color: themeController.primaryBackgroundColor.value,
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
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              NumberPicker(
                                minValue: 0,
                                maxValue: 99,
                                value: controller.hours.value,
                                onChanged: (value) {
                                  Utils.hapticFeedback();
                                  controller.hours.value = value;
                                  inputTimeController.setTextFieldTimerTime();
                                },
                                infiniteLoop: true,
                                itemWidth: width * 0.17,
                                zeroPad: true,
                                selectedTextStyle: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: kprimaryColor,
                                    ),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 18,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: width * 0.005,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                                    bottom: BorderSide(
                                      width: width * 0.005,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
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
                                    color: themeController.primaryDisabledTextColor.value,
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
                                      color:
                                          themeController.primaryDisabledTextColor.value,
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
                                  inputTimeController.setTextFieldTimerTime();
                                },
                                infiniteLoop: true,
                                itemWidth: width * 0.17,
                                zeroPad: true,
                                selectedTextStyle: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: kprimaryColor,
                                    ),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 18,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: width * 0.005,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                                    bottom: BorderSide(
                                      width: width * 0.005,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
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
                                    color: themeController.primaryDisabledTextColor.value,
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
                                      color:
                                          themeController.primaryDisabledTextColor.value,
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
                                  inputTimeController.setTextFieldTimerTime();
                                },
                                infiniteLoop: true,
                                itemWidth: width * 0.17,
                                zeroPad: true,
                                selectedTextStyle: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: kprimaryColor,
                                    ),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 18,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: width * 0.005,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                                    bottom: BorderSide(
                                      width: width * 0.005,
                                      color:
                                          themeController.primaryDisabledTextColor.value,
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
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              SizedBox(
                                width: 70,
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
                                    color: themeController.primaryDisabledTextColor.value,
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
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              SizedBox(
                                width: 70,
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
                                    color: themeController.primaryDisabledTextColor.value,
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
                                      color:
                                          themeController.primaryDisabledTextColor.value,
                                    ),
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              SizedBox(
                                width: 70,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 20.00, 0),
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
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: themeController.primaryTextColor.value.withOpacity(
                                          0.5,
                                        ),
                                  fontSize: 15,
                                ),
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
                          controller.seconds.value != 0)
                        controller.createTimer();
                      controller.hours.value = 0;
                      controller.minutes.value = 1;
                      controller.seconds.value = 0;
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => Text(
                            'OK',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: themeController.primaryTextColor.value.withOpacity(
                                          0.5,
                                        ),
                                  fontSize: 15,
                                ),
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
    );
  }
}
