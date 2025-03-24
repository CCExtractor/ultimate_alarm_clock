import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({
    super.key,
    required this.controller,
    this.alarmIndex,
    this.isSelected,
  });
  final HomeController controller;
  final int? alarmIndex;
  final RxBool? isSelected;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          // If individual toggle button is pressed
          if (widget.isSelected == null) {
            // Toggle the value of that particular alarm
            widget.controller.alarmListPairs.second[widget.alarmIndex!].value =
                !widget.controller.alarmListPairs.second[widget.alarmIndex!].value;

            // Storing the value of the toggle button for that particular alarm
            var buttonValue = widget.controller.alarmListPairs.second[widget.alarmIndex!].value;

            // Storing the alarm model
            AlarmModel alarm = widget.controller.alarmListPairs.first[widget.alarmIndex!];

            // If the alarm is selected
            if (buttonValue) {
              // Increase the number of alarms selected
              widget.controller.numberOfAlarmsSelected.value++;

              // Add this alarm to selected alarm set
              widget.controller.selectedAlarmSet.add(
                alarm.isSharedAlarmEnabled
                    ? Pair(
                        alarm.firestoreId,
                        true,
                      )
                    : Pair(
                        alarm.isarId,
                        false,
                      ),
              );

              // If all the alarms are selected
              if (widget.controller.numberOfAlarmsSelected.value ==
                  widget.controller.alarmListPairs.first.length) {
                widget.controller.isAllAlarmsSelected.value = true;
              }
            } else {
              // Reduce the number of alarms selected
              widget.controller.numberOfAlarmsSelected.value--;

              
              widget.controller.selectedAlarmSet.removeWhere(
                (element) => 
                  alarm.isSharedAlarmEnabled 
                    ? alarm.firestoreId == element.first
                    : alarm.isarId == element.first,
              );

              // If all alarms are not selected, then set all alarm
              // select button at the top to false
              widget.controller.isAllAlarmsSelected.value = false;
            }
          } else {
            // Toggle the all alarm select button
            widget.controller.isAllAlarmsSelected.value =
                !widget.controller.isAllAlarmsSelected.value;

            if (widget.controller.isAllAlarmsSelected.value) {
              
              widget.controller.addAllAlarmsToSelectedAlarmSet();
              widget.controller.numberOfAlarmsSelected.value = 
                  widget.controller.alarmListPairs.first.length;
            } else {
              
              widget.controller.removeAllAlarmsFromSelectedAlarmSet();
              widget.controller.numberOfAlarmsSelected.value = 0;
            }
          }
        },
        child: Container(
          height: 20 * widget.controller.scalingFactor.value,
          width: 20 * widget.controller.scalingFactor.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: themeController.primaryTextColor.value,
              width: 1,
            ),
          ),
          child: widget.isSelected == null // If single toggle button is changed
              ? widget.controller.alarmListPairs.second[widget.alarmIndex!]
                      .value
                  // If it is selected, show a circle at the middle
                  // with an animation
                  ? _animatedCircle()
                  : const SizedBox()
              : widget.isSelected!
                      .value // If all alarm select button is selected
                  ? _animatedCircle()
                  : const SizedBox(),
        ),
      ),
    );
  }

  Widget _animatedCircle() {
    return Obx(
      () => Center(
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.bounceIn,
          height: 10 * widget.controller.scalingFactor.value,
          width: 10 * widget.controller.scalingFactor.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeController.primaryTextColor.value,
          ),
        ),
      ),
    );
  }
}
