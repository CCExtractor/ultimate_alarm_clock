import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class ShakeToDismiss extends StatelessWidget {
  const ShakeToDismiss({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Shake to dismiss',
        style: TextStyle(color: kprimaryTextColor),
      ),
      onTap: () {
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: ksecondaryBackgroundColor,
          title: 'Number of shakes',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NumberPicker(
                  value: controller.shakeTimes.value,
                  minValue: 0,
                  maxValue: 100,
                  onChanged: (value) {
                    if (value > 0) {
                      controller.isShakeEnabled.value = true;
                    } else {
                      controller.isShakeEnabled.value = false;
                    }
                    controller.shakeTimes.value = value;
                  },
                ),
                Text(controller.shakeTimes.value > 1 ? 'times' : 'time')
              ],
            ),
          ),
        );
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.shakeTimes.value > 0
                    ? controller.shakeTimes.value > 1
                        ? '${controller.shakeTimes.value} times'
                        : '${controller.shakeTimes.value} time'
                    : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isShakeEnabled.value == false)
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: kprimaryDisabledTextColor,
            )
          ],
        ),
      ),
    );
  }
}
