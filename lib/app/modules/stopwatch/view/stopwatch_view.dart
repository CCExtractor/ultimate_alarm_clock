import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controller/stopwatch_controller.dart';

class StopWatchPage extends GetView<StopwatchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeDisplay(),
              _buildLapsList(),
              _buildControlButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Obx(
      () => Text(
        '${controller.hourDigit}:${controller.minuteDigit}:${controller.secondDigit}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 70,
        ),
      ),
    );
  }

  Widget _buildLapsList() {
    return Container(
      height: 350,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF252526),
      ),
      child: Obx(
        () => ListView.builder(
          itemCount: controller.laps.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Lap ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  controller.laps[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
          () => _buildControlButton(
            text: controller.isStarted.value ? 'Pause' : 'Start',
            onPressed: () {
              controller.start();
            },
          ),
        ),
        GestureDetector(
          child: const Icon(
            Icons.flag,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            controller.addLap();
          },
        ),
        _buildControlButton(
          text: 'Reset',
          onPressed: () {
            controller.reset();
          },
        ),
      ],
    );
  }

  Widget _buildControlButton(
      {required String text, required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
  }
}
