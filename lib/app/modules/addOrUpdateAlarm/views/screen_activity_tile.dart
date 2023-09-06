import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

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
        Utils.hapticFeedback();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: ksecondaryBackgroundColor,
          title: 'Timeout Duration',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NumberPicker(
                      value: controller.activityInterval.value,
                      minValue: 0,
                      maxValue: 1440,
                      onChanged: (value) {
                        Utils.hapticFeedback();
                        if (value > 0) {
                          controller.isActivityenabled.value = true;
                        } else {
                          controller.isActivityenabled.value = false;
                        }
                        controller.activityInterval.value = value;
                      },
                    ),
                    Text(
                      controller.activityInterval.value > 1
                          ? 'minutes'
                          : 'minute',
                    ),
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
                            Utils.hapticFeedback();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  kprimaryColor // Set the desired background color
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
      child: ListTile(
        title: Row(
          children: [
            const Text(
              'Screen Activity',
              style: TextStyle(color: kprimaryTextColor),
            ),
            IconButton(
              icon: Icon(
                Icons.info_sharp,
                size: 21,
                color: kprimaryTextColor.withOpacity(0.3),
              ),
              onPressed: () {
                Utils.hapticFeedback();
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
                              Icon(
                                Icons.screen_lock_portrait_outlined,
                                color: kprimaryTextColor,
                                size: height * 0.1,
                              ),
                              Text("Screen activity based cancellation",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  "This feature will automatically cancel the alarm if you've been using your device for a set number of minutes.",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: width,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kprimaryColor),
                                  ),
                                  onPressed: () {
                                    Utils.hapticFeedback();
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
                              )
                            ],
                          ),
                        ),
                      );
                    });
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
