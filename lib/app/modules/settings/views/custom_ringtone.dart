import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class CustomRingtone extends StatelessWidget {
  const CustomRingtone({
    super.key,
    required this.controller,
    required this.themeController,
    required this.width,
    required this.height,
  });

  final SettingsController controller;
  final ThemeController themeController;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () async {
          Utils.hapticFeedback();
          RingtoneModel? customRingtone = await IsarDb.getCustomRingtone();

          if (customRingtone != null) {
            controller.customRingtoneName.value = customRingtone.ringtoneName;
          }

          controller.customRingtoneStatus.value =
              await SecureStorageProvider().readCustomRingtoneStatus();

          Get.defaultDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            barrierDismissible: controller.customRingtoneStatus.value ==
                        CustomRingtoneStatus.enabled &&
                    controller.customRingtoneName.value ==
                        'Custom Ringtone Disabled!'
                ? false
                : true,
            onWillPop: () async {
              return controller.customRingtoneStatus.value ==
                      CustomRingtoneStatus.enabled &&
                  controller.customRingtoneName.value ==
                      'Custom Ringtone Disabled!' ? false : true;
            },
            title: 'Custom Ringtone',
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Column(
                children: [
                  RadioListTile.adaptive(
                    title: Text(
                      'Disable',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor,
                          ),
                    ),
                    value: CustomRingtoneStatus.disabled,
                    groupValue: controller.customRingtoneStatus.value,
                    fillColor: const MaterialStatePropertyAll(kprimaryColor),
                    onChanged: (value) {
                      Utils.hapticFeedback();
                      controller.customRingtoneStatus.value =
                          CustomRingtoneStatus.disabled;
                      controller.customRingtoneName.value =
                          'Custom Ringtone Disabled!';
                      controller.saveCustomRingtoneStatus();
                    },
                  ),
                  RadioListTile.adaptive(
                    title: Text(
                      'Enable',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor,
                          ),
                    ),
                    value: CustomRingtoneStatus.enabled,
                    groupValue: controller.customRingtoneStatus.value,
                    fillColor: const MaterialStatePropertyAll(kprimaryColor),
                    onChanged: (value) async {
                      Utils.hapticFeedback();
                      controller.customRingtoneStatus.value =
                          CustomRingtoneStatus.enabled;
                      RingtoneModel? customRingtone =
                          await IsarDb.getCustomRingtone();

                      if (customRingtone != null) {
                        controller.customRingtoneName.value =
                            customRingtone.ringtoneName;
                      }
                      controller.saveCustomRingtoneStatus();
                    },
                  ),
                  Visibility(
                    visible: controller.customRingtoneStatus.value ==
                        CustomRingtoneStatus.enabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            Utils.hapticFeedback();
                            await controller.saveCustomRingtone();
                          },
                          child: Obx(() {
                            bool isRingtoneSelected =
                                controller.customRingtoneName.value !=
                                        'Custom Ringtone Disabled!' &&
                                    controller.customRingtoneStatus.value ==
                                        CustomRingtoneStatus.enabled;

                            return Text(
                              isRingtoneSelected
                                  ? 'Change Ringtone'
                                  : 'Choose Ringtone',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: kprimaryColor,
                                  ),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(controller.customRingtoneName.value),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: controller.customRingtoneStatus.value ==
                                CustomRingtoneStatus.enabled &&
                            controller.customRingtoneName.value ==
                                'Custom Ringtone Disabled!'
                        ? null
                        : () {
                            Utils.hapticFeedback();
                            Get.back();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      disabledBackgroundColor: themeController.isLightMode.value
                          ? kLightPrimaryDisabledTextColor
                          : kprimaryDisabledTextColor,
                    ),
                    child: Text(
                      'Done',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : ksecondaryTextColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          width: width * 0.91,
          height: height * 0.1,
          decoration: Utils.getCustomTileBoxDecoration(
            isLightMode: themeController.isLightMode.value,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Custom Ringtone',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.4)
                      : kprimaryTextColor.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
