import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class RepeatOnceTile extends StatelessWidget {
  RepeatOnceTile({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  final HapticFeebackService _hapticFeebackService = Get.find();

  void _hapticFeedback() {
    _hapticFeebackService.hapticFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: ksecondaryBackgroundColor,
      title: const Text(
        'Repeat once',
        style: TextStyle(color: kprimaryTextColor),
      ),
      onTap: () {
        _hapticFeedback();
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
                      _hapticFeedback();
                      controller.isOneTime.value = false;
                    });
              }
              return Switch(
                  value: controller.isOneTime.value,
                  onChanged: (value) {
                    _hapticFeedback();
                    controller.isOneTime.value = value;
                  });
            }),
          ],
        ),
      ),
    );
  }
}
