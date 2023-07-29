import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class SnoozeDurationTile extends StatelessWidget {
  const SnoozeDurationTile({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: ksecondaryBackgroundColor,
          title: 'Select duration',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NumberPicker(
                  value: controller.snoozeDuration.value,
                  minValue: 1,
                  maxValue: 1440,
                  onChanged: (value) {
                    controller.snoozeDuration.value = value;
                  },
                ),
                Text(
                  controller.snoozeDuration.value > 1 ? 'minutes' : 'minute',
                ),
              ],
            ),
          ),
        );
      },
      child: ListTile(
        tileColor: ksecondaryBackgroundColor,
        title: const Text(
          'Snooze Duration',
          style: TextStyle(color: kprimaryTextColor),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.snoozeDuration.value > 0
                    ? '${controller.snoozeDuration.value} min'
                    : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.snoozeDuration.value <= 0)
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: kprimaryDisabledTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
