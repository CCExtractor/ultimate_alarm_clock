import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class AlarmOffset extends StatelessWidget {
  const AlarmOffset({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.isSharedAlarmEnabled.value)
          ? InkWell(
              onTap: () {
                Get.defaultDialog(
                  titlePadding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: ksecondaryBackgroundColor,
                  title: 'Choose duration',
                  titleStyle: Theme.of(context).textTheme.displaySmall,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NumberPicker(
                              value: controller.offsetDuration.value,
                              minValue: 0,
                              maxValue: 1440,
                              onChanged: (value) {
                                controller.offsetDuration.value = value;
                              },
                            ),
                            Text(
                              controller.offsetDuration.value > 1
                                  ? 'minutes'
                                  : 'minute',
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                controller.isOffsetBefore.value = true;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (controller.isOffsetBefore.value)
                                        ? kprimaryColor
                                        : kprimaryTextColor.withOpacity(0.08),
                                foregroundColor:
                                    (controller.isOffsetBefore.value)
                                        ? ksecondaryTextColor
                                        : kprimaryTextColor,
                              ),
                              child: const Text(
                                "Before",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                controller.isOffsetBefore.value = false;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (!controller.isOffsetBefore.value)
                                        ? kprimaryColor
                                        : kprimaryTextColor.withOpacity(0.08),
                                foregroundColor:
                                    (!controller.isOffsetBefore.value)
                                        ? ksecondaryTextColor
                                        : kprimaryTextColor,
                              ),
                              child: const Text(
                                "After",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: ListTile(
                title: const Text('Ring before / after '),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        controller.offsetDuration.value > 0 ? 'Enabled' : 'Off',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: (controller.offsetDuration.value > 0)
                                  ? kprimaryTextColor
                                  : kprimaryDisabledTextColor,
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
            )
          : const SizedBox(),
    );
  }
}
