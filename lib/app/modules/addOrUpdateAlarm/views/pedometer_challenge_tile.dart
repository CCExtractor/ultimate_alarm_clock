import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class PedometerChallenge extends StatelessWidget {
  const PedometerChallenge({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int numberOfSteps;
    bool isPedometerEnabled;
    return ListTile(
      title: Row(
        children: [
          Text(
            'Pedometer',
            style: TextStyle(
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor
                  : kprimaryTextColor,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_sharp,
              size: 21,
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor.withOpacity(0.45)
                  : kprimaryTextColor.withOpacity(0.3),
            ),
            onPressed: () {
              Utils.showModal(
                context: context,
                title: 'Pedometer',
                description: 'Step up to dismiss! Set a step goal to turn off'
                    ' your alarm, promoting an active and'
                    ' energized start to the day.',
                iconData: Icons.directions_walk,
                isLightMode: themeController.isLightMode.value,
              );
            },
          ),
        ],
      ),
      onTap: () {
        Utils.hapticFeedback();
        // storing initial state
        numberOfSteps = controller.numberOfSteps.value;
        isPedometerEnabled = controller.isPedometerEnabled.value;
        Get.defaultDialog(
          onWillPop: () async {
            // presetting values to initial state
            _presetToInitial(numberOfSteps, isPedometerEnabled);
            return true;
          },
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Number of steps',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NumberPicker(
                      value: controller.numberOfSteps.value,
                      minValue: 0,
                      maxValue: 60,
                      onChanged: (value) {
                        Utils.hapticFeedback();
                        if (value > 0) {
                          controller.isPedometerEnabled.value = true;
                        } else {
                          controller.isPedometerEnabled.value = false;
                        }
                        controller.numberOfSteps.value = value;
                      },
                    ),
                    Text(controller.numberOfSteps.value > 1 ? 'steps' : 'step'),
                  ],
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Utils.hapticFeedback();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kprimaryColor,
                            // Set the desired background color
                          ),
                          child: Text(
                            'Done',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryTextColor
                                      : ksecondaryTextColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.numberOfSteps.value > 0
                    ? controller.numberOfSteps.value > 1
                        ? '${controller.numberOfSteps.value} steps'
                        : '${controller.numberOfSteps.value} step'
                    : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isPedometerEnabled.value == false)
                          ? themeController.isLightMode.value
                              ? kLightPrimaryDisabledTextColor
                              : kprimaryDisabledTextColor
                          : themeController.isLightMode.value
                              ? kLightPrimaryTextColor
                              : kprimaryTextColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: themeController.isLightMode.value
                  ? kLightPrimaryDisabledTextColor
                  : kprimaryDisabledTextColor,
            ),
          ],
        ),
      ),
    );
  }

  void _presetToInitial(int numberOfSteps, bool isPedometerEnabled) {
    controller.numberOfSteps.value = numberOfSteps;
    controller.isPedometerEnabled.value = isPedometerEnabled;
  }
}
