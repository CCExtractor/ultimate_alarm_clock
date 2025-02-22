import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SnoozeDurationTile extends StatelessWidget {
  const SnoozeDurationTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          controller.openSnoozeDurationDialog(context, themeController);
        },
        child: ListTile(
          title: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              'Snooze Duration'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
              ),
            ),
          ),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Text(
                  controller.snoozeDuration.value > 0
                      ? '${controller.snoozeDuration.value} min'
                      : 'Off'.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: (controller.snoozeDuration.value <= 0)
                            ? themeController.primaryDisabledTextColor.value
                            : themeController.primaryTextColor.value,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: themeController.primaryDisabledTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
