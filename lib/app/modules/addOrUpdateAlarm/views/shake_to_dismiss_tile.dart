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
    var width = Get.width;
    var height = Get.height;
    return ListTile(
      title: Row(
        children: [
          Text(
            'Shake to dismiss',
            style: TextStyle(
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor
                    : kprimaryTextColor),
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
              Utils.hapticFeedback();
              showModalBottomSheet(
                  context: context,
                  backgroundColor: themeController.isLightMode.value
                      ? kLightSecondaryBackgroundColor
                      : ksecondaryBackgroundColor,
                  builder: (context) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Transform.rotate(
                              angle: 15,
                              child: Icon(
                                Icons.vibration,
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryTextColor
                                    : kprimaryTextColor,
                                size: height * 0.1,
                              ),
                            ),
                            Text("Shake to dismiss",
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                "You will have to shake your phone a set number of times to dismiss the alarm - no more lazy snoozing :)",
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kprimaryColor),
                                ),
                                onPressed: () {
                                  Utils.hapticFeedback();
                                  Get.back();
                                },
                                child: Text(
                                  'Understood',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color:
                                              themeController.isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                  : ksecondaryTextColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      onTap: () {
        Utils.hapticFeedback();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Number of shakes',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(() => Column(
                children: [
                  Row(
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
                      Text(controller.shakeTimes.value > 1 ? 'times' : 'time'),
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
                                backgroundColor: kprimaryColor
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
                                          : ksecondaryTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
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
                    : 'Off',
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
            )
          ],
        ),
      ),
    );
  }
}
