import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controller/stopwatch_controller.dart';

class StopWatchPage extends GetView<StopwatchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                '${controller.hourDigit}:${controller.minuteDigit}:${controller.secondDigit}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF252526),
                ),
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.laps.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        
                        title: Text(
                          'Lap ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          controller.laps[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      controller.start();
                    },
                    child: Text(
                      controller.isStarted.value ? 'Pause' : 'Start',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
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
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    controller.reset();
                  },
                  child: Text(
                    'Reset',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
