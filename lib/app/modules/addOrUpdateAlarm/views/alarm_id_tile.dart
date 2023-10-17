import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmIDTile extends StatelessWidget {
  const AlarmIDTile({
    super.key,
    required this.controller,
    required this.width,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: (controller.isSharedAlarmEnabled.value == true)
            ? ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Clipboard.setData(ClipboardData(text: controller.alarmID));
                  Get.snackbar(
                    'Success!',
                    'Alarm ID has been copied!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: themeController.isLightMode.value
                        ? kLightSecondaryTextColor
                        : ksecondaryTextColor,
                    maxWidth: width,
                    duration: const Duration(seconds: 2),
                  );
                },
                title: Text(
                  'Alarm ID',
                  style: TextStyle(
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor
                        : kprimaryTextColor,
                  ),
                ),
                trailing: InkWell(
                  child: Icon(
                    Icons.copy,
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor.withOpacity(0.7)
                        : kprimaryTextColor.withOpacity(0.7),
                  ),
                ),
              )
            : ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Get.defaultDialog(
                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: themeController.isLightMode.value
                        ? kLightSecondaryBackgroundColor
                        : ksecondaryBackgroundColor,
                    title: 'Disabled!',
                    titleStyle: Theme.of(context).textTheme.displaySmall,
                    content: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'To copy Alarm ID you have enable shared alarm!',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                kprimaryColor,
                              ),
                            ),
                            child: Text(
                              'Okay',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryTextColor
                                        : ksecondaryTextColor,
                                  ),
                            ),
                            onPressed: () {
                              Utils.hapticFeedback();
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                title: Text(
                  'Alarm ID',
                  style: TextStyle(
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor
                        : kprimaryTextColor,
                  ),
                ),
                trailing: InkWell(
                  child: Icon(
                    Icons.lock,
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor.withOpacity(0.7)
                        : kprimaryTextColor.withOpacity(0.7),
                  ),
                ),
              ),
      ),
    );
  }
}
