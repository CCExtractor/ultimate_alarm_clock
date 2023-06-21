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
    var height = Get.height;
    var width = Get.width;
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
        title: Row(
          children: [
            const Text(
              'Enable Activity',
              style: TextStyle(color: kprimaryTextColor),
            ),
            IconButton(
              icon: Icon(
                Icons.info_sharp,
                size: 21,
                color: kprimaryTextColor.withOpacity(0.3),
              ),
              onPressed: () {
                Get.bottomSheet(BottomSheet(
                    backgroundColor: ksecondaryBackgroundColor,
                    onClosing: () {},
                    builder: (context) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.2,
                                width: width,
                                child: Icon(
                                  Icons.screen_lock_portrait_outlined,
                                  color: kprimaryTextColor,
                                  size: height * 0.1,
                                ),
                              ),
                              Text(
                                "Screen activity cancellation",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  "This feature will automatically cancel the alarm if you've been using your device for a set number of minutes.",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }));
              },
            ),
          ],
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
