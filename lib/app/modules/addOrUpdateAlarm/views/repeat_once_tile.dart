import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class RepeatOnceTile extends StatelessWidget {
  const RepeatOnceTile({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: ksecondaryBackgroundColor,
      title: const Text(
        'Repeat once',
        style: TextStyle(color: kprimaryTextColor),
      ),
      onTap: () {
        Utils.hapticFeedback();
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
                return Switch.adaptive(
                    value: false,
                    activeColor: ksecondaryColor,
                    onChanged: (value) {
                      Utils.hapticFeedback();
                      controller.isOneTime.value = false;
                    });
              }
              return Switch.adaptive(
                  value: controller.isOneTime.value,
                  activeColor: ksecondaryColor,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.isOneTime.value = value;
                  });
            }),
          ],
        ),
      ),
    );
  }
}
