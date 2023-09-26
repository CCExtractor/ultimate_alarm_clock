import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/controllers/alarm_challenge_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class MathsChallengeView extends GetView<AlarmChallengeController> {
  MathsChallengeView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return GestureDetector(
      onTap: () {
        Utils.hapticFeedback();
        controller.restartTimer();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Center(
          child: Column(
            children: [
              Obx(
                () => LinearProgressIndicator(
                  minHeight: 2,
                  value: controller.progress.value,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor),
                ),
              ),
              Expanded(
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (controller.isMathsOngoing.value == Status.ongoing)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Obx(() => Text(
                                        controller.questionText.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Obx(() => Text(
                                        controller.displayValue.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      )),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: (controller.correctAnswer.value)
                                  ? Icon(
                                      Icons.done,
                                      size: height * 0.08,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.close,
                                      size: height * 0.08,
                                      color: Colors.red,
                                    )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: width * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildNumberButton('7'),
                                  _buildNumberButton('8'),
                                  _buildNumberButton('9'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildNumberButton('4'),
                                  _buildNumberButton('5'),
                                  _buildNumberButton('6'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildNumberButton('1'),
                                  _buildNumberButton('2'),
                                  _buildNumberButton('3'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildClearButton(),
                                  _buildNumberButton('0'),
                                  _buildDoneButton(),
                                ],
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () {
        Utils.hapticFeedback();
        controller.onButtonPressed(number);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: themeController.isLightMode.value ? kLightPrimaryTextColor.withOpacity(0.10) : kprimaryTextColor.withOpacity(0.08),
        foregroundColor: themeController.isLightMode.value ? kLightPrimaryTextColor : kprimaryTextColor,
        padding: EdgeInsets.all(16),
        minimumSize: Size(64, 64),
      ),
      child: Text(number, style: TextStyle(fontSize: 24)),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: () {
        Utils.hapticFeedback();
        controller.displayValue.value = '';
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: themeController.isLightMode.value ? kLightPrimaryTextColor.withOpacity(0.40) : kprimaryTextColor.withOpacity(0.5),
        foregroundColor: Colors.black,
        padding: EdgeInsets.all(16),
        minimumSize: Size(64, 64),
      ),
      child: Icon(
        Icons.backspace,
        size: 32,
        color: themeController.isLightMode.value ? kLightPrimaryTextColor.withOpacity(0.7) : kprimaryTextColor.withOpacity(0.7),
      ),
    );
  }

  Widget _buildDoneButton() {
    return ElevatedButton(
      onPressed: () {
        Utils.hapticFeedback();
        if (controller.mathsAnswer.toString() ==
            controller.displayValue.value) {
          controller.numMathsQuestions.value -= 1;
          controller.isMathsOngoing.value = Status.initialized;
          controller.correctAnswer.value = true;
        } else {
          controller.displayValue.value = '';
          controller.correctAnswer.value = false;
          controller.isMathsOngoing.value = Status.initialized;
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kprimaryColor.withOpacity(0.8),
        foregroundColor: themeController.isLightMode.value ? kLightSecondaryTextColor : ksecondaryTextColor,
        padding: EdgeInsets.all(16),
        minimumSize: Size(64, 64),
      ),
      child: Icon(
        Icons.done,
        size: 32,
      ),
    );
  }
}
