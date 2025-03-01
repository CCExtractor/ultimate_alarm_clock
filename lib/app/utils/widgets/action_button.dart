import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart'; // Needed for dependency injection

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.backgroundColor = kprimaryColor,
    this.textColor,
    this.width,
    this.height
  });

  final VoidCallback? onPressed;
  final String buttonText;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final themeController = Get.find<ThemeController>();

    final Color computedTextColor = textColor ?? themeController.secondaryTextColor.value;
    final double computedWidth = width ?? double.infinity;
    final double computedHeight = height ?? screenHeight * 0.05;
    final VoidCallback onButtonPressed = onPressed ?? () =>{};
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        width: computedWidth,
        height: computedHeight,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
          ),
          onPressed: () {
            Utils.hapticFeedback();
            onButtonPressed();
            Get.back();
          },
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: computedTextColor,
                ),
          ),
        ),
      ),
    );
  }
}
