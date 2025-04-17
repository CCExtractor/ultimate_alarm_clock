import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Ring On',
                    style: TextStyle(
                      color: themeController.primaryTextColor.value,
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
                            ? '${controller.selectedDate.value.toString().substring(0, 11)}'
                            : 'Off',
                        style: TextStyle(
                          color: !controller.isFutureDate.value ?
                          themeController.primaryDisabledTextColor.value
                                : themeController.primaryTextColor.value,
                        ),
                      ),
                    ), Icon(
                      Icons.chevron_right,
                      color: !(controller.isFutureDate.value)
                          ? themeController.primaryDisabledTextColor.value
                          : themeController.primaryTextColor.value,
                    ),]
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
