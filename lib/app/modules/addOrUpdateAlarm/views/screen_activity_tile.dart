import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class ScreenActivityTile extends StatelessWidget {
  const ScreenActivityTile({
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
          title: 'Timeout Duration',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NumberPicker(
                  value: controller.activityInterval.value,
                  minValue: 0,
                  maxValue: 1440,
                  onChanged: (value) {
                    if (value > 0) {
                      controller.isActivityenabled.value = true;
                    } else {
                      controller.isActivityenabled.value = false;
                    }
                    controller.activityInterval.value = value;
                  },
                ),
                Text(
                  controller.activityInterval.value > 1 ? 'minutes' : 'minute',
                ),
              ],
            ),
          ),
        );
      },
      child: ListTile(
        title: const Text(
          'Enable Activity',
          style: TextStyle(color: kprimaryTextColor),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.activityInterval.value > 0
                    ? '${controller.activityInterval.value} min'
                    : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isActivityenabled.value == false)
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
