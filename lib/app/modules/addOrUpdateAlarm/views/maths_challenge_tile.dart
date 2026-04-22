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
    double sliderValue;
    int noOfMathQues;
    bool isMathsEnabled;
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          // saving initial values of sliders & numbers
          isMathsEnabled = controller.isMathsEnabled.value;
          sliderValue = controller.mathsSliderValue.value;
          noOfMathQues = controller.numMathsQuestions.value;
          
          _showMathSettingsBottomSheet(context, isMathsEnabled, sliderValue, noOfMathQues);
        },
        child: ListTile(
          leading: Icon(
            controller.isMathsEnabled.value ? Icons.calculate : Icons.calculate_outlined,
            color: controller.isMathsEnabled.value 
                ? kprimaryColor 
                : themeController.primaryDisabledTextColor.value,
          ),
          title: Text(
            'Math Challenge'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          subtitle: Text(
            controller.isMathsEnabled.value && controller.numMathsQuestions.value > 0
                ? '${Utils.getDifficultyLabel(controller.mathsDifficulty.value).tr} • ${controller.numMathsQuestions.value} questions'
                : 'Disabled'.tr,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: themeController.primaryDisabledTextColor.value,
          ),
        ),
      ),
    );
  }

  void _showMathSettingsBottomSheet(BuildContext context, bool initialIsMathsEnabled, double initialSliderValue, int initialNoOfMathQues) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeController.secondaryBackgroundColor.value,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calculate,
                          color: kprimaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Math Challenge'.tr,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: themeController.primaryTextColor.value,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Enable/Disable Switch
                          _buildSection(
                            title: 'Enable Math Challenge'.tr,
                            subtitle: 'Require solving math problems'.tr,
                            child: Obx(() => Switch.adaptive(
                              value: controller.isMathsEnabled.value,
                              onChanged: (value) {
                                Utils.hapticFeedback();
                                controller.isMathsEnabled.value = value;
                                if (!value) {
                                  controller.numMathsQuestions.value = 0;
                                } else if (controller.numMathsQuestions.value == 0) {
                                  controller.numMathsQuestions.value = 3;
                                }
                              },
                              activeColor: kprimaryColor,
                            )),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Settings (when enabled)
                          Obx(() => controller.isMathsEnabled.value
                              ? Column(
                                  children: [
                                    // Difficulty Section
                                    _buildSection(
                                      title: 'Difficulty Level'.tr,
                                      subtitle: 'Choose problem complexity'.tr,
                                      child: Column(
                                        children: [
                                          // Preview problem
                                          Obx(() => Container(
                                            padding: const EdgeInsets.all(16),
                                            margin: const EdgeInsets.only(bottom: 16),
                                            decoration: BoxDecoration(
                                              color: kprimaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: kprimaryColor.withOpacity(0.3),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  Utils.getDifficultyLabel(controller.mathsDifficulty.value).tr,
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: kprimaryColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  Utils.generateMathProblem(controller.mathsDifficulty.value)[0],
                                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    color: themeController.primaryTextColor.value,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                          
                                          // Difficulty slider
                                          Obx(() => Slider.adaptive(
                                            min: 0.0,
                                            max: 2.0,
                                            divisions: 2,
                                            value: controller.mathsSliderValue.value,
                                            onChanged: (newValue) {
                                              Utils.hapticFeedback();
                                              controller.mathsSliderValue.value = newValue;
                                              controller.mathsDifficulty.value = Utils.getDifficulty(newValue);
                                            },
                                            activeColor: kprimaryColor,
                                            inactiveColor: kprimaryColor.withOpacity(0.3),
                                          )),
                                          
                                          // Difficulty labels
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Easy'.tr,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: themeController.primaryDisabledTextColor.value,
                                                ),
                                              ),
                                              Text(
                                                'Medium'.tr,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: themeController.primaryDisabledTextColor.value,
                                                ),
                                              ),
                                              Text(
                                                'Hard'.tr,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: themeController.primaryDisabledTextColor.value,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Number of Questions
                                    _buildSection(
                                      title: 'Number of Questions'.tr,
                                      subtitle: 'How many problems to solve'.tr,
                                      child: Column(
                                        children: [
                                          Obx(() => Text(
                                            controller.numMathsQuestions.value.toString(),
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: kprimaryColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                                          const SizedBox(height: 16),
                                          NumberPicker(
                                            value: controller.numMathsQuestions.value,
                                            minValue: 1,
                                            maxValue: 20,
                                            onChanged: (value) {
                                              Utils.hapticFeedback();
                                              controller.numMathsQuestions.value = value;
                                            },
                                            itemWidth: Utils
                                                .getResponsiveNumberPickerItemWidth(
                                              context,
                                              screenWidth: MediaQuery.of(context).size.width,
                                              baseWidthFactor: 0.2,
                                            ),
                                            textStyle: Utils
                                                .getResponsiveNumberPickerTextStyle(
                                              context,
                                              baseFontSize: 16,
                                              color: themeController.primaryDisabledTextColor.value,
                                            ),
                                            selectedTextStyle: Utils
                                                .getResponsiveNumberPickerSelectedTextStyle(
                                              context,
                                              baseFontSize: 20,
                                              color: kprimaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container()),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: themeController.secondaryBackgroundColor.value,
                      border: Border(
                        top: BorderSide(
                          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              // Reset to initial values
                              controller.isMathsEnabled.value = initialIsMathsEnabled;
                              controller.mathsSliderValue.value = initialSliderValue;
                              controller.numMathsQuestions.value = initialNoOfMathQues;
                              controller.mathsDifficulty.value = Utils.getDifficulty(initialSliderValue);
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Cancel'.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: themeController.primaryTextColor.value,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Done'.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeController.primaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
