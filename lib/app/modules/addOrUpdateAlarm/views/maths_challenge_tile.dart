import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class MathsChallenge extends StatelessWidget {
  const MathsChallenge({
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
            'Maths',
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
                title: 'Math problems',
                description: 'You will have to solve simple math problems of'
                    ' the chosen difficulty level to'
                    ' dismiss the alarm.',
                iconData: Icons.calculate,
                isLightMode: themeController.isLightMode.value,
              );
            },
          ),
        ],
      ),
      onTap: () {
        Utils.hapticFeedback();
        controller.isMathsEnabled.value = true;
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'Solve Maths questions',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Text(
                  Utils.getDifficultyLabel(controller.mathsDifficulty.value),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  Utils.generateMathProblem(
                    controller.mathsDifficulty.value,
                  )[0],
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor.withOpacity(0.78)
                            : kprimaryTextColor.withOpacity(0.78),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Slider.adaptive(
                    min: 0.0,
                    max: 2.0,
                    thumbColor: kprimaryColor,
                    activeColor: kprimaryColor,
                    divisions: 2,
                    value: controller.mathsSliderValue.value,
                    onChanged: (newValue) {
                      Utils.hapticFeedback();
                      controller.mathsSliderValue.value = newValue;
                      controller.mathsDifficulty.value =
                          Utils.getDifficulty(newValue);
                    },
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NumberPicker(
                        value: controller.numMathsQuestions.value,
                        minValue: 1,
                        maxValue: 100,
                        onChanged: (value) {
                          Utils.hapticFeedback();
                          controller.numMathsQuestions.value = value;
                        },
                      ),
                      Text(
                        controller.numMathsQuestions.value > 1
                            ? 'questions'
                            : 'question',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          'Save',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryTextColor
                                    : ksecondaryTextColor,
                              ),
                        ),
                        onPressed: () async {
                          Utils.hapticFeedback();
                          Get.back();
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryTextColor
                                    : ksecondaryTextColor,
                              ),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          controller.isMathsEnabled.value = false;
                          Get.back();
                        },
                      ),
                    ],
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
                controller.isMathsEnabled == true
                    ? Utils.getDifficultyLabel(controller.mathsDifficulty.value)
                    : 'Off',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: (controller.isMathsEnabled.value == false)
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
