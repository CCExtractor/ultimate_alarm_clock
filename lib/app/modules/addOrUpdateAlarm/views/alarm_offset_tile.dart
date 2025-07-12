import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmOffset extends StatelessWidget {
  const AlarmOffset({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.isSharedAlarmEnabled.value)
          ? InkWell(
              onTap: () {
                Utils.hapticFeedback();
                _showOffsetPicker(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: controller.offsetDuration.value > 0
                      ? themeController.secondaryBackgroundColor.value.withOpacity(0.3)
                      : Colors.transparent,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Icon(
                    controller.isOffsetBefore.value
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_forward_rounded,
                    color: controller.offsetDuration.value > 0
                        ? kprimaryColor
                        : themeController.primaryDisabledTextColor.value,
                  ),
                  title: Text(
                    'Ring time offset'.tr,
                    style: TextStyle(
                      color: themeController.primaryTextColor.value,
                      fontWeight: controller.offsetDuration.value > 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: controller.offsetDuration.value > 0
                      ? Text(
                          _getOffsetDescription(),
                          style: TextStyle(
                            color: themeController.primaryTextColor.value.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        )
                      : null,
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          controller.offsetDuration.value > 0
                              ? '${controller.offsetDuration.value} ${controller.offsetDuration.value > 1 ? 'mins'.tr : 'min'.tr}'
                              : 'Off'.tr,
                          style: TextStyle(
                            fontWeight: controller.offsetDuration.value > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: (controller.offsetDuration.value > 0)
                                ? kprimaryColor
                                : themeController.primaryDisabledTextColor.value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  String _getOffsetDescription() {
    final String direction = controller.isOffsetBefore.value
        ? 'before'.tr
        : 'after'.tr;
    
    final String mainTime = Utils.timeOfDayToString(
      TimeOfDay.fromDateTime(controller.selectedTime.value)
    );
    
    final DateTime offsetTime = Utils.calculateOffsetAlarmTime(
      controller.selectedTime.value,
      controller.isOffsetBefore.value,
      controller.offsetDuration.value,
    );
    
    final String offsetTimeStr = Utils.timeOfDayToString(
      TimeOfDay.fromDateTime(offsetTime)
    );
    
    return '${'Your alarm will ring'.tr} $direction ${'main alarm at'.tr} $offsetTimeStr';
  }

  void _showOffsetPicker(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.secondaryBackgroundColor.value,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set alarm offset'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: themeController.primaryTextColor.value,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose when your alarm should ring relative to the main alarm time'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: themeController.primaryTextColor.value.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      Utils.hapticFeedback();
                      controller.isOffsetBefore.value = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (controller.isOffsetBefore.value)
                          ? kprimaryColor
                          : themeController.primaryTextColor.value.withOpacity(0.10),
                      foregroundColor: (controller.isOffsetBefore.value)
                          ? themeController.secondaryTextColor.value
                          : themeController.primaryTextColor.value,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(12),
                          right: Radius.circular(0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Before'.tr,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      Utils.hapticFeedback();
                      controller.isOffsetBefore.value = false;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (!controller.isOffsetBefore.value)
                          ? kprimaryColor
                          : themeController.primaryTextColor.value.withOpacity(0.10),
                      foregroundColor: (!controller.isOffsetBefore.value)
                          ? themeController.secondaryTextColor.value
                          : themeController.primaryTextColor.value,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(0),
                          right: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'After'.tr,
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: themeController.primaryBackgroundColor.value.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Minutes'.tr,
                    style: TextStyle(
                      color: themeController.primaryTextColor.value.withOpacity(0.7),
                    ),
                  ),
                  Obx(
                    () => NumberPicker(
                      value: controller.offsetDuration.value,
                      minValue: 0,
                      maxValue: 1440,
                      step: 5,
                      onChanged: (value) {
                        Utils.hapticFeedback();
                        controller.offsetDuration.value = value;
                      },
                      selectedTextStyle: TextStyle(
                        color: kprimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      textStyle: TextStyle(
                        color: themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: kprimaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: kprimaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => controller.offsetDuration.value > 0
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kprimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kprimaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: kprimaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getOffsetDescription(),
                              style: TextStyle(
                                fontSize: 14,
                                color: themeController.primaryTextColor.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: width * 0.7,
              child: ElevatedButton(
                onPressed: () {
                  Utils.hapticFeedback();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  foregroundColor: themeController.secondaryTextColor.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Done'.tr),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}