import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ChooseRingtoneTile extends StatelessWidget {
  const ChooseRingtoneTile({
    Key? key,
    required this.controller,
    required this.themeController,
    required this.height,
    required this.width,
  }) : super(key: key);

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final double height;
  final double width;

  void onTapPreview(String ringtonePath) async {
    Utils.hapticFeedback();

    // Stop the currently playing audio before starting the preview for the new audio
    await AudioUtils.stopPreviewCustomSound();

    if (controller.isPlaying.value) {
      // If it was playing, reset the isPlaying state to false
      controller.toggleIsPlaying();
    } else {
      await AudioUtils.previewCustomSound(ringtonePath);
      controller.toggleIsPlaying(); // Toggle the isPlaying state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        tileColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: Text(
          'Choose Ringtone'.tr,
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
            title: 'Choose Ringtone'.tr,
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (controller.customRingtoneName.value ==
                                        controller.customRingtoneNames[index])
                                      IconButton(
                                        onPressed: () => onTapPreview(controller
                                            .customRingtoneNames[index]),
                                        icon: Icon(
                                          (controller.isPlaying.value &&
                                                  controller.customRingtoneName
                                                          .value ==
                                                      controller
                                                              .customRingtoneNames[
                                                          index])
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                          color: (controller.isPlaying.value &&
                                                  controller.customRingtoneName
                                                          .value ==
                                                      controller
                                                              .customRingtoneNames[
                                                          index])
                                              ? const Color.fromARGB(
                                                  255,
                                                  116,
                                                  111,
                                                  110) // Change this color to red
                                              : kprimaryColor,
                                        ),
                                      ),
                                    if (!((controller
                                                .customRingtoneName.value ==
                                            controller
                                                .customRingtoneNames[index]) ||
                                        (controller
                                                .customRingtoneNames[index] ==
                                            'Default'.tr)))
                                      IconButton(
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
                                  ],
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
                      'Upload Ringtone'.tr,
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
    await AudioUtils.updateRingtoneCounterOfUsage(
      customRingtoneName: controller.customRingtoneName.value,
      counterUpdate: CounterUpdate.increment,
    );
    await AudioUtils.stopPreviewCustomSound(); // Stop custom ringtone preview
    await AudioUtils.stopDefaultAlarm(); // Stop default alarm
    controller.resetIsPlaying(); // Reset the isPlaying state
    Get.back();
  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                    ),
                    child: Text(
                      'Done'.tr,
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
