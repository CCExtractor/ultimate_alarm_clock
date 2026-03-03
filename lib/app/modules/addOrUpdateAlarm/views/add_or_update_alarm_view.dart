import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/share_alarm_tile.dart';
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
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/smart_control_combination_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shake_to_dismiss_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_alarm_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/shared_users_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/snooze_settings_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/sunrise_alarm_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/timezone_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/weather_tile.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import '../controllers/add_or_update_alarm_controller.dart';
import 'alarm_date_tile.dart';
import 'guardian_angel.dart';
import 'custom_time_picker.dart';

class AddOrUpdateAlarmView extends GetView<AddOrUpdateAlarmController> {
  AddOrUpdateAlarmView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();
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
                                              controller.changeDatePicker();
                                            },
                                            child: controller
                                                    .isTimePicker.value
                                                ? Obx(
                                                    () {
                                                      // Check if font scaling is too high for NumberPicker
                                                      final systemScale = MediaQuery.textScaleFactorOf(context);
                                                      final appScale = controller.homeController.scalingFactor.value;
                                                      final combinedScale = systemScale * appScale;
                                                      final useCustomPicker = combinedScale > 1.3;

                                                      if (useCustomPicker) {
                                                        // Use custom time picker for better scaling
                                                        return CustomTimePicker(
                                                          hours: controller.hours.value,
                                                          minutes: controller.minutes.value,
                                                          meridiemIndex: controller.meridiemIndex.value,
                                                          is24Hour: settingsController.is24HrsEnabled.value,
                                                          onHoursChanged: (value) {
                                                            Utils.hapticFeedback();
                                                            controller.hours.value = value;

                                                            // Update the selected time with proper format handling
                                                            int hourValue;
                                                            if (settingsController.is24HrsEnabled.value) {
                                                              // In 24-hour mode, use the value directly
                                                              hourValue = value;
                                                            } else {
                                                              // In 12-hour mode, convert based on AM/PM
                                                              hourValue = controller.convert24(
                                                                value,
                                                                controller.meridiemIndex.value,
                                                              );
                                                            }

                                                            controller.selectedTime.value = DateTime(
                                                              controller.selectedTime.value.year,
                                                              controller.selectedTime.value.month,
                                                              controller.selectedTime.value.day,
                                                              hourValue,
                                                              controller.selectedTime.value.minute,
                                                            );

                                                            // Update text controllers to reflect current format
                                                            controller.inputHrsController.text = controller.hours.value.toString();
                                                            controller.inputMinutesController.text = controller.minutes.value.toString();

                                                            // Only update period for 12-hour format
                                                            if (!settingsController.is24HrsEnabled.value) {
                                                              controller.changePeriod(
                                                                controller.meridiemIndex.value == 0 ? 'AM' : 'PM',
                                                              );
                                                            }

                                                            controller.setTime();
                                                          },
                                                          onMinutesChanged: (value) {
                                                            Utils.hapticFeedback();
                                                            controller.minutes.value = value;
                                                            controller.selectedTime.value = DateTime(
                                                              controller.selectedTime.value.year,
                                                              controller.selectedTime.value.month,
                                                              controller.selectedTime.value.day,
                                                              controller.selectedTime.value.hour,
                                                              controller.minutes.value,
                                                            );
                                                            controller.inputHrsController.text = controller.hours.value.toString();
                                                            controller.inputMinutesController.text = controller.minutes.value.toString();
                                                            controller.changePeriod(
                                                              controller.meridiemIndex.value == 0 ? 'AM' : 'PM',
                                                            );
                                                            controller.setTime();
                                                          },
                                                          onMeridiemChanged: (value) {
                                                            Utils.hapticFeedback();
                                                            controller.meridiemIndex.value = value;
                                                            controller.selectedTime.value = DateTime(
                                                              controller.selectedTime.value.year,
                                                              controller.selectedTime.value.month,
                                                              controller.selectedTime.value.day,
                                                              controller.convert24(
                                                                controller.hours.value,
                                                                controller.meridiemIndex.value,
                                                              ),
                                                              controller.minutes.value,
                                                            );
                                                            controller.inputHrsController.text = controller.hours.value.toString();
                                                            controller.inputMinutesController.text = controller.minutes.value.toString();
                                                            controller.changePeriod(
                                                              controller.meridiemIndex.value == 0 ? 'AM' : 'PM',
                                                            );
                                                            controller.setTime();
                                                          },
                                                          primaryColor: kprimaryColor,
                                                          textColor: themeController.primaryTextColor.value,
                                                          disabledTextColor: themeController.primaryDisabledTextColor.value,
                                                          scalingFactor: controller.homeController.scalingFactor.value,
                                                        );
                                                      } else {
                                                        // Use standard NumberPicker for normal scaling
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            NumberPicker(
                                                              minValue: settingsController.is24HrsEnabled.value ? 0 : 1,
                                                              maxValue: settingsController.is24HrsEnabled.value ? 23 : 12,
                                                              value: controller.hours.value,
                                                              onChanged: (value) {
                                                                Utils.hapticFeedback();
                                                                controller.hours.value = value;

                                                                // Update the selected time with proper format handling
                                                                int hourValue;
                                                                if (settingsController.is24HrsEnabled.value) {
                                                                  // In 24-hour mode, use the value directly
                                                                  hourValue = value;
                                                                } else {
                                                                  // In 12-hour mode, convert based on AM/PM
                                                                  hourValue = controller.convert24(
                                                                    value,
                                                                    controller.meridiemIndex.value,
                                                                  );
                                                                }

                                                                controller.selectedTime.value = DateTime(
                                                                  controller.selectedTime.value.year,
                                                                  controller.selectedTime.value.month,
                                                                  controller.selectedTime.value.day,
                                                                  hourValue,
                                                                  controller.selectedTime.value.minute,
                                                                );

                                                                // Update text controllers to reflect current format
                                                                controller.inputHrsController.text = controller.hours.value.toString();
                                                                controller.inputMinutesController.text = controller.minutes.value.toString();

                                                                // Only update period for 12-hour format
                                                                if (!settingsController.is24HrsEnabled.value) {
                                                                  controller.changePeriod(
                                                                    controller.meridiemIndex.value == 0 ? 'AM' : 'PM',
                                                                  );
                                                                }

                                                                controller.setTime();
                                                              },
                                                              infiniteLoop: true,
                                                              itemWidth: Utils.getResponsiveNumberPickerItemWidth(
                                                                context,
                                                                screenWidth: width,
                                                                baseWidthFactor: 0.17,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                              itemHeight: Utils.getResponsiveNumberPickerItemHeight(
                                                                context,
                                                                baseFontSize: 40,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                              zeroPad: true,
                                                              selectedTextStyle: Utils.getResponsiveNumberPickerSelectedTextStyle(
                                                                context,
                                                                baseFontSize: 40,
                                                                color: kprimaryColor,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                              textStyle: Utils.getResponsiveNumberPickerTextStyle(
                                                                context,
                                                                baseFontSize: 20,
                                                                color: themeController.primaryDisabledTextColor.value,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                            ),
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
                                                            NumberPicker(
                                                              minValue: 0,
                                                              maxValue: 59,
                                                              value: controller.minutes.value,
                                                              onChanged: (value) {
                                                                Utils.hapticFeedback();
                                                                controller.minutes.value = value;
                                                                controller.selectedTime.value = DateTime(
                                                                  controller.selectedTime.value.year,
                                                                  controller.selectedTime.value.month,
                                                                  controller.selectedTime.value.day,
                                                                  controller.selectedTime.value.hour,
                                                                  controller.minutes.value,
                                                                );
                                                                controller.inputHrsController.text = controller.hours.value.toString();
                                                                controller.inputMinutesController.text = controller.minutes.value.toString();
                                                                controller.changePeriod(
                                                                  controller.meridiemIndex.value == 0 ? 'AM' : 'PM',
                                                                );
                                                              },
                                                              infiniteLoop: true,
                                                              itemWidth: Utils.getResponsiveNumberPickerItemWidth(
                                                                context,
                                                                screenWidth: width,
                                                                baseWidthFactor: 0.17,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                              itemHeight: Utils.getResponsiveNumberPickerItemHeight(
                                                                context,
                                                                baseFontSize: 40,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                              zeroPad: true,
                                                              selectedTextStyle: Utils.getResponsiveNumberPickerSelectedTextStyle(
                                                                context,
                                                                baseFontSize: 40,
                                                                color: kprimaryColor,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                              textStyle: Utils.getResponsiveNumberPickerTextStyle(
                                                                context,
                                                                baseFontSize: 20,
                                                                color: themeController.primaryDisabledTextColor.value,
                                                                appScalingFactor: controller.homeController.scalingFactor.value,
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: settingsController.is24HrsEnabled.value ? false : true,
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                child: Text(
                                                                  ':',
                                                                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: themeController.primaryDisabledTextColor.value,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: settingsController.is24HrsEnabled.value ? false : true,
                                                              child: NumberPicker(
                                                                minValue: 0,
                                                                maxValue: 1,
                                                                value: controller.meridiemIndex.value,
                                                                onChanged: (value) {
                                                                  Utils.hapticFeedback();
                                                                  value == 0
                                                                      ? controller.meridiemIndex.value = 0
                                                                      : controller.meridiemIndex.value = 1;
                                                                  controller.selectedTime.value = DateTime(
                                                                    controller.selectedTime.value.year,
                                                                    controller.selectedTime.value.month,
                                                                    controller.selectedTime.value.day,
                                                                    controller.convert24(
                                                                      controller.hours.value,
                                                                      controller.meridiemIndex.value,
                                                                    ),
                                                                    controller.minutes.value,
                                                                  );
                                                                  controller.inputHrsController.text = controller.hours.value.toString();
                                                                  controller.inputMinutesController.text = controller.minutes.value.toString();
                                                                  controller.changePeriod(
                                                                    controller.meridiemIndex.value == 0 ? 'AM' : 'PM',
                                                                  );
                                                                },
                                                                textMapper: (numberText) {
                                                                  return controller.meridiem[int.parse(numberText)].value;
                                                                },
                                                                itemWidth: Utils.getResponsiveNumberPickerItemWidth(
                                                                  context,
                                                                  screenWidth: width,
                                                                  baseWidthFactor: 0.2,
                                                                  appScalingFactor: controller.homeController.scalingFactor.value,
                                                                ),
                                                                itemHeight: Utils.getResponsiveNumberPickerItemHeight(
                                                                  context,
                                                                  baseFontSize: 30,
                                                                  appScalingFactor: controller.homeController.scalingFactor.value,
                                                                ),
                                                                selectedTextStyle: Utils.getResponsiveNumberPickerSelectedTextStyle(
                                                                  context,
                                                                  baseFontSize: 30,
                                                                  color: kprimaryColor,
                                                                  appScalingFactor: controller.homeController.scalingFactor.value,
                                                                ),
                                                                textStyle: Utils.getResponsiveNumberPickerTextStyle(
                                                                  context,
                                                                  baseFontSize: 20,
                                                                  color: themeController.primaryDisabledTextColor.value,
                                                                  appScalingFactor: controller.homeController.scalingFactor.value,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    },
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
                                                            if (int.parse(controller
                                                                        .inputHrsController
                                                                        .text) ==
                                                                    12 &&
                                                                int.parse(controller
                                                                        .inputMinutesController
                                                                        .text) ==
                                                                    0) {
                                                              controller
                                                                  .isAM
                                                                  .toggle();
                                                            }
                                                            controller
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
                                                              controller
                                                                  .inputHrsController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    '[0-9]')),
                                                            LengthLimitingTextInputFormatter(
                                                                2),
                                                            LimitRange(
                                                              settingsController.is24HrsEnabled.value ? 0 : 1,
                                                              settingsController.is24HrsEnabled.value ? 23 : 12,
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
                                                            controller
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
                                                              controller
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
                                                              controller
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
                                                            controller
                                                                .changePeriod(
                                                                    getPeriod!);

                                                            controller
                                                                .setTime();
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            controller
                                                                .isTimePicker
                                                                .isFalse,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Utils
                                                                .hapticFeedback();
                                                            controller
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
                                      TimezoneTile(
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
                                      SnoozeSettingsTile(
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
                                      SunriseAlarmTile(
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
                                      SmartControlCombinationTile(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                      Divider(
                                        color: themeController
                                            .primaryDisabledTextColor.value,
                                      ),
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
                                      GuardianAngel(
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
                                      ShareAlarm(
                                        controller: controller,
                                        width: width,
                                        themeController: themeController,
                                      ),
                                      Obx(
                                        () => (controller.isSharedAlarmEnabled.value)
                                            ? Column(
                                                children: [
                                                  Divider(
                                                  color: themeController
                                                      .primaryDisabledTextColor
                                                      .value,
                                      ),
                                      AlarmOffset(
                                        controller: controller,
                                        themeController: themeController,
                                      ),
                                                  Divider(
                                                  color: themeController
                                                      .primaryDisabledTextColor
                                                      .value,
                                      ),
                                      SharedUsers(
                                        controller: controller,
                                        themeController: themeController,
                                                  ),
                                                ],
                                              )
                                            : Divider(
                                                color: themeController
                                                    .primaryDisabledTextColor
                                                    .value,
                                              ),
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
                                controller.userOffsetDetails.value = {
                                  'userId': controller.userId.value,
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
                                controller.userOffsetDetails.value = {};
                              }
                              AlarmModel alarmRecord = AlarmModel(
                                deleteAfterGoesOff:
                                    controller.deleteAfterGoesOff.value,
                                snoozeDuration: controller.snoozeDuration.value,
                                maxSnoozeCount: controller.maxSnoozeCount.value,
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
                                locationConditionType:
                                    controller.locationConditionType.value.index,
                                weatherTypes: Utils.getIntFromWeatherTypes(
                                  controller.selectedWeather.toList(),
                                ),
                                isWeatherEnabled:
                                    controller.isWeatherEnabled.value,
                                weatherConditionType:
                                    controller.weatherConditionType.value.index,
                                activityConditionType:
                                    controller.activityConditionType.value.index,
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
                                isSunriseEnabled: controller.isSunriseEnabled.value,
                                sunriseDuration: controller.sunriseDuration.value,
                                sunriseIntensity: controller.sunriseIntensity.value,
                                sunriseColorScheme: controller.sunriseColorScheme.value,
                              );

                              // Adding offset details to the database if
                              // its a shared alarm
                              if (controller.isSharedAlarmEnabled.value) {

                              final userOffset = controller.offsetDetails
                              .firstWhereOrNull((entry) => entry['userId'] == controller.userId.value);

                              if(userOffset != null)
                              {
                                controller.offsetDetails.value.removeWhere((ele) => ele['userId'] == controller.userId.value);
                              }

                              controller.offsetDetails.add(Map<String, dynamic>.from(controller.userOffsetDetails.value));


                              alarmRecord.offsetDetails = controller.offsetDetails;

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
                              controller.createProfile();
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