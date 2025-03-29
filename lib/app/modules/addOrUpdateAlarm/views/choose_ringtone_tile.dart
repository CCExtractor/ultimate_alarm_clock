import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
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

  void onTapPreview(String ringtoneName) async {
    Utils.hapticFeedback();

    // Stop the currently playing audio before starting the preview for the new
    // audio
    if (controller.isPlaying.value == true) {
      // If it was playing, reset the isPlaying state to false
      await AudioUtils.stopPreviewCustomSound();
      controller.toggleIsPlaying();
    } else {
      await AudioUtils.previewCustomSound(ringtoneName);
      controller.toggleIsPlaying(); // Toggle the isPlaying state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        title: Text(
          'Choose Ringtone'.tr,
          style: TextStyle(
            color: themeController.primaryTextColor.value,
          ),
        ),
        onTap: () async {
          Utils.hapticFeedback();

          controller.customRingtoneNames.value =
              await controller.getAllCustomRingtoneNames();

          Get.defaultDialog(
            onWillPop: () async => false,
            barrierDismissible: false,
            titlePadding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Choose Ringtone'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Column(
                children: [
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        width: width * 0.8,
                        height: height * 0.3,
                        child: Card(
                          elevation: 0,
                          color: themeController.secondaryBackgroundColor.value,
                          child: Scrollbar(
                            radius: const Radius.circular(5),
                            thumbVisibility: true,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: ListView.builder(
                                itemCount:
                                    controller.customRingtoneNames.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Obx(
                                    () => ListTile(
                                      onTap: () async {
                                        await AudioUtils
                                            .stopPreviewCustomSound();
                                        controller.isPlaying.value = false;
                                        controller.previousRingtone =
                                            controller.customRingtoneName.value;

                                        controller.customRingtoneName.value =
                                            controller
                                                .customRingtoneNames[index];

                                        if (controller
                                                .customRingtoneName.value !=
                                            controller.previousRingtone) {
                                          await AudioUtils
                                              .updateRingtoneCounterOfUsage(
                                            customRingtoneName: controller
                                                .customRingtoneName.value,
                                            counterUpdate:
                                                CounterUpdate.increment,
                                          );

                                          await AudioUtils
                                              .updateRingtoneCounterOfUsage(
                                            customRingtoneName:
                                                controller.previousRingtone,
                                            counterUpdate:
                                                CounterUpdate.decrement,
                                          );
                                        }
                                      },
                                      tileColor: controller
                                                  .customRingtoneName ==
                                              controller
                                                  .customRingtoneNames[index]
                                          ? themeController
                                              .primaryBackgroundColor.value
                                          : themeController
                                              .secondaryBackgroundColor.value,
                                      title: Text(
                                        controller.customRingtoneNames[index],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Obx(
                                        () => Wrap(
                                          children: [
                                            if (controller
                                                    .customRingtoneName.value ==
                                                controller
                                                    .customRingtoneNames[index])
                                              IconButton(
                                                onPressed: () => onTapPreview(
                                                  controller
                                                          .customRingtoneNames[
                                                      index],
                                                ),
                                                icon: Icon(
                                                  (controller.isPlaying.value &&
                                                          controller
                                                                  .customRingtoneName
                                                                  .value ==
                                                              controller
                                                                      .customRingtoneNames[
                                                                  index])
                                                      ? Icons.stop
                                                      : Icons.play_arrow,
                                                  color: (controller.isPlaying
                                                              .value &&
                                                          controller
                                                                  .customRingtoneName
                                                                  .value ==
                                                              controller
                                                                      .customRingtoneNames[
                                                                  index])
                                                      ? const Color.fromARGB(
                                                          255,
                                                          116,
                                                          111,
                                                          110,
                                                        ) // Change this color to red
                                                      : kprimaryColor,
                                                ),
                                              ),
                                            if (!defaultRingtones.contains(
                                              controller
                                                  .customRingtoneNames[index],
                                            ))
                                              IconButton(
                                                onPressed: () async {
                                                  await controller
                                                      .deleteCustomRingtone(
                                                    ringtoneName: controller
                                                            .customRingtoneNames[
                                                        index],
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (String value) async {
                          if (value == 'upload') {
                            Utils.hapticFeedback();
                            await AudioUtils.stopPreviewCustomSound();
                            controller.isPlaying.value = false;
                            controller.previousRingtone =
                                controller.customRingtoneName.value;
                            await controller.saveCustomRingtone();
                          } else if (value == 'system') {
                            Utils.hapticFeedback();
                            await AudioUtils.stopPreviewCustomSound();
                            controller.isPlaying.value = false;

                            // Load system ringtones
                            await controller.loadSystemRingtones();

                            // Show system ringtones dialog
                            Get.dialog(
                              Dialog(
                                backgroundColor: themeController
                                    .secondaryBackgroundColor.value,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context)
                                            .size
                                            .height *
                                        0.7, // Limit to 70% of screen height
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'System Ringtones'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                        const SizedBox(height: 16),
                                        Expanded(
                                          child: Obx(() {
                                            if (controller
                                                .isLoadingSystemRingtones
                                                .value) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator(),);
                                            }

                                            if (controller
                                                .systemRingtones.isEmpty) {
                                              return Center(
                                                child: Text(
                                                  'No system ringtones found'
                                                      .tr,
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }

                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: controller
                                                  .systemRingtones.length,
                                              itemBuilder: (context, index) {
                                                final ringtone = controller
                                                    .systemRingtones[index];
                                                final title =
                                                    ringtone['title'] as String;
                                                final uri =
                                                    ringtone['uri'] as String;

                                                return ListTile(
                                                  title: Text(
                                                    title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  onTap: () async {
                                                    // Stop any playing preview
                                                    await AudioUtils
                                                        .stopPreviewCustomSound();
                                                    await AudioUtils
                                                        .stopSystemRingtone();

                                                    // Save the selected system ringtone
                                                    await controller
                                                        .saveSystemRingtone(
                                                            title, uri,);
                                                    Get.back(); // Close system ringtones dialog
                                                  },
                                                  trailing: IconButton(
                                                    icon: const Icon(
                                                        Icons.play_arrow,),
                                                    onPressed: () async {
                                                      // Preview the ringtone
                                                      await AudioUtils
                                                          .stopPreviewCustomSound();
                                                      await AudioUtils
                                                          .stopSystemRingtone();
                                                      await AudioUtils
                                                          .playSystemRingtone(
                                                              uri,);
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            AudioUtils.stopSystemRingtone();
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kprimaryColor,
                                          ),
                                          child: Text('Cancel'.tr),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'upload',
                            child: Row(
                              children: [
                                const Icon(Icons.upload_file,
                                    size: 20, color: kprimaryColor,),
                                const SizedBox(width: 10),
                                Text(
                                  'Upload Ringtone'.tr,
                                  style: TextStyle(
                                    color:
                                        themeController.primaryTextColor.value,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'system',
                            child: Row(
                              children: [
                                const Icon(Icons.phone_android,
                                    size: 20, color: kprimaryColor,),
                                const SizedBox(width: 10),
                                Text(
                                  'System Ringtones'.tr,
                                  style: TextStyle(
                                    color:
                                        themeController.primaryTextColor.value,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        color: themeController.secondaryBackgroundColor.value,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: OutlinedButton(
                          onPressed: null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add,
                                  size: 16, color: kprimaryColor,),
                              const SizedBox(width: 5),
                              Text(
                                'Add Ringtone'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: kprimaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Utils.hapticFeedback();
                          await AudioUtils.stopPreviewCustomSound();
                          controller.isPlaying.value = false;
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kprimaryColor,
                        ),
                        child: Text(
                          'Done'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.secondaryTextColor.value,
                              ),
                        ),
                      ),
                    ],
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
                              ? themeController.primaryDisabledTextColor.value
                              : themeController.primaryTextColor.value,
                        ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: (controller.label.value.trim().isEmpty)
                    ? themeController.primaryDisabledTextColor.value
                    : themeController.primaryTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
