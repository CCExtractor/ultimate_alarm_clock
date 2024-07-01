import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class EnableHapticFeedback extends StatefulWidget {
  const EnableHapticFeedback({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final SettingsController controller;
  final ThemeController themeController;

  final double height;
  final double width;

  @override
  State<EnableHapticFeedback> createState() => _EnableHapticFeedbackState();
}

class _EnableHapticFeedbackState extends State<EnableHapticFeedback> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.91,
      height: widget.height * 0.1,
      decoration: Utils.getCustomTileBoxDecoration(
        isLightMode: widget.themeController.isLightMode.value,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Enable Haptic Feedback'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Obx(
              () => Switch.adaptive(
                value: widget.controller.isHapticFeedbackEnabled.value,
                activeColor: ksecondaryColor,
                onChanged: (bool value) async {
                  widget.controller.toggleHapticFeedback(value);
                  Utils.hapticFeedback();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
