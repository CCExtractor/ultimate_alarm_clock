import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class MathsChallenge extends StatelessWidget {
  const MathsChallenge({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return ListTile(
      title: Row(
        children: [
          const Text('Maths'),
          IconButton(
            icon: Icon(
              Icons.info_sharp,
              size: 21,
              color: kprimaryTextColor.withOpacity(0.3),
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: ksecondaryBackgroundColor,
                  builder: (context) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.calculate,
                              color: kprimaryTextColor,
                              size: height * 0.1,
                            ),
                            Text("Math problems",
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                "You will have to solve simple math problems of the chosen difficulty level to dismiss the alarm.",
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
                                  Get.back();
                                },
                                child: Text(
                                  'Understood',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: ksecondaryTextColor),
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
        controller.isMathsEnabled.value = true;
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: ksecondaryBackgroundColor,
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
                      controller.mathsDifficulty.value)[0],
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: kprimaryTextColor.withOpacity(0.78),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Slider(
                    min: 0.0,
                    max: 2.0,
                    divisions: 2,
                    value: controller.mathsSliderValue.value,
                    onChanged: (newValue) {
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
                        onChanged: (value) =>
                            controller.numMathsQuestions.value = value,
                      ),
                      Text(controller.numMathsQuestions.value > 1
                          ? 'questions'
                          : 'question'),
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
                                color: ksecondaryTextColor,
                              ),
                        ),
                        onPressed: () async {
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
                                color: ksecondaryTextColor,
                              ),
                        ),
                        onPressed: () {
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
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: kprimaryDisabledTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
