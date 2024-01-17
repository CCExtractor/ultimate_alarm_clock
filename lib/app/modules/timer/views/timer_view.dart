import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
          
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => controller.isTimerRunning.value
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                              height: 300,
                              width: 300,
                              child: CircularCountDownTimer(
                                duration:
                                    controller.remainingTime.value.inSeconds,
                                width: 300,
                                height: 300,
                                fillColor: Color.fromARGB(255, 163, 249, 72),
                                ringColor: Colors.grey,
                                controller: controller.ccontroller,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 9,
                                //initialDuration: -1,
                                isTimerTextShown: false,
                              )
                            ),
                          Obx(() {
                            final hours = controller.strDigits(
                              controller.remainingTime.value.inHours
                                  .remainder(24),
                            );
                            final minutes = controller.strDigits(
                              controller.remainingTime.value.inMinutes
                                  .remainder(60),
                            );
                            final seconds = controller.strDigits(
                              controller.remainingTime.value.inSeconds
                                  .remainder(60),
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
                        ],
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
                            child: const Icon(Icons.close),
                          ),
                          SizedBox(
                            width: width * 0.11,
                          ),
                          FloatingActionButton(
                            heroTag: 'pause',
                            onPressed: () {
                              Utils.hapticFeedback();
                              if (controller.isTimerPaused.value) {
                                controller.resumeTimer();
                                controller.ccontroller.resume();
                              } else {
                                controller.pauseTimer();
                                controller.ccontroller.pause();
                              }
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
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Container(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryBackgroundColor
                            : kprimaryBackgroundColor,
                        height: height * 0.32,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.2,
                              child: TimePickerSpinner(
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
                                  Utils.hapticFeedback();
                                  controller.remainingTime.value = Duration(
                                    hours: dateTime.hour,
                                    minutes: dateTime.minute,
                                    seconds: dateTime.second,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            FloatingActionButton(
                              onPressed: () {
                                Utils.hapticFeedback();
                                controller.startTimer();
                                controller.createTimer();
                              },
                              backgroundColor:
                                  controller.remainingTime.value.inHours == 0 &&
                                          controller.remainingTime.value
                                                  .inMinutes ==
                                              0 &&
                                          controller.remainingTime.value
                                                  .inSeconds ==
                                              0
                                      ? kprimaryDisabledTextColor
                                      : kprimaryColor,
                              child: const Icon(
                                Icons.play_arrow_rounded,
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
              DrawerHeader(
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
                                    .displayMedium!
                                    .copyWith(
                                        color: themeController.isLightMode.value
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
                                    .titleLarge!
                                    .copyWith(
                                        color: themeController.isLightMode.value
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
              ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Get.back();
                  Get.toNamed('/settings');
                },
                contentPadding: const EdgeInsets.only(left: 20, right: 44),
                title: Text(
                  'Settings'.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
        ),
      ),
      floatingActionButton: const SizedBox(),
    );
  }
}
