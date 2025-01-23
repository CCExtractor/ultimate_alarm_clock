import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import '../../../utils/utils.dart';

class RandomToneTile extends StatelessWidget {
  const RandomToneTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Randomize Ringtone'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
        ),
        trailing: Obx(
          () => Switch.adaptive(
            value: controller.randomTone.value,
            activeColor: ksecondaryColor,
            onChanged: (value) async {
              Utils.hapticFeedback();
              controller.randomTone.value = value;

              if (value) {
                controller.disableChooseRingtoneSwitch();

                controller.customRingtoneNames.value =
                    await controller.getAllCustomRingtoneNames();

                if (controller.customRingtoneNames.isEmpty) {
                  // Fallback in case no ringtones exist
                  Get.snackbar(
                    'No ringtones available!'.tr,
                    'There are no ringtones available. Add one!'.tr,
                    duration: const Duration(seconds: 2),
                    snackPosition: SnackPosition.BOTTOM,
                    barBlur: 15,
                    colorText: kprimaryTextColor,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                  );
                  return;
                }

                // Store previous ringtone before setting a new one
                String previousRingtone = controller.customRingtoneName.value;

                // Selecting a random ringtone
                int randomIndex =
                    Random().nextInt(controller.customRingtoneNames.length);
                controller.customRingtoneName.value =
                    controller.customRingtoneNames[randomIndex];

                // Update usage counter for the new ringtone
                await AudioUtils.updateRingtoneCounterOfUsage(
                  customRingtoneName: controller.customRingtoneName.value,
                  counterUpdate: CounterUpdate.increment,
                );

                // Decrement usage counter for the previous ringtone
                if (previousRingtone.isNotEmpty &&
                    previousRingtone != controller.customRingtoneName.value) {
                  await AudioUtils.updateRingtoneCounterOfUsage(
                    customRingtoneName: previousRingtone,
                    counterUpdate: CounterUpdate.decrement,
                  );
                }

                print('Ringtone Set Successfully: ${controller.customRingtoneName.value}');
              } else {
                controller.enableChooseRingtoneSwitch();
              }
            },
          ),
        ),
        onTap: () {
          Utils.hapticFeedback();
          controller.randomTone.value = !controller.randomTone.value;
        },
      ),
    );
  }
}
