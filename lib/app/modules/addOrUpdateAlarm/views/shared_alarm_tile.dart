import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/information_button.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class SharedAlarm extends StatelessWidget {
  const SharedAlarm({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;

    return Container(
      child: (controller.userModel != null)
          ? ListTile(
              title: Row(
                children: [
                  const Text(
                    'Shared Alarm',
                    style: TextStyle(color: kprimaryTextColor),
                  ),
                  InformationButton(
                    infoIconData: Icons.share_arrival_time,
                    height: height,
                    width: width,
                    infoTitle: "Shared alarms",
                    infoDescription:
                        "Share alarms with others using the Alarm ID. Each shared user can choose to have their alarm ring before or after the set time.",
                  ),
                ],
              ),
              onTap: () {
                // Toggle the value of isSharedAlarmEnabled
                controller.isSharedAlarmEnabled.value =
                    !controller.isSharedAlarmEnabled.value;
              },
              trailing: Obx(
                () => Switch(
                  onChanged: (value) {
                    // You can optionally add the onChanged callback here as well
                    controller.isSharedAlarmEnabled.value = value;
                  },
                  value: controller.isSharedAlarmEnabled.value,
                ),
              ),
            )
          : ListTile(
              onTap: () {
                Get.defaultDialog(
                  contentPadding: const EdgeInsets.all(10.0),
                  titlePadding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: ksecondaryBackgroundColor,
                  title: 'Disabled!',
                  titleStyle: Theme.of(context).textTheme.displaySmall,
                  content: Column(
                    children: [
                      const Text(
                        "To use this feature, you have to link your Google account!",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kprimaryColor),
                              ),
                              child: Text(
                                'Go to settings',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: ksecondaryTextColor),
                              ),
                              onPressed: () {
                                Get.back();
                                Get.toNamed('/settings');
                              },
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  kprimaryTextColor.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: kprimaryTextColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              title: const Text(
                'Enable Shared Alarm',
                style: TextStyle(color: kprimaryTextColor),
              ),
              trailing: InkWell(
                child: Icon(
                  Icons.lock,
                  color: kprimaryTextColor.withOpacity(0.7),
                ),
              ),
            ),
    );
  }
}
