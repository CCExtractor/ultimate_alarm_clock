import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ShakeToDismiss extends StatelessWidget {
  const ShakeToDismiss({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int shakeTimes;
    bool isShakeEnabled;
    return ListTile(
      title: Row(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Shake to dismiss'.tr,
              style: TextStyle(
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor
                    : kprimaryTextColor,
              ),
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
                title: 'Shake to dismiss'.tr,
                // description: 'You will have to shake your phone a set number'
                //     ' of times to dismiss the alarm'
                //     ' - no more lazy snoozing :)',
                description: 'shakeDescription'.tr,
                iconData: Icons.vibration_sharp,
                isLightMode: themeController.isLightMode.value,
              );
            },
          ),
        ],
      ),
      onTap: () {
        Utils.hapticFeedback();
        // storing initial state
        shakeTimes = controller.shakeTimes.value;
        isShakeEnabled = controller.isShakeEnabled.value;
        Get.defaultDialog(
          onWillPop: () async {
            // presetting values to initial state
            _presetToInitial(shakeTimes, isShakeEnabled);
            return true;
          },
          titlePadding: const EdgeInsets.only(top: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Number of shakes'.tr,
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NumberPicker(
                        value: controller.shakeTimes.value,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) {
                          Utils.hapticFeedback();
                          if (value > 0) {
                            controller.isShakeEnabled.value = true;
                          } else {
                            controller.isShakeEnabled.value = false;
                          }
                          controller.shakeTimes.value = value;
                        },
                      ),
                      // ignore: require_trailing_commas
                      Text(controller.shakeTimes.value > 1
                          ? 'times'.tr
                          : 'time'.tr),
                    ],
                  ),
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
                            'Done'.tr,
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
                controller.shakeTimes.value > 0
                    ? controller.shakeTimes.value > 1
                        ? '${controller.shakeTimes.value} times'
                        : '${controller.shakeTimes.value} time'
                    : 'Off'.tr,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isShakeEnabled.value == false)
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

  void _presetToInitial(int shakeTimes, bool isShakeEnabled) {
    controller.shakeTimes.value = shakeTimes;
    controller.isShakeEnabled.value = isShakeEnabled;
  }
}
