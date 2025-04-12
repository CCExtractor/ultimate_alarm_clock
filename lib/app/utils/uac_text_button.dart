import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class UACTextButton extends StatelessWidget {
  final bool isButtonPrimary;
  final bool isTextPrimary;
  final String text;
  final VoidCallback onPressed;

  UACTextButton({
    super.key,
    required this.isButtonPrimary,
    required this.isTextPrimary,
    required this.text,
    required this.onPressed,
  });

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isButtonPrimary
            ? themeController.primaryColor.value
            : themeController.primaryTextColor.value.withOpacity(0.5),
      ),
      onPressed: onPressed,
      child: Obx(
        () => Text(
          text,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: isTextPrimary
                    ? themeController.primaryTextColor.value
                    : themeController.secondaryTextColor.value,
              ),
        ),
      ),
    );
  }
}
