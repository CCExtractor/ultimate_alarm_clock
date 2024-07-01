import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../../../utils/utils.dart';

class QuoteTile extends StatelessWidget {
  const QuoteTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: themeController.isLightMode.value
          ? kLightSecondaryBackgroundColor
          : ksecondaryBackgroundColor,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          'Show Motivational Quote'.tr,
          style: TextStyle(
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
          ),
        ),
      ),
      trailing: Obx(
        () => Switch.adaptive(
          value: controller.showMotivationalQuote.value,
          activeColor: ksecondaryColor,
          onChanged: (value) {
            controller.showMotivationalQuote.value = value;
          },
        ),
      ),
      onTap: () {
        Utils.hapticFeedback();
        controller.showMotivationalQuote.value =
            !controller.showMotivationalQuote.value;
      },
    );
  }
}
