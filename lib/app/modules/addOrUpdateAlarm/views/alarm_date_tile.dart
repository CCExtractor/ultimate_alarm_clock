import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../settings/controllers/theme_controller.dart';
import '../controllers/add_or_update_alarm_controller.dart';

class AlarmDateTile extends StatelessWidget {
  const AlarmDateTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () async {
            controller.datePicker(context);
          },
          child: ListTile(
            tileColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Ring On",
                    style: TextStyle(
                      color: themeController.isLightMode.value
                          ? kLightPrimaryTextColor
                          : kprimaryTextColor,
                    ),
                  ),
                ),
                Obx(
                  () => Wrap(
                    children: [Container(
                      width: 100,
                      alignment: Alignment.centerRight,
                      child: Text(
                        controller.isFutureDate.value
                            ? "${controller.selectedDate.value.toString().substring(0, 11)}"
                            : "Off",
                        style: TextStyle(
                          color: !controller.isFutureDate.value?themeController.isLightMode.value
                              ? kLightPrimaryDisabledTextColor
                              : kprimaryDisabledTextColor
                                : themeController.isLightMode.value
                            ? kLightPrimaryTextColor
                            : kprimaryTextColor,
                        ),
                      ),
                    ), Icon(
                      Icons.chevron_right,
                      color: !(controller.isFutureDate.value)
                          ? themeController.isLightMode.value
                          ? kLightPrimaryDisabledTextColor
                          : kprimaryDisabledTextColor
                          : themeController.isLightMode.value
                          ? kLightPrimaryTextColor
                          : kprimaryTextColor,
                    ),]
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
