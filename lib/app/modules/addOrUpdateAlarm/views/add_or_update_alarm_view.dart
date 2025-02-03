import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/input_time_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/alarm_id_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/alarm_offset_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/ascending_volume.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/choose_ringtone_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/delete_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/label_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/location_activity_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/maths_challenge_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/note.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/pedometer_challenge_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/qr_bar_code_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/quote_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/repeat_once_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/repeat_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/screen_activity_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/setting_selector.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shake_to_dismiss_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_alarm_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_users_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/snooze_duration_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/weather_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import '../controllers/add_or_update_alarm_controller.dart';
import 'alarm_date_tile.dart';
import 'guardian_angel.dart';

class AddOrUpdateAlarmView extends GetView<AddOrUpdateAlarmController> {
  AddOrUpdateAlarmView({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();
  final InputTimeController inputTimeController =
      Get.put(InputTimeController());
  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // var width = Get.width;
    // var height = Get.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        controller.checkUnsavedChangesAndNavigate(context);
      },
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.08),
          child: Obx(
            () => AppBar(
              backgroundColor: themeController.primaryBackgroundColor.value,
              elevation: 0.0,
              centerTitle: true,
              iconTheme: Theme.of(context).iconTheme,
              title: (controller.mutexLock.value == true)
                  ? const Text('')
                  : controller.homeController.isProfile.value
                      ? const Text('Edit Profile')
                      : Obx(
                          () => Text(
                            'Rings in @timeToAlarm'.trParams(
                              {
                                'timeToAlarm':
                                    controller.timeToAlarm.value.toString(),
                              },
                            ),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: (controller.mutexLock.value == true)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Obx(
                                () => Text(
                                  'Uh-oh!'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/locked.svg',
                              height: height * 0.24,
                              width: width * 0.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Obx(
                                () => Text(
                                  // 'This alarm is currently being edited!',
                                  'alarmEditing'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kprimaryColor),
                              ),
                              child: Obx(
                                () => Text(
                                  'Go back'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: themeController
                                            .secondaryTextColor.value,
                                      ),
                                ),
                              ),
                              onPressed: () {
                                Utils.hapticFeedback();
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          !controller.homeController.isProfile.value
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    left: width * 0.04,
                                    right: width * 0.04,
                                  ),
                                  child: Obx(
                                    () => Container(
                                      decoration: BoxDecoration(
                                        color: themeController
                                            .secondaryBackgroundColor.value,
                                        borderRadius:
                                            BorderRadius.circular(500),
                                      ),
                                      height: height * 0.25,
                                      child: Obx(
                                        () {
                                          return InkWell(
                                            onTap: () {
                                              Utils.hapticFeedback();
                                              inputTimeController
                                                  .changeDatePicker();
                                            },
                                            child: inputTimeController
                                                    .isTimePicker.value
                                                ? Obx(
                                                    () => Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        NumberPicker(
                                                          minValue:
                                                              settingsController
                                                                      .is24HrsEnabled
                                                                      .value
                                                                  ? 0
                                                                  : 1,
                                                          maxValue:
                                                              settingsController
                                                                      .is24HrsEnabled
                                                                      .value
                                                                  ? 23
                                                                  : 12,
                                                          value: controller
                                                              .hours.value,
                                                          onChanged: (value) {
                                                            Utils
                                                                .hapticFeedback();
                                                            controller.hours
                                                                .value = value;
                                                            controller
                                                                    .selectedTime
                                                                    .value =
                                                                DateTime(
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .year,
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .month,
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .day,
                                                              inputTimeController
                                                                  .convert24(
                                                                value,
                                                                controller
                                                                    .meridiemIndex
                                                                    .value,
                                                              ),
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .minute,
                                                            );
                                                            inputTimeController
                                                                    .inputHrsController
                                                                    .text =
                                                                controller
                                                                    .hours.value
                                                                    .toString();
                                                            inputTimeController
                                                                    .inputMinutesController
                                                                    .text =
                                                                controller
                                                                    .minutes
                                                                    .value
                                                                    .toString();
                                                            inputTimeController
                                                                .changePeriod(
                                                              controller.meridiemIndex
                                                                          .value ==
                                                                      0
                                                                  ? 'AM'
                                                                  : 'PM',
                                                            );
                                                          },
                                                          infiniteLoop: true,
                                                          itemWidth:
                                                              width * 0.17,
                                                          zeroPad: true,
                                                          selectedTextStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displayLarge!
                                                                  .copyWith(
                                                                    fontSize: controller
                                                                            .homeController
                                                                            .scalingFactor *
                                                                        40,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        kprimaryColor,
                                                                  ),
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                                fontSize: controller
                                                                        .homeController
                                                                        .scalingFactor *
                                                                    20,
                                                                color: themeController
                                                                    .primaryDisabledTextColor
                                                                    .value,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                width * 0.02,
                                                          ),
                                                          child: Text(
                                                            ':',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: themeController
                                                                      .primaryDisabledTextColor
                                                                      .value,
                                                                ),
                                                          ),
                                                        ),
                                                        NumberPicker(
                                                          minValue: 0,
                                                          maxValue: 59,
                                                          value: controller
                                                              .minutes.value,
                                                          onChanged: (value) {
                                                            Utils
                                                                .hapticFeedback();
                                                            controller.minutes
                                                                .value = value;
                                                            controller
                                                                    .selectedTime
                                                                    .value =
                                                                DateTime(
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .year,
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .month,
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .day,
                                                              controller
                                                                  .selectedTime
                                                                  .value
                                                                  .hour,
                                                              controller.minutes
                                                                  .value,
                                                            );
                                                            inputTimeController
                                                                    .inputHrsController
                                                                    .text =
                                                                controller
                                                                    .hours.value
                                                                    .toString();
                                                            inputTimeController
                                                                    .inputMinutesController
                                                                    .text =
                                                                controller
                                                                    .minutes
                                                                    .value
                                                                    .toString();
                                                            inputTimeController
                                                                .changePeriod(
                                                              controller.meridiemIndex
                                                                          .value ==
                                                                      0
                                                                  ? 'AM'
                                                                  : 'PM',
                                                            );
                                                          },
                                                          infiniteLoop: true,
                                                          itemWidth:
                                                              width * 0.17,
                                                          zeroPad: true,
                                                          selectedTextStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displayLarge!
                                                                  .copyWith(
                                                                    fontSize: controller
                                                                            .homeController
                                                                            .scalingFactor *
                                                                        40,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        kprimaryColor,
                                                                  ),
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                                fontSize: controller
                                                                        .homeController
                                                                        .scalingFactor *
                                                                    20,
                                                                color: themeController
                                                                    .primaryDisabledTextColor
                                                                    .value,
                                                              ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              settingsController
                                                                      .is24HrsEnabled
                                                                      .value
                                                                  ? false
                                                                  : true,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal:
                                                                  width * 0.02,
                                                            ),
                                                            child: Text(
                                                              ':',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displayLarge!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: themeController
                                                                        .primaryDisabledTextColor
                                                                        .value,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              settingsController
                                                                      .is24HrsEnabled
                                                                      .value
                                                                  ? false
                                                                  : true,
                                                          child: NumberPicker(
                                                            minValue: 0,
                                                            maxValue: 1,
                                                            value: controller
                                                                .meridiemIndex
                                                                .value,
                                                            onChanged: (value) {
                                                              Utils
                                                                  .hapticFeedback();
                                                              value == 0
                                                                  ? controller
                                                                      .meridiemIndex
                                                                      .value = 0
                                                                  : controller
                                                                      .meridiemIndex
                                                                      .value = 1;
                                                              controller
                                                                      .selectedTime
                                                                      .value =
                                                                  DateTime(
                                                                controller
                                                                    .selectedTime
                                                                    .value
                                                                    .year,
                                                                controller
                                                                    .selectedTime
                                                                    .value
                                                                    .month,
                                                                controller
                                                                    .selectedTime
                                                                    .value
                                                                    .day,
                                                                inputTimeController
                                                                    .convert24(
                                                                  controller
                                                                      .hours
                                                                      .value,
                                                                  controller
                                                                      .meridiemIndex
                                                                      .value,
                                                                ),
                                                                controller
                                                                    .minutes
                                                                    .value,
                                                              );
                                                              inputTimeController
                                                                      .inputHrsController
                                                                      .text =
                                                                  controller
                                                                      .hours
                                                                      .value
                                                                      .toString();
                                                              inputTimeController
                                                                      .inputMinutesController
                                                                      .text =
                                                                  controller
                                                                      .minutes
                                                                      .value
                                                                      .toString();
                                                              inputTimeController
                                                                  .changePeriod(
                                                                controller.meridiemIndex
                                                                            .value ==
                                                                        0
                                                                    ? 'AM'
                                                                    : 'PM',
                                                              );
                                                            },
                                                            textMapper:
                                                                (numberText) {
                                                              return controller
                                                                  .meridiem[
                                                                      int.parse(
                                                                numberText,
                                                              )]
                                                                  .value;
                                                            },
                                                            itemWidth:
                                                                width * 0.17,
                                                            selectedTextStyle:
                                                                Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayLarge!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          controller.homeController.scalingFactor *
                                                                              40,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          kprimaryColor,
                                                                    ),
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayMedium!
                                                                .copyWith(
                                                                  fontSize: controller
                                                                          .homeController
                                                                          .scalingFactor *
                                                                      20,
                                                                  color: themeController
                                                                      .primaryDisabledTextColor
                                                                      .value,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 80,
                                                        child: TextField(
                                                          onChanged: (_) {
                                                            inputTimeController
                                                                .setTime();
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText: 'HH',
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          controller:
                                                              inputTimeController
                                                                  .inputHrsController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(
                                                              RegExp(
                                                                '[1,2,3,4,5,6,7,8,9,0]',
                                                              ),
                                                            ),
                                                            LengthLimitingTextInputFormatter(
                                                              2,
                                                            ),
                                                            LimitRange(
                                                              0,
                                                              settingsController
                                                                      .is24HrsEnabled
                                                                      .value
                                                                  ? 23
                                                                  : 12,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                        child: Text(
                                                          ':',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                        child: TextField(
                                                          onChanged: (_) {
                                                            inputTimeController
                                                                .setTime();
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText: 'MM',
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          controller:
                                                              inputTimeController
                                                                  .inputMinutesController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(
                                                              RegExp(
                                                                '[1,2,3,4,5,6,7,8,9,0]',
                                                              ),
                                                            ),
                                                            LengthLimitingTextInputFormatter(
                                                              2,
                                                            ),
                                                            LimitRange(00, 59),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            !settingsController
                                                                .is24HrsEnabled
                                                                .value,
                                                        child: DropdownButton(
                                                          underline:
                                                              Container(),
                                                          value:
                                                              inputTimeController
                                                                      .isAM
                                                                      .value
                                                                  ? 'AM'
                                                                  : 'PM',
                                                          dropdownColor:
                                                              themeController
                                                                  .primaryBackgroundColor
                                                                  .value,
                                                          items: [
                                                            'AM',
                                                            'PM'
                                                          ].map(
                                                              (String period) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: period,
                                                              child:
                                                                  Text(period),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (getPeriod) {
                                                            inputTimeController
                                                                .changePeriod(
                                                                    getPeriod!);

                                                            inputTimeController
                                                                .setTime();
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            inputTimeController
                                                                .isTimePicker
                                                                .isFalse,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Utils
                                                                .hapticFeedback();
                                                            inputTimeController
                                                                .confirmTimeInput();
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                50.0,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    kprimaryColor,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: const Icon(
                                                              Icons.done,
                                                              color:
                                                                  kprimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Profile Name',
                                        fillColor: controller.themeController
                                            .secondaryBackgroundColor.value,
                                        filled: true,
                                      ),
                                      controller: controller
                                          .profileTextEditingController,
                                    ),
                                  ),
                                ),
                          SettingSelector(),
                          Obx(
                            () => controller.alarmSettingType.value == 0
                                ? Column(
                                    children: [
                                      AlarmDateTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      RepeatTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      Obx(
                                        () => (!controller.repeatDays.every(
                                                (element) => element == false))
                                            ? RepeatOnceTile(
                                                controller: controller,
                                                themeController:
                                                    themeController,
                                              )
                                            : const SizedBox(),
                                      ),
                                      Obx(
                                        () => (!controller.repeatDays.every(
                                                (element) => element == false))
                                            ? Divider(
                                                color: themeController
                                                    .primaryDisabledTextColor
                                                    .value,
                                              )
                                            : const SizedBox(),
                                      ),
                                      SnoozeDurationTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      Obx(
                                        () => (controller.repeatDays.every(
                                                (element) => element == false))
                                            ? DeleteAfterGoesOff(
                                                controller: controller,
                                                themeController:
                                                    themeController,
                                              )
                                            : const SizedBox(),
                                      ),
                                      LabelTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      NoteTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      ChooseRingtoneTile(
                                        controller: controller,
                                        themeController: themeController,
                                        height: height,
                                        width: width,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      AscendingVolumeTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      QuoteTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                          Obx(
                            () => controller.alarmSettingType.value == 1
                                ? Column(
                                    children: [
                                      ScreenActivityTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      WeatherTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      LocationTile(
                                        controller: controller,
                                        height: height,
                                        width: width,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      GaurdianAngel(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                          Obx(
                            () => controller.alarmSettingType.value == 2
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShakeToDismiss(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      QrBarCode(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      MathsChallenge(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      PedometerChallenge(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                          Obx(
                            () => controller.alarmSettingType.value == 3
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SharedAlarm(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
                                      AlarmIDTile(
                                        controller: controller,
                                        width: width,
                                        themeController: themeController,
                                      ),
                                      Obx(
                                        () => Container(
                                          child: (controller
                                                  .isSharedAlarmEnabled.value)
                                              ? Divider(
                                                  color: themeController
                                                      .primaryDisabledTextColor
                                                      .value,
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),
                                      AlarmOffset(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Obx(
                                        () => Container(
                                          child: (controller
                                                  .isSharedAlarmEnabled.value)
                                              ? Divider(
                                                  color: themeController
                                                      .primaryDisabledTextColor
                                                      .value,
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),
                                      SharedUsers(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: height * 0.15,
                                  ),
                          ),
                        ],
                      ),
              ),
            ),
            (controller.mutexLock.value == true)
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      height: height * 0.06,
                      width: width * 0.8,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          (controller.alarmRecord.value.alarmID == '')
                              ? 'Save'.tr
                              : 'Update'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.secondaryTextColor.value,
                              ),
                        ),
                        onPressed: () async {
                          Utils.hapticFeedback();
                          await controller.checkOverlayPermissionAndNavigate();

                          if ((await Permission.systemAlertWindow.isGranted) &&
                              (await Permission
                                  .ignoreBatteryOptimizations.isGranted)) {
                            if (!controller.homeController.isProfile.value) {
                              if (controller.userModel.value != null) {
                                controller.offsetDetails[
                                    controller.userModel.value!.id] = {
                                  'offsettedTime': Utils.timeOfDayToString(
                                    TimeOfDay.fromDateTime(
                                      Utils.calculateOffsetAlarmTime(
                                        controller.selectedTime.value,
                                        controller.isOffsetBefore.value,
                                        controller.offsetDuration.value,
                                      ),
                                    ),
                                  ),
                                  'offsetDuration':
                                      controller.offsetDuration.value,
                                  'isOffsetBefore':
                                      controller.isOffsetBefore.value,
                                };
                              } else {
                                controller.offsetDetails.value = {};
                              }
                              AlarmModel alarmRecord = AlarmModel(
                                deleteAfterGoesOff:
                                    controller.deleteAfterGoesOff.value,
                                snoozeDuration: controller.snoozeDuration.value,
                                volMax: controller.volMax.value,
                                volMin: controller.volMin.value,
                                gradient: controller.gradient.value,
                                offsetDetails: controller.offsetDetails,
                                label: controller.label.value,
                                note: controller.note.value,
                                showMotivationalQuote:
                                    controller.showMotivationalQuote.value,
                                isOneTime: controller.isOneTime.value,
                                lastEditedUserId:
                                    controller.lastEditedUserId.value,
                                mutexLock: controller.mutexLock.value,
                                alarmID: controller.alarmID,
                                ownerId: controller.ownerId.value,
                                ownerName: controller.ownerName.value,
                                activityInterval:
                                    controller.activityInterval.value * 60000,
                                days: controller.repeatDays.toList(),
                                alarmTime: Utils.timeOfDayToString(
                                  TimeOfDay.fromDateTime(
                                    controller.selectedTime.value,
                                  ),
                                ),
                                mainAlarmTime: Utils.timeOfDayToString(
                                  TimeOfDay.fromDateTime(
                                    controller.selectedTime.value,
                                  ),
                                ),
                                intervalToAlarm: Utils.getMillisecondsToAlarm(
                                  DateTime.now(),
                                  controller.selectedTime.value,
                                ),
                                isActivityEnabled:
                                    controller.isActivityenabled.value,
                                minutesSinceMidnight: Utils.timeOfDayToInt(
                                  TimeOfDay.fromDateTime(
                                    controller.selectedTime.value,
                                  ),
                                ),
                                isLocationEnabled:
                                    controller.isLocationEnabled.value,
                                weatherTypes: Utils.getIntFromWeatherTypes(
                                  controller.selectedWeather.toList(),
                                ),
                                isWeatherEnabled:
                                    controller.isWeatherEnabled.value,
                                location: Utils.geoPointToString(
                                  Utils.latLngToGeoPoint(
                                    controller.selectedPoint.value,
                                  ),
                                ),
                                isSharedAlarmEnabled:
                                    controller.isSharedAlarmEnabled.value,
                                isQrEnabled: controller.isQrEnabled.value,
                                qrValue: controller.qrValue.value,
                                isMathsEnabled: controller.isMathsEnabled.value,
                                numMathsQuestions:
                                    controller.numMathsQuestions.value,
                                mathsDifficulty:
                                    controller.mathsDifficulty.value.index,
                                isShakeEnabled: controller.isShakeEnabled.value,
                                shakeTimes: controller.shakeTimes.value,
                                isPedometerEnabled:
                                    controller.isPedometerEnabled.value,
                                numberOfSteps: controller.numberOfSteps.value,
                                ringtoneName:
                                    controller.customRingtoneName.value,
                                activityMonitor:
                                    controller.isActivityMonitorenabled.value,
                                alarmDate: controller.selectedDate.value
                                    .toString()
                                    .substring(0, 11),
                                profile: controller
                                    .homeController.selectedProfile.value,
                                isGuardian: controller.isGuardian.value,
                                guardianTimer: 0,
                                guardian: controller
                                    .contactTextEditingController.text,
                                isCall: controller.isCall.value,
                                ringOn: controller.isFutureDate.value,
                              );

                              // Adding offset details to the database if
                              // its a shared alarm
                              if (controller.isSharedAlarmEnabled.value) {
                                alarmRecord.offsetDetails =
                                    controller.offsetDetails;
                                alarmRecord.mainAlarmTime =
                                    Utils.timeOfDayToString(
                                  TimeOfDay.fromDateTime(
                                    controller.selectedTime.value,
                                  ),
                                );
                              }
                              try {
                                if (controller.alarmRecord.value.alarmID ==
                                    '') {
                                  await controller.createAlarm(alarmRecord);
                                } else {
                                  AlarmModel updatedAlarmModel =
                                      controller.updatedAlarmModel();
                                  await controller
                                      .updateAlarm(updatedAlarmModel);
                                }
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            } else {
                              if (controller.profileTextEditingController.text
                                  .isNotEmpty) controller.createProfile();
                            }
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
