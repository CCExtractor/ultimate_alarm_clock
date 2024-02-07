import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/routes/app_pages.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class TimerView extends GetView<TimerController> {
  TimerView({Key? key}) : super(key: key);

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
                children: [
                  SizedBox(
                    height: height * 0.3,
                  ),
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
                                  '$hours',
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
                                  '$minutes',
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
                                  '$seconds',
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
            : Obx(
                () => Container(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryBackgroundColor
                      : kprimaryBackgroundColor,
                  height: height * 0.32,
                  width: width,
                  child: Row(
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
                                  color: themeController.isLightMode.value
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
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
                                ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: width * 0.005,
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
                                ),
                                bottom: BorderSide(
                                  width: width * 0.005,
                                  color: themeController.isLightMode.value
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
                                  color: themeController.isLightMode.value
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
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
                                ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: width * 0.005,
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
                                ),
                                bottom: BorderSide(
                                  width: width * 0.005,
                                  color: themeController.isLightMode.value
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
                                  color: themeController.isLightMode.value
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
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
                                ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: width * 0.005,
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
                                ),
                                bottom: BorderSide(
                                  width: width * 0.005,
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryDisabledTextColor
                                      : kprimaryDisabledTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
      endDrawer: Obx(
        () => Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.2,
                child: DrawerHeader(
                  decoration: const BoxDecoration(color: kLightSecondaryColor),
                  child: Center(
                    child: Row(
                      children: [
                        const Flexible(
                          flex: 1,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              'assets/images/ic_launcher-playstore.png',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  'Ultimate Alarm Clock'.tr,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color:
                                              themeController.isLightMode.value
                                                  ? kprimaryTextColor
                                                  : ksecondaryTextColor,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  'v0.5.0'.tr,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color:
                                              themeController.isLightMode.value
                                                  ? kprimaryTextColor
                                                  : ksecondaryTextColor,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Get.back();
                  Get.toNamed('/settings');
                },
                contentPadding: const EdgeInsets.only(left: 20, right: 44),
                title: Text(
                  'Settings'.tr,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor.withOpacity(0.8)
                            : kprimaryTextColor.withOpacity(0.8),
                      ),
                ),
                leading: Icon(
                  Icons.settings,
                  size: 26,
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.8)
                      : kprimaryTextColor.withOpacity(0.8),
                ),
              ),
              // LanguageMenu(),
              
              ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Get.back();
                  Get.toNamed(Routes.ABOUT);
                },
                contentPadding: const EdgeInsets.only(left: 20, right: 44),
                title: Text(
                  'About'.tr,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: themeController.isLightMode.value
                          ? kLightPrimaryTextColor.withOpacity(0.8)
                          : kprimaryTextColor.withOpacity(0.8)),
                ),
                leading: Icon(
                  Icons.info_outline,
                  size: 26,
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.8)
                      : kprimaryTextColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
