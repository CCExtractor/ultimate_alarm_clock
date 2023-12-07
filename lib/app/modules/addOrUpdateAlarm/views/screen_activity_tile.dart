import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ScreenActivityTile extends StatelessWidget {
  const ScreenActivityTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    int activityInterval;
    bool isActivityEnalbed;
    return InkWell(
      onTap: () {
        Utils.hapticFeedback();
        // storing the initial values
        activityInterval = controller.activityInterval.value;
        isActivityEnalbed = controller.isActivityenabled.value;
        Get.defaultDialog(
          onWillPop: () async {
            controller.activityInterval.value = activityInterval;
            controller.isActivityenabled.value = isActivityEnalbed;
            return true;
          },
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Timeout Duration',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NumberPicker(
                      value: controller.activityInterval.value,
                      minValue: 0,
                      maxValue: 1440,
                      onChanged: (value) {
                        Utils.hapticFeedback();
                        if (value > 0) {
                          controller.isActivityenabled.value = true;
                        } else {
                          controller.isActivityenabled.value = false;
                        }
                        controller.activityInterval.value = value;
                      },
                    ),
                    Text(
                      controller.activityInterval.value > 1
                          ? 'minutes'
                          : 'minute',
                    ),
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
      child: ListTile(
        title: Row(
          children: [
            Text(
              'Screen Activity',
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
                  title: 'Screen activity based cancellation',
                  description: 'This feature will automatically cancel'
                      " the alarm if you've been using your device"
                      ' for a set number of minutes.',
                  iconData: Icons.screen_lock_portrait_outlined,
                  isLightMode: themeController.isLightMode.value,
                );
              },
            ),
          ],
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.activityInterval.value > 0
                    ? '${controller.activityInterval.value} min'
                    : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isActivityenabled.value == false)
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
}
