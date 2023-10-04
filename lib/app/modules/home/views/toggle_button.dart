import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton(
      {super.key, required this.controller, required this.isSelected});
  final HomeController controller;
  final RxBool isSelected;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          widget.isSelected.value = !widget.isSelected.value;
        },
        child: Container(
          height: 20 * widget.controller.scalingFactor.value,
          width: 20 * widget.controller.scalingFactor.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: widget.isSelected.value
              ? Center(
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    curve: Curves.bounceIn,
                    height: 10 * widget.controller.scalingFactor.value,
                    width: 10 * widget.controller.scalingFactor.value,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
