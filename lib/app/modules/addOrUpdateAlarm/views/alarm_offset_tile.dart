import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmOffset extends StatelessWidget {
  const AlarmOffset({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.isSharedAlarmEnabled.value)
          ? InkWell(
              onTap: () {
                Utils.hapticFeedback();
                Get.defaultDialog(
                  titlePadding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: themeController.isLightMode.value ? kLightSecondaryBackgroundColor : ksecondaryBackgroundColor,
                  title: 'Choose duration',
                  titleStyle: Theme.of(context).textTheme.displaySmall,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NumberPicker(
                                value: controller.offsetDuration.value,
                                minValue: 0,
                                maxValue: 1440,
                                onChanged: (value) {
                                  Utils.hapticFeedback();
                                  controller.offsetDuration.value = value;
                                },),
                            Text(controller.offsetDuration.value > 1
                                ? 'minutes'
                                : 'minute',),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                Utils.hapticFeedback();
                                controller.isOffsetBefore.value = true;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (controller.isOffsetBefore.value)
                                        ? kprimaryColor
                                        : themeController.isLightMode.value ? kLightPrimaryTextColor.withOpacity(0.10) : kprimaryTextColor.withOpacity(0.08),
                                foregroundColor:
                                    (controller.isOffsetBefore.value)
                                        ? themeController.isLightMode.value ? kLightSecondaryTextColor : ksecondaryTextColor
                                        : themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor,
                              ),
                              child: const Text('Before',
                                  style: TextStyle(fontSize: 14),),
                            ),
                          ),
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                Utils.hapticFeedback();
                                controller.isOffsetBefore.value = false;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (!controller.isOffsetBefore.value)
                                        ? kprimaryColor
                                        : themeController.isLightMode.value ? kLightPrimaryTextColor.withOpacity(0.10) : kprimaryTextColor.withOpacity(0.08),
                                foregroundColor:
                                    (!controller.isOffsetBefore.value)
                                        ? themeController.isLightMode.value ? kLightSecondaryTextColor : ksecondaryTextColor
                                        : themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor,
                              ),
                              child: const Text('After',
                                  style: TextStyle(fontSize: 14),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: ListTile(
                  title: const Text('Ring before / after '),
                  trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.offsetDuration.value > 0
                                ? 'Enabled'
                                : 'Off',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: (controller.offsetDuration.value > 0)
                                        ? themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor
                                        : themeController.isLightMode.value ? kLightPrimaryDisabledTextColor : kprimaryDisabledTextColor,),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: themeController.isLightMode.value ? kLightPrimaryDisabledTextColor : kprimaryDisabledTextColor,
                        ),
                      ],),),
            )
          : const SizedBox(),
    );
  }
}
