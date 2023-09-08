import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class EnableSortedAlarmList extends StatefulWidget {
  const EnableSortedAlarmList({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
  });

  final SettingsController controller;

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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        color: ksecondaryBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Enable Sorted Alarm List',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: kprimaryTextColor,
                ),
          ),
          Obx(
            () => Switch(
              value: widget.controller.isSortedAlarmListEnabled.value,
              onChanged: (bool value) async {
                widget.controller.toggleSortedAlarmList(value);
                Utils.hapticFeedback();
              },
            ),
          ),
        ],
      ),
    );
  }
}
