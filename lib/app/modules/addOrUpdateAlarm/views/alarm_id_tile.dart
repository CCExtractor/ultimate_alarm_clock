import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class AlarmIDTile extends StatelessWidget {
  const AlarmIDTile({
    super.key,
    required this.controller,
    required this.width,
  });

  final AddOrUpdateAlarmController controller;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: (controller.isSharedAlarmEnabled.value == true)
              ? ListTile(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: controller.alarmID));
                    Get.snackbar(
                      'Success!',
                      'Alarm ID has been copied!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: ksecondaryTextColor,
                      maxWidth: width,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  title: const Text(
                    'Alarm ID',
                    style: TextStyle(color: kprimaryTextColor),
                  ),
                  trailing: InkWell(
                    child: Icon(Icons.copy,
                        color: kprimaryTextColor.withOpacity(0.7)),
                  ))
              : ListTile(
                  onTap: () {
                    Get.defaultDialog(
                        titlePadding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: ksecondaryBackgroundColor,
                        title: 'Disabled!',
                        titleStyle: Theme.of(context).textTheme.displaySmall,
                        content: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                  "To copy Alarm ID you have enable shared alarm!"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kprimaryColor)),
                                child: Text(
                                  'Okay',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: ksecondaryTextColor),
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            )
                          ],
                        ));
                  },
                  title: const Text(
                    'Alarm ID',
                    style: TextStyle(color: kprimaryTextColor),
                  ),
                  trailing: InkWell(
                    child: Icon(
                      Icons.lock,
                      color: kprimaryTextColor.withOpacity(0.7),
                    ),
                  )),
        ));
  }
}
