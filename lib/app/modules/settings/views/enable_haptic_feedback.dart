import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class EnableHapticFeedback extends StatefulWidget {
  const EnableHapticFeedback({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  State<EnableHapticFeedback> createState() => _EnableHapticFeedbackState();
}

class _EnableHapticFeedbackState extends State<EnableHapticFeedback> {
  final HapticFeebackService _hapticFeebackService = Get.find();

  void _hapticFeedback() {
    _hapticFeebackService.hapticFeedback();
  }

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
          Switch(
            value: _hapticFeebackService.isHapticFeedbackEnabled,
            onChanged: (bool value) async {
              _hapticFeebackService.toggleHapticFeedback(value);
              _hapticFeedback();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
