import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class EnableSortedAlarmList extends StatefulWidget {
  const EnableSortedAlarmList({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final SettingsController controller;
  final ThemeController themeController;

  final double height;
  final double width;

  @override
  State<EnableSortedAlarmList> createState() => _EnableSortedAlarmListState();
}

class _EnableSortedAlarmListState extends State<EnableSortedAlarmList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.91,
      height: widget.height * 0.1,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(18),
        ),
        color: widget.themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 20),
        
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Enable Sorted Alarm List'.tr,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: widget.themeController.isLightMode.value
                            ? kLightPrimaryTextColor
                            : kprimaryTextColor,
                      ),
                  softWrap: true,
                ),
              ),
              Obx(
                () => Switch.adaptive(
                  value: widget.controller.isSortedAlarmListEnabled.value,
                  activeColor: ksecondaryColor,
                  onChanged: (bool value) async {
                    widget.controller.toggleSortedAlarmList(value);
                    Utils.hapticFeedback();
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
