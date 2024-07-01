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
                    'Success!'.tr,
                    'Alarm ID has been copied!'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: themeController.currentTheme.value == ThemeMode.light
                        ? kLightSecondaryTextColor
                        : ksecondaryTextColor,
                    maxWidth: width,
                    duration: const Duration(seconds: 2),
                  );
                },
                title: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Alarm ID'.tr,
                    style: TextStyle(
                      color: themeController.currentTheme.value == ThemeMode.light
                          ? kLightPrimaryTextColor
                          : kprimaryTextColor,
                    ),
                  ),
                ),
                trailing: InkWell(
                  child: Icon(
                    Icons.copy,
                    color: themeController.currentTheme.value == ThemeMode.light
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
                    backgroundColor: themeController.currentTheme.value == ThemeMode.light
                        ? kLightSecondaryBackgroundColor
                        : ksecondaryBackgroundColor,
                    title: 'Disabled!'.tr,
                    titleStyle: Theme.of(context).textTheme.displaySmall,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            //'To copy Alarm ID you have enable shared alarm!',
                            'toCopyAlarm'.tr,
                            textAlign: TextAlign.center,
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
                              'Okay'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController.currentTheme.value == ThemeMode.light
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
                  'Alarm ID'.tr,
                  style: TextStyle(
                    color: themeController.currentTheme.value == ThemeMode.light
                        ? kLightPrimaryTextColor
                        : kprimaryTextColor,
                  ),
                ),
                trailing: InkWell(
                  child: Icon(
                    Icons.lock,
                    color: themeController.currentTheme.value == ThemeMode.light
                        ? kLightPrimaryTextColor.withOpacity(0.7)
                        : kprimaryTextColor.withOpacity(0.7),
                  ),
                ),
              ),
      ),
    );
  }
}
