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
    var width = Get.width;
    var height = Get.height;
    return ListTile(
      title: Row(
        children: [
          const Text(
            'Shake to dismiss',
            style: TextStyle(color: kprimaryTextColor),
          ),
          IconButton(
            icon: Icon(
              Icons.info_sharp,
              size: 21,
              color: kprimaryTextColor.withOpacity(0.3),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: ksecondaryBackgroundColor,
                builder: (context) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Transform.rotate(
                            angle: 15,
                            child: Icon(
                              Icons.vibration,
                              color: kprimaryTextColor,
                              size: height * 0.1,
                            ),
                          ),
                          Text(
                            "Shake to dismiss",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              "You will have to shake your phone a set number of times to dismiss the alarm - no more lazy snoozing :)",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kprimaryColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Understood',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: ksecondaryTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      onTap: () {
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: ksecondaryBackgroundColor,
          title: 'Number of shakes',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Row(
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
                    Text(controller.shakeTimes.value > 1 ? 'times' : 'time'),
                  ],
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor
                              // Set the desired background color
                              ),
                          child: Text(
                            'Done',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: ksecondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
