import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class RepeatOnceTile extends StatelessWidget {
  const RepeatOnceTile({
    super.key,
    required this.controller, required this.hapticFeedbackController,
  });

  final AddOrUpdateAlarmController controller;

  final HapticFeedbackController hapticFeedbackController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: ksecondaryBackgroundColor,
      title: const Text(
        'Repeat once',
        style: TextStyle(color: kprimaryTextColor),
      ),
      onTap: () {
        hapticFeedbackController.hapticFeedback();
        if (!controller.repeatDays.every((element) => element == false)) {
          controller.isOneTime.value = !controller.isOneTime.value;
        }
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(() {
              if (controller.repeatDays.every((element) => element == false)) {
                return Switch(
                    value: false,
                    onChanged: (value) {
                      hapticFeedbackController.hapticFeedback();
                      controller.isOneTime.value = false;
                    });
              }
              return Switch(
                  value: controller.isOneTime.value,
                  onChanged: (value) {
                    hapticFeedbackController.hapticFeedback();
                    controller.isOneTime.value = value;
                  });
            }),
          ],
        ),
      ),
    );
  }
}
