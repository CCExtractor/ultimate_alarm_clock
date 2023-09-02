import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class EnableHapticFeedback extends StatefulWidget {
  const EnableHapticFeedback({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
  });

  final HapticFeedbackController controller;

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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        color: ksecondaryBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Enable Haptic Feedback',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: kprimaryTextColor,
                ),
          ),
          Obx(
            () => Switch(
              value: widget.controller.isHapticFeedbackEnabled.value,
              onChanged: (bool value) async {
                widget.controller.toggleHapticFeedback(value);
                widget.controller.hapticFeedback();
              },
            ),
          ),
        ],
      ),
    );
  }
}
