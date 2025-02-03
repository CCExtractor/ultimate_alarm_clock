import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
class SpeakChallenge extends StatelessWidget {
  const SpeakChallenge({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int numberOfWords;
    bool isSpeakEnabled;
    return Obx(
          () => ListTile(
        title: Row(
          children: [
            Text(
              'Speak'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.info_sharp,
                size: 21,
                color: themeController.primaryTextColor.value.withOpacity(0.3),
              ),
              onPressed: () {
                Utils.showModal(
                  context: context,
                  title: 'Speak'.tr,
                  description: 'speakDescription'.tr,
                  iconData: Icons.record_voice_over,
                  isLightMode: themeController.currentTheme.value == ThemeMode.light,
                );
              },
            ),
          ],
        ),
        onTap: () {
          print(controller.numberOfWords.value);
          Utils.hapticFeedback();
          // storing initial state
          numberOfWords = controller.numberOfWords.value;
          isSpeakEnabled = controller.isSpeakEnabled.value;
          Get.defaultDialog(
            onWillPop: () async {
              // presetting values to initial state
              _presetToInitial(numberOfWords, isSpeakEnabled);
              return true;
            },
            titlePadding: const EdgeInsets.only(top: 20),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Number of words'.tr,
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
                          value: controller.numberOfWords.value>0?controller.numberOfWords.value:0,
                          minValue: 0,
                          maxValue: 9,
                          onChanged: (value) {
                            Utils.hapticFeedback();
                            if (value > 0) {
                              controller.isSpeakEnabled.value = true;
                            } else {
                              controller.isSpeakEnabled.value = false;
                            }
                            controller.numberOfWords.value = value;
                          },
                        ),
                        Text(
                          controller.numberOfWords.value > 1
                              ? 'words'.tr
                              : 'word'.tr,
                        ),
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
                              print("here is the ans is ${controller.numberOfWords.value}");
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
                                color: themeController.secondaryTextColor.value,
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
                  controller.numberOfWords.value > 0
                      ? controller.numberOfWords.value > 1
                      ? '${controller.numberOfWords.value} ' + 'words'.tr
                      : '${controller.numberOfWords.value} ' + 'word'.tr
                      : 'Off'.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: (controller.isSpeakEnabled.value == false)
                        ? themeController.primaryDisabledTextColor.value
                        : themeController.primaryTextColor.value,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: themeController.primaryDisabledTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _presetToInitial(int numberOfWords, bool isSpeakEnabled) {
    controller.numberOfWords.value = numberOfWords;
    controller.isSpeakEnabled.value = isSpeakEnabled;
  }
}
