import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ChooseRingtoneTile extends StatelessWidget {
  const ChooseRingtoneTile({
    super.key,
    required this.controller,
    required this.themeController,
    required this.height,
    required this.width,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        tileColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: Text(
          'Choose Ringtone',
          style: TextStyle(
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
          ),
        ),
        onTap: () async {
          Utils.hapticFeedback();

          controller.customRingtoneNames.value =
              await controller.getAllCustomRingtoneNames();

          controller.customRingtoneNames.insert(0, 'Default');

          Get.defaultDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            title: 'Choose Ringtone',
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Column(
                children: [
                  Obx(
                    () => SizedBox(
                      width: width * 0.8,
                      height: height * 0.2,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: controller.customRingtoneNames.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Obx(
                              () => ListTile(
                                onTap: () {
                                  controller.customRingtoneName.value =
                                      controller.customRingtoneNames[index];
                                },
                                tileColor: controller.customRingtoneName ==
                                        controller.customRingtoneNames[index]
                                    ? themeController.isLightMode.value
                                        ? kLightPrimaryBackgroundColor
                                        : kprimaryBackgroundColor
                                    : themeController.isLightMode.value
                                        ? kLightSecondaryBackgroundColor
                                        : ksecondaryBackgroundColor,
                                title: Text(
                                  controller.customRingtoneNames[index],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: (controller
                                                .customRingtoneName.value ==
                                            controller
                                                .customRingtoneNames[index]) ||
                                        (controller
                                                .customRingtoneNames[index] ==
                                            'Default')
                                    ? null
                                    : IconButton(
                                        onPressed: () async {
                                          await controller.deleteCustomRingtone(
                                            ringtoneName: controller
                                                .customRingtoneNames[index],
                                            ringtoneIndex: index,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      Utils.hapticFeedback();
                      await controller.saveCustomRingtone();
                    },
                    child: Text(
                      'Upload Ringtone',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: kprimaryColor,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Utils.hapticFeedback();
                      await Utils.updateRingtoneCounterOfUsage(
                        customRingtoneName: controller.customRingtoneName.value,
                        counterUpdate: CounterUpdate.increment,
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
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
        trailing: InkWell(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: Text(
                    controller.customRingtoneName.value,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: (controller.label.value.trim().isEmpty)
                              ? themeController.isLightMode.value
                                  ? kLightPrimaryDisabledTextColor
                                  : kprimaryDisabledTextColor
                              : themeController.isLightMode.value
                                  ? kLightPrimaryTextColor
                                  : kprimaryTextColor,
                        ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: (controller.label.value.trim().isEmpty)
                    ? themeController.isLightMode.value
                        ? kLightPrimaryDisabledTextColor
                        : kprimaryDisabledTextColor
                    : themeController.isLightMode.value
                        ? kLightPrimaryTextColor
                        : kprimaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
