import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class DeleteAfterGoesOff extends StatelessWidget {
  const DeleteAfterGoesOff({
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
      title: Text(
        'Delete After Goes Off',
        style: TextStyle(
          color: themeController.isLightMode.value
              ? kLightPrimaryTextColor
              : kprimaryTextColor,
        ),
      ),
      onTap: () {
        Utils.hapticFeedback();
        controller.deleteAfterGoesOff.value =
            !controller.deleteAfterGoesOff.value;
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () {
                return Switch.adaptive(
                  value: controller.deleteAfterGoesOff.value,
                  activeColor: ksecondaryColor,
                  onChanged: (value) {
                    Utils.hapticFeedback();
                    controller.deleteAfterGoesOff.value = value;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
